import 'package:constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/core/widgets/glass_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void goBooking() {
    context.go('/list');
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (kDebugMode) {
      print('Screen size: ${screenSize.width} x ${screenSize.height}');
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        surfaceColor: context.colors.surface,
        secondaryColor: context.colors.secondary,
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: Center(
                  // ✅ Wrap the layout in a ResponsiveScaler to enable auto-scaling.
                  child: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                      ? _buildDesktopLayout(context)
                      : _buildMobileLayout(context),
                ),
              ),
              Spacer(),
              FooterWidget(moreInfo: true),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout for DESKTOP and larger screens.
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Column containing text and button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRichText(context),
                GlassmorphicButton(
                  text: '247 Prayer List',
                  icon: Icons.calendar_today,
                  onPressed: () {
                    goBooking();
                  },
                ),
              ],
            ),
            const SizedBox(width: 48),
            // Large logo
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/logo/main_logo3.png',
                width: 300,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        GradientAnimationText(
          duration: const Duration(seconds: 5),
          text: Text(
            'OR',
            style: const TextStyle(fontFamily: 'FunFont', fontSize: 150),
          ),
          colors: [
            context.colors.primary,
            context.colors.primary,
            context.colors.primary,
            context.colors.secondary,
          ],
        ),
        Text(
          'Download Our App to Join Us',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
        Gap(20),
        DownloadButtons(),
      ],
    );
  }

  /// Layout for MOBILE and TABLET screens.
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      // ✅ Remove SizedBox width constraint
      children: [
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Give text a specific flex ratio instead of Expanded
            Flexible(
              flex: 2, // Text takes 2/5 of width
              child: _buildRichText(context),
            ),
            const SizedBox(width: 16),
            // ✅ Image gets more space to grow
            Flexible(
              flex: 3, // Image takes 3/5 of width
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  scale: 0.1,
                  'assets/logo/main_logo3.png',
                  width: ResponsiveValue<double>(
                    context,
                    defaultValue: 250.0, // Much bigger now
                    conditionalValues: [
                      Condition.largerThan(name: MOBILE, value: 180.0),
                    ],
                  ).value,
                  height: ResponsiveValue<double>(
                    context,
                    defaultValue: 350.0, // Much bigger now
                    conditionalValues: [
                      Condition.largerThan(name: MOBILE, value: 220.0),
                    ],
                  ).value,
                  fit: BoxFit
                      .contain, // ✅ Changed to contain so it scales properly
                ),
              ),
            ),
          ],
        ),
        GlassmorphicButton(
          text: '247 Prayer List',
          icon: Icons.calendar_today,
          onPressed: () {
            goBooking();
          },
        ),
        const Gap(16),
        GradientAnimationText(
          duration: const Duration(seconds: 5),
          text: Text(
            'OR',
            style: const TextStyle(fontFamily: 'FunFont', fontSize: 60),
          ),
          colors: [
            context.colors.primary,
            context.colors.primary,
            context.colors.primary,
            context.colors.secondary,
          ],
        ),
        Text(
          'Download Our App to Join Us',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
        Gap(20),
        DownloadButtons(),
      ],
    );
  }

  /// Helper widget to build the text block with responsive font sizes.
  Widget _buildRichText(BuildContext context) {
    final bool isMobile = !ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          // ✅ Use ResponsiveValue for font sizes for smooth scaling.
          fontSize: ResponsiveValue<double>(
            context,
            defaultValue: 16.0,
            conditionalValues: [
              Condition.largerThan(name: TABLET, value: 24.0),
            ],
          ).value,
          color: context.colors.secondary,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
        children: [
          TextSpan(
            text: 'Welcome to \n',
            style: TextStyle(
              color: context.colors.secondary.withOpac(0.8),
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: 'EL Shaddai 247 ${isMobile ? '\n' : ''}',
            style: TextStyle(
              fontSize: ResponsiveValue<double>(
                context,
                defaultValue: 28.0,
                conditionalValues: [
                  Condition.largerThan(name: TABLET, value: 32.0),
                ],
              ).value,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
              letterSpacing: 1.2,
            ),
          ),
          TextSpan(
            text: 'Prayer Altar\n\n',
            style: TextStyle(
              fontSize: ResponsiveValue<double>(
                context,
                defaultValue: 24.0,
                conditionalValues: [
                  Condition.largerThan(name: TABLET, value: 28.0),
                ],
              ).value,
              fontWeight: FontWeight.w600,
              color: context.colors.secondary,
              letterSpacing: 0.8,
            ),
          ),
          TextSpan(
            text: 'for the ',
            style: TextStyle(
              color: context.colors.secondary.withOpac(0.7),
              fontWeight: FontWeight.w300,
              fontSize: ResponsiveValue<double>(
                context,
                defaultValue: 18.0,
                conditionalValues: [
                  Condition.largerThan(name: TABLET, value: 20.0),
                ],
              ).value,
            ),
          ),
          TextSpan(
            text: 'Kingdom of God.',
            style: TextStyle(
              fontSize:
                  ResponsiveValue<double>(
                    context,
                    defaultValue: 22.0,
                    conditionalValues: [
                      Condition.largerThan(name: TABLET, value: 26.0),
                    ],
                  ).value! *
                  0.9,
              fontWeight: FontWeight.bold,
              color: context.colors.secondary,
              letterSpacing: 0.5,
            ),
          ),
          TextSpan(
            text:
                '\n\nJoin us in our prayers with the \n ${isMobile ? '247 Prayer List' : ' '}',
            style: TextStyle(
              fontSize: ResponsiveValue<double>(
                context,
                defaultValue: 16.0,
                conditionalValues: [
                  Condition.largerThan(name: TABLET, value: 18.0),
                ],
              ).value,
              color: context.colors.secondary.withOpac(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
