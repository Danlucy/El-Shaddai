import 'package:constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mobile/features/booking/presentations/booking_screen.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import '../controller/post_controller.dart';

class AddPostDialog extends ConsumerStatefulWidget {
  const AddPostDialog({super.key, required this.postType, this.post});
  final PostType postType;
  final PostModel? post;
  @override
  ConsumerState createState() => _AddPostDialogState();
}

class _AddPostDialogState extends ConsumerState<AddPostDialog> {
  final _formKey = GlobalKey<FormState>(); // 🔹 Key to track form state
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.post?.content ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final postController = ref.read(postControllerProvider.notifier);
    final postState = ref.watch(postControllerProvider);
    final isFeedPost = widget.postType == PostType.feedPost;
    final isEditing = widget.post != null;
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: FractionallySizedBox(
            widthFactor:
                (TextScaleFactor.oldMan ==
                    TextScaleFactor.scaleFactor(textScaler)
                ? 0.95
                : 0.92),
            heightFactor: 0.95,
            child: GlassmorphicContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 20,
              blur: 4,
              border: 1,
              linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.onSurface.withOpac(0.1),
                  Theme.of(context).colorScheme.onSurface.withOpac(0.05),
                ],
                stops: const [0.1, 1],
              ),
              borderGradient: LinearGradient(
                colors: [
                  Colors.white.withOpac(0.5),
                  Colors.white.withOpac(0.5),
                ],
              ),
              child: GestureDetector(
                onTap: () {},
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                isEditing
                                    ? 'Edit Post'
                                    : isFeedPost
                                    ? 'Create Watch Leader Post'
                                    : 'Create User Post',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const Gap(20),
                              GestureDetector(
                                onTap: () async {
                                  await postController.pickImage();
                                  if (mounted) setState(() {});
                                },
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                      (postState.image ?? widget.post?.image) !=
                                          null
                                      ? MemoryImage(
                                          Uint8List.fromList(
                                            postState.image ??
                                                widget.post!.image!,
                                          ),
                                        )
                                      : null,
                                  child:
                                      (postState.image ?? widget.post?.image) ==
                                          null
                                      ? const Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                              const Gap(20),
                              TextFormField(
                                controller: _titleController,
                                onChanged: postController.setTitle,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'This cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(16),
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: null,
                                onChanged: postController.setDescription,
                                decoration: InputDecoration(
                                  labelText: isFeedPost
                                      ? "Description"
                                      : 'Message',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'This cannot be empty';
                                  }
                                  return null;
                                },
                              ),
                              const Gap(20),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.viewInsetsOf(
                                    context,
                                  ).bottom,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      postController.addPost(
                                        postType: widget.postType,
                                        post: widget.post,
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(isEditing ? 'Update' : 'Post'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
