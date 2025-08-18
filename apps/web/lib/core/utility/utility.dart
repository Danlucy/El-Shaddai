import 'package:url_launcher/url_launcher.dart';

void launchURL(String url) async {
  print('Launching: $url');
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
