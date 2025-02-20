import 'dart:convert';

import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/features/auth/controller/auth_controller.dart';
import 'package:el_shaddai/features/auth/widgets/confirm_button.dart';
import 'package:el_shaddai/features/home/widgets/general_drawer.dart';
import 'package:el_shaddai/features/post/controller/post_controller.dart';
import 'package:el_shaddai/features/post/repository/post_repository.dart';
import 'package:el_shaddai/features/post/widget/add_post_dialog.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    final posts = ref.watch(postsProvider(postType: PostType.feedPost));
    final user = ref.watch(userProvider);

    return Scaffold(
        drawer: const GeneralDrawer(),
        appBar: AppBar(
          title: const Text('Prayer Leaders'),
        ),
        floatingActionButton: user?.role == UserRole.admin
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AddPostDialog(
                        postType: PostType.feedPost,
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: posts.when(
            data: (data) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: data.map((post) {
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
                                    Radius.circular(15))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(DateFormat('EEE, MMM d, yyyy ')
                                      .format(post.createdAt)),
                                  if (user?.role == UserRole.admin)
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    context.pop();
                                                  },
                                                  child: AlertDialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    content: GestureDetector(
                                                      onTap: () {},
                                                      child: ConfirmButton(
                                                        confirmText: 'Delete',
                                                        description:
                                                            'Are you sure you want to delete this post?',
                                                        cancelText: 'Cancel',
                                                        confirmAction: () {
                                                          ref
                                                              .read(
                                                                  postControllerProvider
                                                                      .notifier)
                                                              .deletePost(
                                                                  postType: PostType
                                                                      .feedPost,
                                                                  post.id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.delete))
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
                            child: post.image == null
                                ? Image.asset(
                                    'assets/logo/wings_of_freedom.png',
                                    height: 160,
                                    width: 160,
                                  )
                                : null,
                          ),
                          Text(
                            post.title,
                            style: TextStyle(
                                fontSize: 20, color: context.colors.primary),
                          ),
                          Text(post.content),
                        ],
                      ),
                    );
                  }).toList(), // ✅ Convert map() result into a List
                ),
              );
            },
            error: (x, s) {
              throw x;
            },
            loading: () => const CircularProgressIndicator()));
  }
}
