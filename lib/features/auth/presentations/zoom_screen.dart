import 'package:el_shaddai/api/api_repository.dart';
import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/features/auth/controller/zoom_auth_controller.dart';
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
          if (url.contains('daniel-ong.com/?code=')) {
            ref.read(authTokenNotifierProvider.notifier).startTokenListener();
            final Uri uri = Uri.parse(url);
            final String? code = uri.queryParameters['code'];
            if (code != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('userAuthenticationCode', code);
              final response = await apiRepository.getAccessToken(code);

              ref.read(accessTokenNotifierProvider.notifier).saveAccessToken(
                    AccessToken(
                      token: response.data['access_token'],
                      refreshToken: response.data['refresh_token'],
                      duration: DateTime.now()
                          .add(Duration(seconds: response.data['expires_in'])),
                    ),
                  );

              navigatorKey.currentState?.pop();
            } else {
              ErrorWidget('Error: No code found in the URL');
              throw Exception('Error: No code found in the URL');
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
        actions: const [],
        title: ValueListenableBuilder<String>(
          valueListenable: currentUrl,
          builder: (context, url, child) {
            print(url);
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
