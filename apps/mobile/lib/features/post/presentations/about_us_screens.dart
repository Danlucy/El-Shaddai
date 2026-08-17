import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/widgets/glass_container.dart';
import 'package:mobile/features/post/provider/post_provider.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:util/util.dart';

import '../../../core/widgets/confirm_dialog.dart';
import '../../auth/controller/auth_controller.dart';
import '../../home/widgets/general_drawer.dart';
import '../controller/post_controller.dart';
import '../widget/add_post_dialog.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState createState() => _ContactUsScreensState();
}

class _ContactUsScreensState extends ConsumerState<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    final posts = ref.watch(getCurrentOrgAboutPostsStreamProvider);

    return Scaffold(
      floatingActionButton: user?.currentRole(ref) == UserRole.admin
          ? FloatingActionButton(
              backgroundColor: Colors.transparent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AddPostDialog(postType: PostType.aboutPost);
                  },
                );
              },
              child: const GlassContainer(child: Icon(Icons.add)),
            )
          : null,
      drawer: const GeneralDrawer(),
      appBar: AppBar(title: const Text('About Us')),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: Column(
          children: [
            AutoSizeText(
              'The 247 app belongs to EL Shaddai Prayer Altar.\nThe physical address: 31A-2, Jalan Reko Sentral 1, Jalan Reko, Reko Sentral, 43000 Kajang, Selangor',
              textAlign: TextAlign.center,
              minFontSize: 14,
              maxFontSize: 16,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text:
                        '\n\nIn case of any enquiry, do give us a call or message at ',
                  ),
                  const TextSpan(text: 'Siew-Woei, Ling'),
                  TextSpan(
                    text: ' WhatsApp +60173044168',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri whatsappUrl = Uri.parse(
                          "https://wa.me/60173044168",
                        );
                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl);
                        } else {
                          throw 'Could not launch WhatsApp';
                        }
                      },
                  ),
                  const TextSpan(
                    text:
                        '. \nAlternatively, you can send us an email.\nEmail: ',
                  ),
                  const TextSpan(
                    text: 'Lingsiewwoei@gmail.com',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            posts.when(
              data: (data) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final post = data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row: Avatar, Title, and Admin Menu
                            Row(
                              children: [
                                CircleAvatar(
                                  maxRadius: 15,
                                  minRadius: 10,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: post.image != null
                                      ? MemoryImage(
                                          Uint8List.fromList(post.image!),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    post.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                if (user?.currentRole(ref) == UserRole.admin)
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AddPostDialog(
                                            postType: PostType.aboutPost,
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
                                              backgroundColor:
                                                  Colors.transparent,
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
                                                          postType: PostType
                                                              .aboutPost,
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
                            // Bottom Section: Content Text
                            Text(
                              post.content,
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              error: (x, s) {
                throw x;
              },
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
