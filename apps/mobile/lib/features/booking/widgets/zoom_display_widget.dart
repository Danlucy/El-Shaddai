import 'dart:ui';

import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/api/models/access_token_model/access_token_model.dart';
import 'package:mobile/core/utility/url_launcher.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../tip/controller/onboarding_controller.dart';

class ZoomDisplayComponent extends ConsumerStatefulWidget {
  const ZoomDisplayComponent({
    super.key,
  });

  @override
  ConsumerState<ZoomDisplayComponent> createState() =>
      _ZoomDisplayComponentState();
}

class _ZoomDisplayComponentState extends ConsumerState<ZoomDisplayComponent> {
  late TextEditingController _zoomIdController;
  bool _isDigitOnlyInput = true; // State for dynamic letter spacing
  bool _hasTriggeredShowcase = false; // Track if showcase has been triggered

  // Create instance-specific GlobalKeys to avoid conflicts
  late final GlobalKey _zoomIconKey;
  late final GlobalKey _zoomTextFormFieldKey;
  late final GlobalKey _zoomKeyIconKey;

  String _parseIdForDisplay(String? input) {
    if (input == null || input.isEmpty) return '';
    if (input.startsWith('http://') || input.startsWith('https://')) {
      return parseZoomIdFromUrl(input);
    } else {
      return input;
    }
  }

  void _updateLetterSpacingState(String input) {
    final bool startsWithHttp =
        input.startsWith('http://') || input.startsWith('https://');
    final bool isDigitsOnly = RegExp(r'^\d+$').hasMatch(input);

    setState(() {
      _isDigitOnlyInput = !startsWithHttp && isDigitsOnly;
    });
  }

