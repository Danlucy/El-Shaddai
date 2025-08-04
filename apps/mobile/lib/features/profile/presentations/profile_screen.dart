import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Only one import needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/profile/widget/role_dsiplay.dart';

import '../../../models/user_model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../home/widgets/general_drawer.dart';
import '../controller/profile_controller.dart';
import '../widget/profile_text_field_widgets.dart';

// --- Constants for User Model Fields ---
class UserModelFields {
  static const String name = 'name';
  static const String uid = 'uid';
  static const String role = 'role';
  static const String image = 'image';
  static const String phoneNumber = 'phoneNumber';
// Add other nullable string fields as constants here if needed
}

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

    // Manually define required fields using constants
    const requiredFields = {
      UserModelFields.name,
      UserModelFields.uid,
      UserModelFields.role,
      UserModelFields.image,
    };

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
    // Renamed context1 to context for consistency
    final user = ref.watch(userProvider);
    final userDataState =
        ref.watch(profileControllerProvider(widget.userModel?.uid));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            GoRouter.of(context).pop(); // Use GoRouter.of(context).pop()
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
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: RoleDisplayWidget(
                            role: widget.userModel?.role,
                          )),
                      ProfileImage(
                          uid: widget.userModel?.uid,
                          ableToEdit: user?.uid == widget.userModel?.uid ||
                              user?.role == UserRole.admin),

                      /// ✅ **Pass `userData` to all fields after loading**
                      ...getNullableStringFields().map((field) {
                        final isPhoneNumber =
                            field == UserModelFields.phoneNumber;
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
                      if (user?.uid == widget.userModel!.uid)
                        OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context, // Use the screen's context
                                  builder: (dialogContext) {
                                    // Named dialogContext for clarity
                                    return GestureDetector(
                                      onTap: () {
                                        GoRouter.of(dialogContext).pop();
                                      },
                                      child: AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        content: GestureDetector(
                                          onTap:
                                              () {}, // Prevent dialog from closing on content tap
                                          child: ConfirmButton(
                                            confirmText: 'Delete',
                                            description:
                                                'Are you sure you want to delete your Account?',
                                            cancelText: 'Cancel',
                                            confirmAction: () {
                                              ref
                                                  .read(authControllerProvider
                                                      .notifier)
                                                  .deleteUser(user!.uid,
                                                      context); // Pass screen context
                                              GoRouter.of(dialogContext)
                                                  .pop(); // Pop dialog after action
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ))
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
