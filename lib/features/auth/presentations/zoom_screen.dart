import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:el_shaddai/api/api_repository.dart';
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

    // Listen to changes in the WebView's URL
    controller.currentUrl().then((url) {
      if (url != null) {
        currentUrl.value = url; // Set the initial URL
      }
    });
    // Adding a listener to update URL whenever it changes
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) async {
          currentUrl.value =
              url; // Update the URL when a new page starts loading
          final String? code = (Uri.parse(url).queryParameters['code']);

          if (url.contains('catboy123example.com/?code=')) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Navigator.of(context).pop();

            while (code == null) {
              await Future.delayed(const Duration(
                  seconds: 1)); // Add a delay to avoid excessive checking
            }
            prefs.setString('userAuthenticationCode', code);
            apiRepository.getAccessToken(context, code).then(
              (response) {
                Map<String, dynamic> accessTokenData = {
                  "token": response.data['access_token'],
                  'refresh_token': response.data['refresh_token'],
                  "duration": DateTime.now()
                      .add(Duration(seconds: response.data['expires_in']))
                      .toIso8601String(),
                };
                String encodedMap = json.encode(accessTokenData);
                prefs.setString('accessToken', encodedMap);
                // Handle the response from the Firebase function
              },
            );
            // final HttpsCallable callable =
            //     FirebaseFunctions.instance.httpsCallable('get_access_token');
            // final response = await callable.call(code);
            // print(response.data);
          }
        },
      ),
    );
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