  void _checkAndTriggerShowcase(Set<String> seenTips) {
    if (_hasTriggeredShowcase) return;

    final currentVenue = ref.read(bookingVenueStateProvider);
    const tipId = 'zoom_input_tour_tip';

    if (currentVenue != BookingVenueComponent.zoom &&
        currentVenue != BookingVenueComponent.hybrid) return;

    if (seenTips.contains(tipId)) return;

    _hasTriggeredShowcase = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          _zoomIconKey,
          _zoomTextFormFieldKey,
          _zoomKeyIconKey,
        ]);
        ref.read(onboardingNotifierProvider.notifier).markTipAsSeen(tipId);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize GlobalKeys for this instance
    _zoomIconKey = GlobalKey();
    _zoomTextFormFieldKey = GlobalKey();
    _zoomKeyIconKey = GlobalKey();

    // Initialize controller first
    final initialId =
        _parseIdForDisplay(ref.read(bookingControllerProvider).location?.web);
    _zoomIdController = TextEditingController(text: initialId);
    _updateLetterSpacingState(initialId); // Initialize spacing state
    // Use addPostFrameCallback to safely access ref after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize controller text after the first frame

      _updateLetterSpacingState(initialId);

      // Check if we should trigger the showcase
      _checkAndTriggerShowcase(
          ref.read(onboardingNotifierProvider).value ?? {});
    });
  }

  @override
  void dispose() {
    _zoomIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessTokenAsync = ref.watch(accessTokenNotifierProvider);
    final currentVenue = ref.watch(bookingVenueStateProvider);
    final onboardingState =
        ref.watch(onboardingNotifierProvider); // ✅ this now reacts to updates

    final bool isSignedIn = accessTokenAsync.when(
      data: (token) => token != null,
      loading: () => false,
      error: (_, __) => false,
    );

    // ✅ Only run the showcase check once the onboarding tips are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onboardingState is AsyncData<Set<String>>) {
        _checkAndTriggerShowcase(
            onboardingState.value); // pass the data explicitly
      }
    });

    return Container(
      padding: const EdgeInsets.only(right: 15, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: context.colors.tertiaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Step 1: Showcase the Zoom icon
          Showcase(
            key: _zoomIconKey,
            title: 'Tap on Zoom\'s icon to immediately open Zoom',
            description:
                'Enable Auto Zoom ID in the menu to automatically create Zoom meetings with your account. This auto Zoom meeting will also automatically create a default password if you didn\'t set one.',
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 20,
                backgroundImage: AssetImage('assets/zoom.png'),
              ),
            ),
          ),

          // Step 2: Showcase the TextFormField
          Expanded(
            child: Showcase(
              key: _zoomTextFormFieldKey,
              title: 'Meeting Link or ID',
              description:
                  'Enter Zoom ID (10-11 digits) or a valid Zoom URL. Zoom URL link that are shared are HIGHLY recommended since it includes a link that can allow others to join without entering any password. If you enter a Zoom ID, you will need to enter you password and others need to manually key in to enter your meeting.',
              targetBorderRadius: const BorderRadius.all(Radius.circular(15)),
              child: TextFormField(
                controller: _zoomIdController,
                onChanged: (newInput) {
                  final trimmedInput = newInput.trim();
                  _updateLetterSpacingState(trimmedInput);

                  String? webValueToStore;
                  if (trimmedInput.startsWith('http://') ||
                      trimmedInput.startsWith('https://')) {
                    webValueToStore = trimmedInput;
                  } else if (RegExp(r'^\d{10,11}$').hasMatch(trimmedInput)) {
                    webValueToStore = buildExternalZoomUrl(trimmedInput);
                  } else {
                    webValueToStore = null;
                  }

                  ref
                      .read(bookingControllerProvider.notifier)
                      .setWeb(webValueToStore);
                },
                keyboardType: TextInputType.url,
                validator: (value) {
                  final trimmedValue = value?.trim();
                  if (!isSignedIn &&
                      (trimmedValue == null || trimmedValue.isEmpty)) {
                    return 'Zoom ID is required';
                  }
                  if (trimmedValue != null && trimmedValue.isNotEmpty) {
                    if (trimmedValue.startsWith('http://') ||
                        trimmedValue.startsWith('https://')) {
                      if (Uri.tryParse(trimmedValue) == null) {
                        return 'Invalid URL format';
                      }
                    } else {
                      if (!RegExp(r'^\d{10,11}$').hasMatch(trimmedValue)) {
                        return '10-11 digits or valid URL';
                      }
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: const TextStyle(fontSize: 16, letterSpacing: 1),
                  hintText: isSignedIn ? 'Auto Zoom ID' : 'Enter Zoom ID/URL',
                ),
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: _isDigitOnlyInput ? 4 : 0,
                ),
              ),
            ),
          ),

          // Step 3: Showcase the Key icon
          Showcase(
            key: _zoomKeyIconKey,
            title: 'Meeting Password',
            description:
                'Click on this key icon to set or view passwords. Setting password for Auto meeting are optional since there will always be a default. It is also optional if you create a Zoom meeting using the URL link. Password is required if you create a Zoom meeting using the Zoom ID. However, you can always set the password for others to know.',
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return const AlertDialog(
                      backgroundColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      content: GlassmorphismPasswordDialog(),
                    );
                  },
                );
              },
              icon: const Icon(Icons.key),
            ),
          ),
        ],
      ),
    );
  }
}

// Your GlassmorphismPasswordDialog widget with minor improvements
class GlassmorphismPasswordDialog extends ConsumerStatefulWidget {
  final bool isDisplay;

  const GlassmorphismPasswordDialog({
    super.key,
    this.isDisplay = false,
  });

  @override
  ConsumerState<GlassmorphismPasswordDialog> createState() =>
      _GlassmorphismPasswordDialogState();
}

class _GlassmorphismPasswordDialogState
    extends ConsumerState<GlassmorphismPasswordDialog> {
  late TextEditingController _passwordController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _focusNode = FocusNode();

    // Use addPostFrameCallback to safely access ref
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initialPassword =
          ref.read(bookingControllerProvider).password ?? '';
      _passwordController.text = initialPassword;

      if (!widget.isDisplay && mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    if (!widget.isDisplay) {
      final String passwordValue = _passwordController.text.trim();
      ref
          .read(bookingControllerProvider.notifier)
          .setPassword(passwordValue.isEmpty ? null : passwordValue);
    }
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: widget.isDisplay
                      ? () {
                          final text = _passwordController.text.trim();
                          if (text.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: text));
                          }
                        }
                      : null,
                  child: AbsorbPointer(
                    absorbing: widget.isDisplay,
                    child: TextField(
                      controller: _passwordController,
                      focusNode: _focusNode,
                      onSubmitted: (_) => Navigator.of(context).pop(),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.isDisplay
                            ? 'No Password'
                            : 'Enter Password (Optional)',
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white70,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
