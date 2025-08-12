import 'package:api/api.dart';
import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/utility/url_launcher.dart';
import 'package:mobile/core/widgets/glass_container.dart';
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
  bool _isDigitOnlyInput = true;
  bool _isInitialized = false;
  bool _hasTriggeredShowcase = false;

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

  void _checkAndTriggerShowcase(
      BookingVenueComponent currentVenue, Set<String> seenTips) {
    if (_hasTriggeredShowcase) return;

    const tipId = 'zoom_input_tour_tip';

    if (currentVenue != BookingVenueComponent.zoom &&
        currentVenue != BookingVenueComponent.hybrid) {
      return;
    }

    if (seenTips.contains(tipId)) {
      return;
    }

    _hasTriggeredShowcase = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          _zoomIconKey,
          _zoomTextFormFieldKey,
          _zoomKeyIconKey,
        ]);
        ref.read(onboardingNotifierProvider.notifier).markTipAsSeen(tipId);
      } else {}
    });
  }

  void _initializeController() {
    if (_isInitialized) return;

    final bookingState = ref.read(bookingControllerProvider);
    final webValue = bookingState.location?.web;

    final initialId = _parseIdForDisplay(webValue);

    _zoomIdController.text = initialId;
    _updateLetterSpacingState(initialId);
    _isInitialized = true;
  }

  @override
  void initState() {
    super.initState();

    _zoomIconKey = GlobalKey();
    _zoomTextFormFieldKey = GlobalKey();
    _zoomKeyIconKey = GlobalKey();

    _zoomIdController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeController();
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
    final onboardingState = ref.watch(onboardingNotifierProvider);
    final bookingState = ref.watch(bookingControllerProvider);

    final bool isSignedIn = accessTokenAsync.when(
      data: (token) => token != null,
      loading: () => false,
      error: (_, __) => false,
    );

    if (!_isInitialized && bookingState.location?.web != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeController();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onboardingState.whenData((seenTips) {
        _checkAndTriggerShowcase(currentVenue, seenTips);
      });
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
                  if (trimmedInput.isEmpty) {
                    webValueToStore = null;
                  } else if (trimmedInput.startsWith('http://') ||
                      trimmedInput.startsWith('https://')) {
                    webValueToStore = trimmedInput;
                  } else if (_isDigitOnlyInput) {
                    webValueToStore = buildExternalZoomUrl(trimmedInput);
                    ref
                        .read(bookingControllerProvider.notifier)
                        .setWeb(webValueToStore);
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
                    return AlertDialog(
                      backgroundColor: Colors.transparent,
                      contentPadding: EdgeInsets.zero,
                      content: GlassmorphismPasswordDialog(
                        initialPassword:
                            ref.read(bookingControllerProvider).password,
                        onPasswordSubmitted: (newPassword) {
                          Future.microtask(() {
                            ref
                                .read(bookingControllerProvider.notifier)
                                .setPassword(newPassword);
                          });
                        },
                      ),
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

class GlassmorphismPasswordDialog extends StatefulWidget {
  final String? initialPassword;
  final Function(String? password)? onPasswordSubmitted;
  final bool isDisplay;

  const GlassmorphismPasswordDialog({
    super.key,
    this.initialPassword,
    this.onPasswordSubmitted,
    this.isDisplay = false,
  });

  @override
  State<GlassmorphismPasswordDialog> createState() =>
      _GlassmorphismPasswordDialogState();
}

class _GlassmorphismPasswordDialogState
    extends State<GlassmorphismPasswordDialog> {
  late TextEditingController _passwordController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _passwordController =
        TextEditingController(text: widget.initialPassword ?? '');
    _focusNode = FocusNode();

    if (!widget.isDisplay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (!widget.isDisplay && widget.onPasswordSubmitted != null) {
      final String passwordValue = _passwordController.text.trim();
      widget.onPasswordSubmitted!(passwordValue.isEmpty ? null : passwordValue);
    }
    _passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the text to display inside the TextField
    String hintText;
    if (widget.isDisplay) {
      final passwordValue = _passwordController.text.trim();
      if (passwordValue.isEmpty) {
        hintText = 'No Password';
      } else {
        // In display mode, the text is a hint to show the value.
        // It's a bit of a workaround since it's a TextField.
        hintText = passwordValue;
      }
    } else {
      hintText = 'Enter Password (Optional)';
    }

    return GlassContainer(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 100,
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
                  onSubmitted: (value) {
                    Navigator.of(context).pop();
                  },
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText, // Use the determined hintText
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
    );
  }
}
