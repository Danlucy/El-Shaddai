import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZoomScreen extends ConsumerStatefulWidget {
  const ZoomScreen(this.url, {super.key});
  final String? url;

  @override
  ConsumerState createState() => _ZoomScreenState();
}

class _ZoomScreenState extends ConsumerState<ZoomScreen> {
  final ApiRepository apiRepository = ApiRepository();
  late final WebViewController controller;
  final ValueNotifier<String> currentUrl = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          widget.url ?? 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'));

    // Setting up the navigation delegate to listen for URL changes
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) async {
          currentUrl.value = url; // Update the current URL

          // Check if the URL contains the specific query parameter
          if (url.contains('catboy123example.com/?code=')) {
            final Uri uri = Uri.parse(url);
            final String? code = uri.queryParameters['code'];

            if (code != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('userAuthenticationCode', code);

              if (!mounted) return;
              final response =
                  await apiRepository.getAccessToken(context, code);
              ref.read(accessTokenNotifierProvider.notifier).saveAccessToken(
                    AccessToken(
                      token: response.data['access_token'],
                      refreshToken: response.data['refresh_token'],
                      duration: DateTime.now()
                          .add(Duration(seconds: response.data['expires_in'])),
                    ),
                  );
              if (!mounted) return;
              Navigator.of(context).pop(); // Close the WebView

              // Close the WebView

              // Request the access token using the code
            }
          }
        },
      ),
    );

    // Handle the current URL
    controller.currentUrl().then((url) {
      if (url != null) {
        currentUrl.value = url; // Set the initial URL
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<String>(
          valueListenable: currentUrl,
          builder: (context, url, child) {
            return Text(url.isEmpty ? 'Loading...' : url);
          },
        ),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
