import 'package:el_shaddai/features/post/controller/post_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AddPostDialog extends ConsumerStatefulWidget {
  const AddPostDialog({
    super.key,
    required this.postType,
  });
  final PostType postType;
  @override
  ConsumerState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends ConsumerState<AddPostDialog> {
  final _formKey = GlobalKey<FormState>(); // 🔹 Key to track form state
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    ref.watch(postControllerProvider);

    final postController = ref.read(postControllerProvider.notifier);
    final postState = ref.watch(postControllerProvider);
    final isFeedPost = widget.postType == PostType.feedPost;
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        width: width * 0.8,
        height: height * 0.9,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(isFeedPost ? 'Create Prayer Leader Post' : 'Create User Post',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 16),

            /// 🔹 **CircleAvatar Updates When `image` Changes**

            const SizedBox(height: 16),

            /// **📌 Scrollable Fields & Static Bottom Button**
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey, // 🔹 Wrap with Form
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await postController.pickImage();
                            setState(() {}); // ✅ Triggers rebuild inside dialog
                          },
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: postState.image != null
                                ? MemoryImage(
                                    Uint8List.fromList(postState.image!))
                                : null,
                            child: postState.image == null
                                ? const Icon(Icons.camera_alt,
                                    size: 40, color: Colors.white)
                                : null,
                          ),
                        ),
                        const Gap(10),
                        TextFormField(
                          onChanged: postController.setTitle,
                          controller: _titleController,
                          decoration: InputDecoration(
                              labelText: isFeedPost ? "Title" : 'Name',
                              border: const OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: null,
                          onChanged: postController.setDescription,
                          controller: _descriptionController,
                          decoration: InputDecoration(
                              labelText: isFeedPost ? "Description" : 'Message',
                              border: const OutlineInputBorder()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 🔹 **Post Button at Bottom**
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // ✅ Fields are valid, proceed with post
                    postController.addPost(postType: widget.postType);
                    Navigator.pop(context); // Close dialog after posting
                  }
                },
                child: const Text('Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
