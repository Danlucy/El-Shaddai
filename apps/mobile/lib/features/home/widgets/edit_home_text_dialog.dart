import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

import '../../auth/controller/auth_controller.dart';

class EditHomeTextDialog extends ConsumerStatefulWidget {
  const EditHomeTextDialog({super.key, required this.initialText});

  final String initialText;

  @override
  ConsumerState<EditHomeTextDialog> createState() => _EditHomeTextDialogState();
}

class _EditHomeTextDialogState extends ConsumerState<EditHomeTextDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _isSaving) return;

    final user = ref.read(userProvider).value;
    final organization = ref.read(organizationControllerProvider).value;
    if (user == null ||
        organization == null ||
        user.getRoleForOrg(organization.name) != UserRole.admin) {
      showFailureSnackBar(context, 'Only admins can edit the home message.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(homeRepositoryProvider(organization.name))
          .updateHomeText(text: _controller.text, updatedBy: user.uid);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      showFailureSnackBar(context, 'Could not update the home message.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit home message'),
      content: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            minLines: 8,
            maxLines: 16,
            decoration: const InputDecoration(
              labelText: 'Home message',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'The home message cannot be empty.'
                : null,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
