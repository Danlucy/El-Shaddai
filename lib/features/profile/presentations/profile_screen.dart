import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:el_shaddai/features/profile/controller/profile_controller.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.userModel});
  final UserModel? userModel;

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int? editableFieldIndex;
  List<String> getNullableStringFields() {
    if (widget.userModel == null) return [];

    // Manually define required fields (since Freezed doesn't store `null` values)
    const requiredFields = {'name', 'uid', 'role', 'image'};

    return widget.userModel!
        .toJson()
        .entries
        .where((entry) =>
            !requiredFields.contains(entry.key) && // Exclude required fields
            (entry.value == null ||
                entry.value is String?)) // Keep only nullable String fields
        .map((entry) => entry.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userDataState =
        ref.watch(profileControllerProvider(widget.userModel?.uid));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.pop();
          },
        ),
      ]),
      drawer: const GeneralDrawer(),
      body: userDataState.when(
        loading: () => const Center(
            child: CircularProgressIndicator()), // ✅ Single Loading Indicator
        error: (error, stack) =>
            const Center(child: Text('Error loading profile')),
        data: (userData) => widget.userModel != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.userModel?.name ?? '',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      _ProfileImage(uid: widget.userModel?.uid),

                      const SizedBox(height: 8),

                      /// ✅ **Pass `userData` to all fields after loading**
                      ...getNullableStringFields().map((field) {
                        final isPhoneNumber = field == 'phoneNumber';
                        final index = getNullableStringFields().indexOf(field);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(UserModelFieldLabels.getLabel(field),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: EditableTextField(
                                uid: widget.userModel
                                    ?.uid, // Ensure it's the viewed user's uid
                                fieldName: field,
                                isEditable: editableFieldIndex == index,
                                isPhoneFormat: isPhoneNumber,

                                onEdit: () {
                                  setState(() {
                                    editableFieldIndex =
                                        (editableFieldIndex == index)
                                            ? null
                                            : index;
                                  });
                                },
                                ableToEdit:
                                    user?.uid == widget.userModel?.uid ||
                                        user?.role == UserRole.admin,
                                userData: userData,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              )
            : const Center(
                child: Text('User Not Found \nCheck Internet Connection',
                    textAlign: TextAlign.center, style: errorStyle),
              ),
      ),
    );
  }
}

class EditableTextField extends ConsumerStatefulWidget {
  final String fieldName;
  final bool isEditable;
  final bool isPhoneFormat;
  final VoidCallback onEdit;
  final String? uid;
  final bool ableToEdit;
  final Map<String, dynamic> userData; // ✅ Pass data instead of refetching

  const EditableTextField(
      {super.key,
      required this.fieldName,
      required this.ableToEdit,
      required this.uid,
      required this.isEditable,
      required this.onEdit,
      required this.userData,
      required this.isPhoneFormat // ✅ Accept data from parent
      });

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends ConsumerState<EditableTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _initialText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    // ✅ Set initial text from passed userData
    _initialText = widget.userData[widget.fieldName]?.toString() ?? '';
    _controller.text = _initialText;
  }

  void saveField() {
    final newValue = _controller.text.trim();
    if (newValue != _initialText && widget.uid != null) {
      ref
          .read(profileControllerProvider(widget.uid!)
              .notifier) // Ensure correct uid
          .updateUserField(widget.fieldName, newValue);
      _initialText = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPhoneFormat) {
      return IntlPhoneField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (newValue) => saveField(),
        initialCountryCode: 'MY',
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
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit),
                )
              : null,
        ),
      );
    }
    return TextField(
      controller: _controller,
      maxLines: null,
      focusNode: _focusNode,
      onChanged: (newValue) => saveField(),
      textCapitalization: TextCapitalization.sentences,
      readOnly: !widget.isEditable,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        suffixIcon: widget.ableToEdit
            ? IconButton(
                padding: EdgeInsets.zero,
                iconSize: 16,
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}

class _ProfileImage extends ConsumerStatefulWidget {
  final String? uid;
  const _ProfileImage({super.key, required this.uid});

  @override
  ConsumerState<_ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends ConsumerState<_ProfileImage> {
  Uint8List? _localImage; // Temporary image buffer

  @override
  Widget build(BuildContext context) {
    final userDataState = ref.watch(profileControllerProvider(widget.uid));

    return userDataState.when(
      data: (userData) {
        final imageData = _localImage ??
            (userData['image'] != null && userData['image'] is List<dynamic>
                ? Uint8List.fromList(userData['image'].cast<int>())
                : null);

        return GestureDetector(
          onTap: () async {
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
      error: (error, stack) => Text("Error loading profile"),
    );
  }
}
