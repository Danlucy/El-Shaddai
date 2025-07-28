import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String link) async {
  final Uri url = Uri.parse(Uri.encodeFull(link.trim()));

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
