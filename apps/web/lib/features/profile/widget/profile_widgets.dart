import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:models/models.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart' as parser;

import '../controller/profile_controller.dart';

/// Editable text field - editing state controlled by parent
class EditableTextField extends ConsumerStatefulWidget {
  final String fieldName;
  final String label;
  final String? uid;
  final bool canEdit;
  final Map<String, dynamic> userData;
  final int maxLines;
  final bool isPhoneFormat;
  final bool isEditing;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSavePressed;

  const EditableTextField({
    super.key,
    required this.fieldName,
    required this.label,
    required this.uid,
    required this.canEdit,
    required this.userData,
    this.maxLines = 1,
    this.isPhoneFormat = false,
    required this.isEditing,
    this.onEditPressed,
    this.onSavePressed,
  });

  @override
  ConsumerState<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends ConsumerState<EditableTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  String _initialText = '';
  String _currentValue = '';
  String _initialCountryCode = 'MY';
  String _initialPhoneNumber = '';

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _initializeValues();
  }

  void _initializeValues() {
    _initialText = widget.userData[widget.fieldName]?.toString() ?? '';
    _currentValue = _initialText;

    if (widget.isPhoneFormat && _initialText.isNotEmpty) {
      try {
        final parsed = parser.PhoneNumber.parse(_initialText);
        _initialCountryCode = parsed.isoCode.name;
        _initialPhoneNumber = parsed.nsn;
      } catch (e) {
        _initialCountryCode = 'MY';
        _initialPhoneNumber = _initialText;
      }
      _controller.text = _initialPhoneNumber;
    } else {
      _controller.text = _initialText;
    }
  }

  @override
  void didUpdateWidget(covariant EditableTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When editing starts, request focus
    if (widget.isEditing && !oldWidget.isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
    // When editing stops, unfocus
    if (!widget.isEditing && oldWidget.isEditing) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _saveField() {
    final newValue = widget.isPhoneFormat ? _currentValue : _controller.text.trim();
    if (newValue != _initialText && widget.uid != null) {
      ref
          .read(profileControllerProvider(widget.uid!).notifier)
          .updateUserField(widget.fieldName, newValue);
      _initialText = newValue;
    }
  }

  void _onTextChanged(String value) {
    if (!widget.isPhoneFormat) {
      _currentValue = value;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (widget.isEditing) _saveField();
    });
  }

  void _handleButtonPress() {
    if (widget.isEditing) {
      _saveField();
      widget.onSavePressed?.call();
    } else {
      widget.onEditPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: widget.isEditing
          ? theme.colorScheme.surface.withOpac(0.3)
          : Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withOpac(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.primary.withOpac(0.5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintText: widget.isEditing ? 'Enter ${widget.label.toLowerCase()}' : 'Not set',
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpac(0.4)),
      counterText: '',
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpac(0.2)),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface.withOpac(0.08),
                theme.colorScheme.surface.withOpac(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  if (widget.canEdit)
                    IconButton(
                      icon: Icon(
                        widget.isEditing ? Icons.check : Icons.edit_outlined,
                        size: 18,
                      ),
                      onPressed: _handleButtonPress,
                      tooltip: widget.isEditing ? 'Save' : 'Edit',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.isPhoneFormat)
                IntlPhoneField(
                  controller: _controller,
                  focusNode: _focusNode,
                  initialCountryCode: _initialCountryCode,
                  initialValue: _initialPhoneNumber,
                  readOnly: !widget.isEditing,
                  showCountryFlag: true,
                  showDropdownIcon: widget.isEditing,
                  disableLengthCheck: true,
                  autovalidateMode: AutovalidateMode.disabled,
                  style: theme.textTheme.bodyMedium,
                  decoration: inputDecoration,
                  languageCode: 'en',
                  onCountryChanged: (country) {
                    if (!widget.isEditing) return;
                    final number = PhoneNumber(
                      countryCode: country.dialCode,
                      countryISOCode: country.code,
                      number: _controller.text,
                    );
                    _currentValue = number.completeNumber;
                  },
                  onChanged: (phone) {
                    if (!widget.isEditing) return;
                    _currentValue = phone.completeNumber;
                    _onTextChanged(_currentValue);
                  },
                )
              else
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: !widget.isEditing,
                  maxLines: widget.maxLines,
                  onChanged: widget.isEditing ? _onTextChanged : null,
                  style: theme.textTheme.bodyMedium,
                  decoration: inputDecoration,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile avatar with image picking
class ProfileImage extends ConsumerStatefulWidget {
  final String? uid;
  final double size;
  final bool canEdit;

  const ProfileImage({
    super.key,
    required this.uid,
    required this.canEdit,
    this.size = 120,
  });

  @override
  ConsumerState<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends ConsumerState<ProfileImage> {
  Uint8List? _localImage;

  @override
  Widget build(BuildContext context) {
    final userDataState = ref.watch(profileControllerProvider(widget.uid));
    final theme = Theme.of(context);

    return userDataState.when(
      data: (userData) {
        final dbImage = userData[UserModel.fields.image] != null &&
                userData[UserModel.fields.image] is List<dynamic>
            ? Uint8List.fromList(userData[UserModel.fields.image].cast<int>())
            : null;

        final imageData = _localImage ?? dbImage;

        return GestureDetector(
          onTap: () async {
            if (!widget.canEdit) return;
            final pickedImage = await ref
                .read(profileControllerProvider(widget.uid).notifier)
                .pickAndSaveImage();
            if (pickedImage != null && mounted) {
              setState(() => _localImage = pickedImage);
            }
          },
          onLongPress: () {
            if (!widget.canEdit) return;
            ref
                .read(profileControllerProvider(widget.uid).notifier)
                .deleteImage();
            setState(() => _localImage = null);
          },
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: imageData != null
                  ? Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                      width: widget.size,
                      height: widget.size,
                    )
                  : Container(
                      color: theme.colorScheme.surface.withOpacity(0.3),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: widget.size * 0.5,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          if (widget.canEdit)
                            Positioned(
                              bottom: 15,
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: theme.colorScheme.primary.withOpacity(0.8),
                              ),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
      loading: () => SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(),
      ),
      error: (_, __) => Icon(
        Icons.error_outline,
        size: widget.size * 0.5,
        color: theme.colorScheme.error,
      ),
    );
  }
}

/// Role display chip
class RoleDisplayWidget extends StatelessWidget {
  final UserRole? role;
  final TextStyle? textStyle;

  const RoleDisplayWidget({super.key, required this.role, this.textStyle});

  @override
  Widget build(BuildContext context) {
    Color roleColor;
    switch (role) {
      case UserRole.admin:
        roleColor = Colors.red.shade300;
        break;
      case UserRole.watchman:
        roleColor = Colors.orange.shade300;
        break;
      case UserRole.watchLeader:
        roleColor = Colors.blue.shade300;
        break;
      case UserRole.intercessor:
        roleColor = Colors.green.shade300;
        break;
      default:
        roleColor = Colors.grey.shade300;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpac(0.15),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white.withOpac(0.2)),
          ),
          child: Text(
            role?.displayName ?? 'Unknown Role',
            style: (textStyle ?? Theme.of(context).textTheme.titleSmall)
                ?.copyWith(color: roleColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
