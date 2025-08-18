import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key, required this.moreInfo});
  final bool moreInfo;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: moreInfo
            ? [
                // Contact Information Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Email
                    const Icon(Icons.email, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'elshaddai247prayeraltar@gmail.com',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 24),

                    // Phone
                    const Icon(Icons.phone, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      '+60 173044168',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 24),

                    // WhatsApp - Assuming you have a custom WhatsApp icon or use a placeholder
                    InkWell(
                      onTap: () async {
                        final Uri whatsappUrl =
                            Uri.parse("https://wa.me/60173044168");
                        if (await canLaunchUrl(whatsappUrl)) {
                          await launchUrl(whatsappUrl);
                        } else {
                          throw 'Could not launch WhatsApp';
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.message,
                              color: Colors.white70,
                              size: 16), // Placeholder icon
                          SizedBox(width: 8),
                          Text(
                            'WhatsApp ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Address Text
                const Text(
                  'The 247 website belongs to EL Shaddai Prayer Altar. The physical address: 31A-2, Jalan Reko Sentral 1, Jalan Reko, Reko Sentral, 43000 Kajang, Selangor',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                // Copyright Text

                const Text(
                  '© 2024 El Shaddai Church. All Rights Reserved.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ]
            : [
                const SizedBox(height: 16),
                // Copyright Text

                const Text(
                  '© 2024 El Shaddai Church. All Rights Reserved.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
      ),
    );
  }
}
