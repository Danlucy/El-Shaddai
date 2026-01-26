import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/core/widgets/animated_background.dart';
import 'package:website/core/widgets/footer_widget.dart';
import 'package:website/core/widgets/glass_button.dart';
import 'package:website/core/widgets/organization_drop_down_button.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        surfaceColor: context.colors.surface,
        secondaryColor: context.colors.secondary,
        child: SafeArea(
          bottom:
              false, // Set false so footer creates its own padding if needed
          child: CustomScrollView(
            slivers: [
              // 1. Your Main Content wrapped in a Sliver
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20,
                  ),
                  child: Center(
                    child: ResponsiveBreakpoints.of(context).largerThan(TABLET)
                        ? _buildDesktopLayout(context)
                        : _buildMobileLayout(context),
                  ),
                ),
              ),

              // 2. The Magic: Fills remaining space to push footer down
              SliverFillRemaining(
                hasScrollBody:
                    false, // Important: Tells flutter this isn't a list
                child: Column(
                  children: [
                    const Spacer(), // Occupies all available empty space
                    FooterWidget(moreInfo: true),
                  ],
                ),
              ),
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
                Gap(40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Step 1: Select the prayer altar to Join',
                        style: TextStyle(fontSize: 20),
                      ),
                      OrganizationSelectionDropdown(),
                    ],
                  ),
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
        Gap(40),
        Text('Step 2: Click here to view the', style: TextStyle(fontSize: 20)),
        GlassmorphicButton(
          fontSize: 28,
          textColour: context.colors.primary,
          text: 'Prayer list',
          icon: Icons.calendar_today,
          onPressed: () {
            goBooking();
          },
        ),
        Gap(30),

        TextButton(
          child: Text('Click for Help!'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  style: TextStyle(fontSize: 26),
                  'How to join the 24/7 prayer altar? Click on Step 1 then Step 2. When you see the prayer list, click on the prayer watch you want to join. In order to display the prayer altar detail (Zoom information or physical address), you have to click to join the session.',
                ),
              ),
            );
          },
        ),
        const Gap(100),
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
          'If you would like to join EL Shaddai Prayer Altar prayer session through the mobile app, download the Android app. The App Store is not available at time being.',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Gap(100),
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

        Gap(30),
        Center(
          child: Column(
            children: [
              Text(
                'Step 1: Select the prayer altar to Join',
                style: TextStyle(fontSize: 20),
              ),
              OrganizationSelectionDropdown(bigger: true),
            ],
          ),
        ),
        Gap(40),
        Text('Step 2: Click here to view the', style: TextStyle(fontSize: 20)),
        GlassmorphicButton(
          fontSize: 28,
          textColour: context.colors.primary,
          text: 'Prayer list',
          icon: Icons.calendar_today,
          onPressed: () {
            goBooking();
          },
        ),
        Gap(30),

        TextButton(
          child: Text('Click for Help!'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  style: TextStyle(fontSize: 26),
                  'How to join the 24/7 prayer altar? Click on Step 1 then Step 2. When you see the prayer list, click on the prayer watch you want to join. In order to display the prayer altar detail (Zoom information or physical address), you have to click to join the session.',
                ),
              ),
            );
          },
        ),
        const Gap(100),
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
          'If you would like to join EL Shaddai Prayer Altar prayer session through the mobile app, download the Android app. The App Store is not available at time being.',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Gap(100),
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
            text: 'EL Shaddai 24/7 ${isMobile ? '\n' : ''}',
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
            text: 'Prayer Altar\n',
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
        ],
      ),
    );
  }
}
