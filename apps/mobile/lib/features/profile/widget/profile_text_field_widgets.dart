import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as dad;
import '../controller/profile_controller.dart';
import '../presentations/profile_screen.dart';

class EditableTextField extends ConsumerStatefulWidget {
  final String fieldName;
  final bool isEditable;
  final bool isPhoneFormat;
  final VoidCallback onEdit;
  final String? uid;
  final bool ableToEdit;
  final Map<String, dynamic> userData; // ✅ Pass data instead of refetching

  const EditableTextField({
    super.key,
    required this.fieldName,
    required this.ableToEdit,
    required this.uid,
    required this.isEditable,
    required this.onEdit,
    required this.userData,
    required this.isPhoneFormat, // ✅ Accept data from parent
  });

  @override
  EditableTextFieldState createState() => EditableTextFieldState();
}

class EditableTextFieldState extends ConsumerState<EditableTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _initialText = '';
  String _currentValue = ''; // Store the current value (phone number or text)
  String _initialCountryCode = 'MY'; // Default to Malaysia
  String _initialPhoneNumber = '';

  Timer? _debounceTimer; // For debouncing text input

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // ✅ Set initial text from passed userData
    _initialText = widget.userData[widget.fieldName]?.toString() ?? '';
    _currentValue = _initialText; // Initialize with initial value

    if (widget.isPhoneFormat) {
      if (_initialText.isNotEmpty) {
        try {
          final parsedPhoneNumber = dad.PhoneNumber.parse(_initialText);
          _initialCountryCode = parsedPhoneNumber.isoCode.name;
          _initialPhoneNumber = parsedPhoneNumber.nsn;
        } catch (e) {
          debugPrint('Error parsing phone number: $e'); // Use debugPrint
          // Handle the error (e.g., set default country code or show a message)
          _initialCountryCode = 'MY'; // Default to Malaysia if parsing fails
          _initialPhoneNumber = _initialText; // Use the full number as fallback
        }
      }
      _controller.text =
          _initialPhoneNumber; // Set the national number to the controller
    } else {
      _controller.text = _initialText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void saveField() {
    final newValue = _currentValue.trim();
    if (newValue != _initialText && widget.uid != null) {
      ref
          .read(profileControllerProvider(widget.uid!)
              .notifier) // Ensure correct uid
          .updateUserField(widget.fieldName, newValue);
      _initialText = newValue;
    }
  }

  void _onTextChanged(String newValue) {
    _currentValue = newValue; // Store the text value immediately

    // Cancel any existing timer
    _debounceTimer?.cancel();

    // Set a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      // Only save if the field is currently editable
      if (widget.isEditable) {
        saveField(); // Save after 700ms of no further typing
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPhoneFormat) {
      return IntlPhoneField(
        controller: _controller,
        focusNode: _focusNode,
        onCountryChanged: (countryCode) {
          if (!widget.ableToEdit) return;
          // When the country code changes, rebuild the complete phone number
          // using the current national number and the new country code.
          PhoneNumber number = PhoneNumber(
            countryCode: countryCode.dialCode,
            countryISOCode: countryCode.code,
            number: _controller.text,
          );
          _currentValue = number.completeNumber;
          saveField(); // Save immediately on country change
        },
        onChanged: (number) {
          if (!widget.ableToEdit) return;
          _currentValue = number.completeNumber; // Store the full number
          // For phone numbers, we can save immediately as changes are less frequent
          // or you could also apply debouncing if desired.
          saveField();
        },
        initialCountryCode: _initialCountryCode,
        initialValue: _initialPhoneNumber,
        autovalidateMode: AutovalidateMode.disabled,
        disableLengthCheck: true,
        readOnly: !widget.isEditable,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          suffixIcon: widget.ableToEdit
              ? IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  onPressed: widget.onEdit, // Simply call onEdit
                  icon: const Icon(Icons.edit),
                )
              : null,
        ),
      );
    } else {
      return TextField(
        controller: _controller,
        maxLines: null,
        focusNode: _focusNode,
        onChanged: widget.ableToEdit
            ? _onTextChanged // Use the debounced handler only if editable
            : null,
        textCapitalization: TextCapitalization.sentences,
        readOnly: !widget.isEditable,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          suffixIcon: widget.ableToEdit
              ? IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  onPressed: () {
                    _focusNode.requestFocus(); // Request focus
                    widget.onEdit(); // Toggle edit mode
                  },
                  icon: const Icon(Icons.edit),
                )
              : null,
        ),
      );
    }
  }
}

class ProfileImage extends ConsumerStatefulWidget {
  final String? uid;
  final bool ableToEdit;
  const ProfileImage({
    super.key,
    required this.uid,
    required this.ableToEdit,
  });

  @override
  ConsumerState<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends ConsumerState<ProfileImage> {
  Uint8List? _localImage; // Temporary image buffer

  @override
  Widget build(BuildContext context) {
    final userDataState = ref.watch(profileControllerProvider(widget.uid));

    return userDataState.when(
      data: (userData) {
        final imageData = _localImage ??
            (userData[UserModelFields.image] != null && // Use constant
                    userData[UserModelFields.image] is List<dynamic>
                ? Uint8List.fromList(
                    userData[UserModelFields.image].cast<int>())
                : null);

        return GestureDetector(
          onLongPress: () {
            if (!widget.ableToEdit) return;
            ref
                .read(profileControllerProvider(widget.uid).notifier)
                .deleteImage();
          },
          onTap: () async {
            if (!widget.ableToEdit) return;
            final pickedImage = await ref
                .read(profileControllerProvider(widget.uid).notifier)
                .pickAndSaveImage();

            if (pickedImage != null) {
              setState(() => _localImage = pickedImage);
            }
          },
          child: CircleAvatar(
            minRadius: 50,
            maxRadius: 60,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: imageData != null ? MemoryImage(imageData) : null,
            child: imageData == null
                ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                : null,
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => const Center(
          child: Text("Error loading profile image")), // More specific error
    );
  }
}
