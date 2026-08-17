import 'package:constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:mobile/features/post/provider/post_provider.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:util/util.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../auth/controller/auth_controller.dart';
import '../../home/widgets/general_drawer.dart';
import '../controller/post_controller.dart';
import '../widget/add_post_dialog.dart';

class PrayerLeaderScreen extends ConsumerStatefulWidget {
  const PrayerLeaderScreen({super.key});

  @override
  ConsumerState createState() => _IntercessorsFeedScreenState();
}

class _IntercessorsFeedScreenState extends ConsumerState<PrayerLeaderScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(getCurrentOrgFeedPostsStreamProvider);
    final user = ref.watch(userProvider).value;

    return Scaffold(
      drawer: const GeneralDrawer(),
      appBar: AppBar(title: const Text('Watch Leaders')),
      floatingActionButton: user?.currentRole(ref) == UserRole.admin
          ? FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AddPostDialog(postType: PostType.feedPost);
                  },
                );
              },
              child: const GlassContainer(child: Icon(Icons.add)),
            )
          : null,
      body: Center(
        child: posts.when(
          data: (data) {
            if (data.isEmpty) {
              return const Text(
                'No posts ¯\\_(ツ)_/¯',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final post = data[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colors.secondaryContainer,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat(
                                  'EEE, MMM d, yyyy ',
                                ).format(post.createdAt),
                              ),
                              if (user?.currentRole(ref) == UserRole.admin)
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AddPostDialog(
                                          postType: PostType.feedPost,
                                          post: post,
                                        ),
                                      );
                                      return;
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            context.pop();
                                          },
                                          child: AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: GestureDetector(
                                              onTap: () {},
                                              child: ConfirmDialog(
                                                title: 'Delete Post',
                                                confirmText: 'Delete',
                                                description:
                                                    'Are you sure you want to delete this post?',
                                                cancelText: 'Cancel',
                                                confirmAction: () {
                                                  ref
                                                      .read(
                                                        postControllerProvider
                                                            .notifier,
                                                      )
                                                      .deletePost(
                                                        postType:
                                                            PostType.feedPost,
                                                        post.id,
                                                      );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 8),
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(10),
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: post.image != null
                            ? MemoryImage(Uint8List.fromList(post.image!))
                            : null,
                      ),
                      Text(
                        post.title,
                        style: TextStyle(
                          fontSize: 20,
                          color: context.colors.primary,
                        ),
                      ),
                      Text(post.content),
                    ],
                  ),
                );
              },
            );
          },
          error: (x, s) {
            throw x;
          },
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
