import 'dart:async';

import 'package:el_shaddai/api/models/zoom_meeting_model/zoom_meeting_model.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_hybrid_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_zoom_component.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:el_shaddai/features/booking/widgets/booking_book_button.dart';
import 'package:el_shaddai/features/booking/widgets/booking_date_range_picker.dart';
import 'package:el_shaddai/features/booking/widgets/booking_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:riverpod/riverpod.dart';

part 'booking_dialog.g.dart';

enum BookingVenueComponent { location, zoom, hybrid }

@riverpod
class BookingVenue extends _$BookingVenue {
  @override
  BookingVenueComponent build() {
    return BookingVenueComponent.location; // Initial state: no target selected
  }

  void setTarget(BookingVenueComponent target) {
    state = target;
  }
}

class BookingDialog extends ConsumerStatefulWidget {
  const BookingDialog({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  ConsumerState<BookingDialog> createState() => BookingDialogState();
}

class BookingDialogState extends ConsumerState<BookingDialog> {
  static final formKey = GlobalKey<FormState>();
  final TextEditingController _googleController = TextEditingController();
  final ValueNotifier<String?> userAuthenticationToken =
      ValueNotifier<String?>(null);
  Timer? _tokenListenerTimer;
  @override
  void initState() {
    super.initState();
    _loadUserAuthenticationToken();
    startTokenListener();
    _googleController.addListener(_onTextChanged);
  }

  Future<void> _loadUserAuthenticationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userAuthenticationToken.value = prefs.getString('userAuthenticationCode');
  }

  void startTokenListener() async {
    _tokenListenerTimer?.cancel(); // Cancel any existing timer

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userAuthenticationToken.value = prefs.getString('userAuthenticationCode');

    // Start a new timer for 1 minute
    _tokenListenerTimer =
        Timer.periodic(const Duration(seconds: 2), (timer) async {
      String? newToken = prefs.getString('userAuthenticationCode');
      if (newToken != userAuthenticationToken.value) {
        userAuthenticationToken.value = newToken; // Update the notifier
      }
    });

    // Stop the listener after 1 minute
    Future.delayed(const Duration(minutes: 5), () {
      _tokenListenerTimer?.cancel();
    });
  }

  @override
  void dispose() {
    _tokenListenerTimer?.cancel();
    _googleController.removeListener(_onTextChanged);
    _googleController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted) return;
    if (_googleController.text == '') {
      ref.read(bookingControllerProvider.notifier).setChords(null);
    }
    ref
        .read(bookingControllerProvider.notifier)
        .setAddress(_googleController.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      insetPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      content: ValueListenableBuilder<String?>(
          valueListenable: userAuthenticationToken,
          builder: (context, token, child) {
            return Container(
              padding: EdgeInsets.zero,
              width: widget.width * 0.8,
              height: widget.height * 0.85,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('Create Your Prayer Time',
                          style: TextStyle(fontSize: 20)),
                      const BookingDateRangePickerComponent(),
                      BookingTimePickerComponent(controller: _googleController),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              ToggleButtons(
                                isSelected: BookingVenueComponent.values
                                    .map((key) =>
                                        ref.watch(bookingVenueProvider) == key)
                                    .toList(),
                                onPressed: (int index) {
                                  ref
                                      .read(bookingVenueProvider.notifier)
                                      .setTarget(
                                          BookingVenueComponent.values[index]);
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                constraints: const BoxConstraints(
                                    minHeight: 25,
                                    maxHeight: 35,
                                    minWidth: 80,
                                    maxWidth: 120),
                                children: BookingVenueComponent.values
                                    .map((key) => Text(key.name.capitalize()))
                                    .toList(),
                              ),
                              _buildSelectedComponent(
                                  selectedComponent:
                                      ref.watch(bookingVenueProvider),
                                  token: token),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              (value?.isEmpty ?? true) ? 'Enter a Title' : null,
                          onChanged: bookingFunction.setTitle,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'Title',
                          ),
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Enter a Description'
                            : null,
                        onChanged: bookingFunction.setDescription,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Description',
                        ),
                      ),
                      (token == null &&
                                  ref.read(bookingVenueProvider) ==
                                      BookingVenueComponent.location) ||
                              token != null
                          ? BookButton(
                              formKey: formKey,
                              errorCall: (x) {
                                showFailureSnackBar(context, x);
                              },
                            )
                          : const SizedBox.shrink(),
                      // if (token == null &&
                      //     (ref.read(bookingVenueProvider) ==
                      //             BookingVenueComponent.hybrid ||
                      //         ref.read(bookingVenueProvider) ==
                      //             BookingVenueComponent.zoom))
                      //   BookButton(
                      //       formKey: formKey,
                      //       errorCall: (x) {
                      //         showFailureSnackBar(context, x);
                      //       }),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildSelectedComponent(
      {required BookingVenueComponent selectedComponent, String? token}) {
    switch (selectedComponent) {
      case BookingVenueComponent.zoom:
        if (token == null) {
          return ElevatedButton(
            onPressed: () async {
              try {
                const ZoomRoute(zoomLoginRoute).push(context);
              } catch (e, s) {
                showFailureSnackBar(context, e.toString());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Image.asset(
                'assets/logo/zoom.png',
                width: 150,
                height: 30,
              ),
            ),
          );
        } else {
          return const BookingZoomComponent();
        }

      case BookingVenueComponent.location:
        return BookingLocationComponent(_googleController);
      case BookingVenueComponent.hybrid:
        if (token == null) {
          return ElevatedButton(
            onPressed: () async {
              try {
                const ZoomRoute(zoomLoginRoute).push(context);
              } catch (e, s) {
                showFailureSnackBar(context, e.toString());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Image.asset(
                'assets/logo/zoom.png',
                width: 150,
                height: 30,
              ),
            ),
          );
        } else {
          return BookingHyrbidComponent(googleController: _googleController);
        }
      default:
        return const SizedBox.shrink(); // Fallback
    }
  }
}
