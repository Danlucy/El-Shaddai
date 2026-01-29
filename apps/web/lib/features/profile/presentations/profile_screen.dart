import 'dart:ui';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:util/util.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/features/auth/controller/auth_controller.dart';

import '../controller/profile_controller.dart';
import '../widget/profile_widgets.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.userModel});
  final UserModel? userModel;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Track which field is currently being edited (null = none)
  String? _editingField;

  List<String> getNullableStringFields() {
    if (widget.userModel == null) return [];

    var requiredFields = {
      UserModel.fields.name,
      UserModel.fields.uid,
      UserModel.fields.roles,
      UserModel.fields.image,
      UserModel.fields.fcmToken,
    };

    return widget.userModel!
        .toJson()
        .entries
        .where(
          (entry) =>
              !requiredFields.contains(entry.key) &&
              (entry.value == null || entry.value is String?),
        )
        .map((entry) => entry.key)
        .toList();
  }

  void _setEditingField(String? field) {
    setState(() => _editingField = field);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final user = ref.watch(userProvider).value;
    final userDataState = ref.watch(
      profileControllerProvider(widget.userModel?.uid),
    );
    final theme = Theme.of(context);

    final canEdit = user?.uid == widget.userModel?.uid ||
        user?.currentRole(ref) == UserRole.admin;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: userDataState.when(
        loading: () => AnimatedBackground(
          surfaceColor: theme.colorScheme.surface,
          secondaryColor: theme.colorScheme.secondary,
          child: const Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => AnimatedBackground(
          surfaceColor: theme.colorScheme.surface,
          secondaryColor: theme.colorScheme.secondary,
          child: const Center(child: Text('Error loading profile')),
        ),
        data: (userData) => widget.userModel != null
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: AnimatedBackground(
                                surfaceColor: theme.colorScheme.surface,
                                secondaryColor: theme.colorScheme.secondary,
                                child: const SizedBox.expand(),
                              ),
                            ),
                            SafeArea(
                              bottom: false,
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isDesktop ? 900 : double.infinity,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        _buildProfileHeaderCard(
                                          context,
                                          userData,
                                          canEdit,
                                          isDesktop,
                                        ),
                                        const Gap(24),
                                        if (isDesktop)
                                          _buildDesktopFieldsLayout(
                                            userData,
                                            canEdit,
                                          )
                                        else
                                          _buildMobileFieldsLayout(
                                            userData,
                                            canEdit,
                                          ),
                                        const Gap(24),
                                        if (user?.uid == widget.userModel!.uid)
                                          _buildDeleteAccountButton(
                                            context,
                                            user,
                                          ),
                                        const Gap(40),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : AnimatedBackground(
                surfaceColor: theme.colorScheme.surface,
                secondaryColor: theme.colorScheme.secondary,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpac(0.5),
                      ),
                      const Gap(16),
                      Text(
                        'User Not Found',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const Gap(8),
                      Text(
                        'Check Internet Connection',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpac(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(
    BuildContext context,
    Map<String, dynamic> userData,
    bool canEdit,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isDesktop ? 40 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpac(0.2)),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface.withOpac(0.1),
                theme.colorScheme.surface.withOpac(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: isDesktop
              ? Row(
                  children: [
                    ProfileImage(
                      uid: widget.userModel?.uid,
                      size: 140,
                      canEdit: canEdit,
                    ),
                    const Gap(32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userModel?.name ?? '',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(12),
                          RoleDisplayWidget(
                            role: widget.userModel?.currentRole(ref),
                          ),
                          const Gap(16),
                          Text(
                            'Changes are autosaved',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withOpac(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    ProfileImage(
                      uid: widget.userModel?.uid,
                      size: 120,
                      canEdit: canEdit,
                    ),
                    const Gap(16),
                    Text(
                      widget.userModel?.name ?? '',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(12),
                    RoleDisplayWidget(
                      role: widget.userModel?.currentRole(ref),
                    ),
                    const Gap(12),
                    Text(
                      'Changes are autosaved',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpac(0.5),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String field, Map<String, dynamic> userData, bool canEdit) {
    return EditableTextField(
      uid: widget.userModel?.uid,
      fieldName: field,
      label: UserModelX.getLabel(field),
      canEdit: canEdit,
      userData: userData,
      maxLines: _isLongField(field) ? 3 : 1,
      isPhoneFormat: field == 'phoneNumber',
      isEditing: _editingField == field,
      onEditPressed: () => _setEditingField(field),
      onSavePressed: () => _setEditingField(null),
    );
  }

  Widget _buildDesktopFieldsLayout(
    Map<String, dynamic> userData,
    bool canEdit,
  ) {
    final fields = getNullableStringFields();
    final halfLength = (fields.length / 2).ceil();
    final leftFields = fields.take(halfLength).toList();
    final rightFields = fields.skip(halfLength).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftFields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEditableField(field, userData, canEdit),
              );
            }).toList(),
          ),
        ),
        const Gap(20),
        Expanded(
          child: Column(
            children: rightFields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildEditableField(field, userData, canEdit),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFieldsLayout(Map<String, dynamic> userData, bool canEdit) {
    return Column(
      children: getNullableStringFields().map((field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildEditableField(field, userData, canEdit),
        );
      }).toList(),
    );
  }

  bool _isLongField(String field) {
    return [
      'description',
      'definitionOfGod',
      'godsCalling',
      'recommendation',
    ].contains(field);
  }

  Widget _buildDeleteAccountButton(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.error.withOpac(0.3)),
            color: theme.colorScheme.error.withOpac(0.05),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danger Zone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Permanently delete your account and all associated data.',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpac(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
                onPressed: () => _showDeleteConfirmation(context, user),
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel? user) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: theme.colorScheme.error),
              const Gap(12),
              const Text('Delete Account'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () {
                try {
                  ref
                      .read(authControllerProvider.notifier)
                      .deleteUser(user!.uid, context);
                  Navigator.of(dialogContext).pop();
                  GoRouter.of(context).go('/');
                } catch (e) {
                  rethrow;
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
