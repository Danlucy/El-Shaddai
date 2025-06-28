import 'package:el_shaddai/core/theme.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../packages/constants/lib/src/theme.dart';
import '../../../models/user_model/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/widgets/confirm_button.dart';
import '../../home/widgets/general_drawer.dart';
import '../controller/post_controller.dart';
import '../repository/post_repository.dart';
import '../widget/add_post_dialog.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState createState() => _ContactUsScreensState();
}

class _ContactUsScreensState extends ConsumerState<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final posts = ref.watch(postsProvider(postType: PostType.aboutPost));

    return Scaffold(
        floatingActionButton: user?.role == UserRole.admin
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AddPostDialog(
                        postType: PostType.aboutPost,
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
        drawer: const GeneralDrawer(),
        appBar: AppBar(
          title: const Text('About Us'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(10),
          child: Column(children: [
            Text(
              'The 247 app belongs to EL Shaddai Prayer Altar.\nThe physical address: 31A-2, Jalan Reko Sentral 1, Jalan Reko, Reko Sentral, 43000 Kajang, Selangor',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text:
                          '\n\nIn case of any enquiry, do give us a call or message at '),
                  const TextSpan(text: 'Siew-Woei, Ling'),
                  TextSpan(
                    text: ' WhatsApp +60173044168',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri whatsappUrl =
                            Uri.parse("https://wa.me/60173044168");
                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl);
                        } else {
                          throw 'Could not launch WhatsApp';
                        }
                      },
                  ),
                  const TextSpan(
                      text:
                          '. \nAlternatively, you can send us an email.\nEmail: '),
                  const TextSpan(
                    text: 'Lingsiewwoei@gmail.com',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
            posts.when(
                data: (data) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...data.map((post) => ListTile(
                                leading: CircleAvatar(
                                  maxRadius: 25,
                                  minRadius: 20,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: post.image != null
                                      ? MemoryImage(
                                          Uint8List.fromList(post.image!))
                                      : null,
                                ),
                                title: Text(post.title),
                                subtitle: Text(post.content),
                                trailing: (user?.role == UserRole.admin)
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
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
                                                                      .aboutPost,
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
                                      )
                                    : null,
                              ))
                        ],
                      ),
                    ),
                  );
                },
                error: (x, s) {
                  throw x;
                },
                loading: () => const CircularProgressIndicator())
          ]),
        ));
  }
}
