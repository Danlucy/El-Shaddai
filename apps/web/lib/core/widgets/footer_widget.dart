import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for Clipboard
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/core/constants.dart';

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
          colors: [Colors.black.withOpac(0.9), Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: moreInfo
            ? [
                // Contact Information - Responsive Layout
                _buildResponsiveContactInfo(context),
                const SizedBox(height: 16),

                // Address Text
                const Text(
                  'The 24/7 website belongs to EL Shaddai Prayer Altar. The physical address: 31A-2, Jalan Reko Sentral 1, Jalan Reko, Reko Sentral, 43000 Kajang, Selangor',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
              ]
            : [
                const SizedBox(height: 16),

                // Copyright Text
                const Text(
                  '© since 2024 El Shaddai Prayer Altar. All Rights Reserved.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
      ),
    );
  }

  Widget _buildResponsiveContactInfo(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    if (isDesktop) {
      // Desktop: Show all in one row
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmailWidget(context),
          const SizedBox(width: 24),
          _buildPhoneWidget(context),
          const SizedBox(width: 24),
          _buildWhatsAppWidget(),
        ],
      );
    } else if (isMobile) {
      // Mobile: Stack vertically with smaller spacing
      return Column(
        children: [
          _buildEmailWidget(context),
          const SizedBox(height: 12),
          _buildPhoneWidget(context),
          const SizedBox(height: 12),
          _buildWhatsAppWidget(),
        ],
      );
    } else {
      // Tablet: Two items per row
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmailWidget(context),
              const SizedBox(width: 24),
              _buildPhoneWidget(context),
            ],
          ),
          const SizedBox(height: 12),
          _buildWhatsAppWidget(),
        ],
      );
    }
  }

  Widget _buildEmailWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: emailAddress));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email address copied to clipboard!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.email, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              emailAddress,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                decoration:
                    TextDecoration.underline, // Visual cue it's clickable
                decorationColor: Colors.white30,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: phoneNumber));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number copied to clipboard!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.phone, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Text(
            phoneNumber,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              decoration: TextDecoration.underline, // Visual cue it's clickable
              decorationColor: Colors.white30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppWidget() {
    return InkWell(
      onTap: () async {
        final Uri whatsappUrl = Uri.parse(whatsAppLink);
        if (await canLaunchUrl(whatsappUrl)) {
          await launchUrl(whatsappUrl);
        } else {
          throw 'Could not launch WhatsApp';
        }
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.message, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Text(
            'WhatsApp',
            style: TextStyle(
              color: Colors.green,
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
