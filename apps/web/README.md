# web

## Running the Web App

Run from this directory:

```sh
flutter run -d chrome
```

The web app runs on standard `localhost`.

### Zoom Authentication (Option 2)
Both web and mobile use the unified redirect URL:
`https://daniel-ong.com/zoom-login-successful/`

When a user signs in to Zoom:
1. The app opens Zoom authorization in a popup.
2. After user authorization, Zoom redirects to `https://daniel-ong.com/zoom-login-successful/`.
3. The WordPress page contains a snippet that sends the URL back to the parent window via `postMessage`:
   ```html
   <script>
     if (window.opener) {
       window.opener.postMessage({ 'flutter-web-auth-2': window.location.href }, '*');
       window.opener.postMessage(window.location.href, '*');
       window.close();
     }
   </script>
   ```
4. `flutter_web_auth_2` in the Flutter web app receives the code directly on `localhost` (or whatever origin/port you run on) and completes authentication. No local ports or loopback IPs need to be configured in Zoom.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
