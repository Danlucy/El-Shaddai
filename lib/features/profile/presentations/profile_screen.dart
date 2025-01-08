import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int? _editableFieldIndex; // Tracks the index of the editable field

  // Generate list of nullable property keys
  List<String> textFieldList() {
    final user = ref.watch(userProvider);

    // Check if user is null and return an empty list
    if (user == null) return [];

    // Collect keys of nullable properties
    final List<String> nullableKeys = [];
    user.toJson().forEach((key, value) {
      if (value == null) {
        nullableKeys.add(key); // Add key to the list if the value is null
      }
    });

    return nullableKeys;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> nullableFields = textFieldList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      drawer: const GeneralDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Profile Fields'),
              const SizedBox(height: 8),
              ...nullableFields.asMap().entries.map((entry) {
                final index = entry.key;
                final field = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: EditableTextField(
                    hintText: field,
                    isEditable: _editableFieldIndex == index,
                    onEdit: () {
                      setState(() {
                        if (_editableFieldIndex == index) {
                          _editableFieldIndex = null; // Toggle off edit mode
                        } else {
                          _editableFieldIndex =
                              index; // Set current field to edit mode
                        }
                      });
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableTextField extends StatelessWidget {
  final String hintText;
  final bool isEditable;
  final VoidCallback onEdit;

  const EditableTextField({
    super.key,
    required this.hintText,
    required this.isEditable,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: !isEditable, // Only editable if `isEditable` is true
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: onEdit, // Notify parent to set this field as editable
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
