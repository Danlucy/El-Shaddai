import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_screen.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_hybrid_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component/booking_location_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_zoom_component.dart';
import 'package:el_shaddai/features/booking/widgets/booking_book_button.dart';
import 'package:el_shaddai/features/booking/widgets/booking_date_range_picker.dart';
import 'package:el_shaddai/features/booking/widgets/booking_time_picker.dart';
import 'package:el_shaddai/features/booking/widgets/recurrence_component.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookingDialog extends ConsumerStatefulWidget {
  const BookingDialog(
    this.context, {
    this.bookingModel,
    super.key,
  });
  final BuildContext context;
  final BookingModel? bookingModel;

  @override
  ConsumerState<BookingDialog> createState() => BookingDialogState();
}

class BookingDialogState extends ConsumerState<BookingDialog> {
  static final formKey = GlobalKey<FormState>();
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _googleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _googleController.addListener(_onTextChanged);
    if (widget.bookingModel?.location.address != null) {
      _googleController.text = widget.bookingModel!.location.address!;
    }
    if (widget.bookingModel != null) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages(); // Move the precache logic here
  }

  Future<void> _precacheImages() async {
    // Precache the zoom logo
    await precacheImage(
      const AssetImage('assets/zoom.png'),
      context, // Safe to use context here
    );
  }

  @override
  void dispose() {
    _googleController.removeListener(_onTextChanged);
    _googleController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    Future(() {
      if (!mounted) return;
      if (_googleController.text == '') {
        ref.read(bookingControllerProvider.notifier).setChords(null);
      }
      ref
          .read(bookingControllerProvider.notifier)
          .setAddress(_googleController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bool isUpdating = widget.bookingModel != null;
    final token =
        ref.watch(accessTokenNotifierProvider); // Use the new provider
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    // Adjust size factors based on TextScaleFactor

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          backgroundColor: context.colors.secondaryContainer,
          insetPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          content: Builder(builder: (builderContext) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.zero,
                width: width *
                    (TextScaleFactor.oldMan ==
                            TextScaleFactor.scaleFactor(textScaler)
                        ? 0.85
                        : 0.8),
                height: height * 0.9,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                            isUpdating
                                ? 'Edit Your Prayer Time '
                                : 'Book Your Prayer Time ',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        BookingDateRangePickerComponent(
                          initialSelectedRange: PickerDateRange(
                              widget.bookingModel?.timeRange.start,
                              widget.bookingModel?.timeRange.end),
                        ),
                        const BookingTimePickerComponent(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextFormField(
                                    initialValue: widget.bookingModel?.title,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        (value?.isEmpty ?? true)
                                            ? 'Enter a Focus'
                                            : null,
                                    onChanged: bookingFunction.setTitle,
                                    decoration: InputDecoration(
                                      label:
                                          const Text('Theme of Prayer Focus'),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  initialValue:
                                      widget.bookingModel?.description,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => (value?.isEmpty ?? true)
                                      ? 'Enter Points'
                                      : null,
                                  onChanged: bookingFunction.setDescription,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    label: const Text('Prayer Points'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ToggleButtons(
                            isSelected: BookingVenueComponent.values
                                .map((key) =>
                                    ref.watch(bookingVenueStateProvider) == key)
                                .toList(),
                            onPressed: (int index) {
                              ref
                                  .read(bookingVenueStateProvider.notifier)
                                  .setVenue(
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
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: Align(
                            alignment: Alignment
                                .topCenter, // 🟢 Important to place child at top

                            child: _buildSelectedComponent(builderContext),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (widget.bookingModel?.id == null)
                          const RecurrenceComponent(),
                        // if ((token.value == null &&
                        //         ref.read(bookingVenueStateProvider) ==
                        //             BookingVenueComponent.location) ||
                        //     token.value != null)

                        //change6
                        BookButton(
                          isUpdating: isUpdating,
                          formKey: formKey,
                          bookingId: widget.bookingModel?.id,
                          errorCall: (x) {
                            final contextKey = formKey.currentContext;
                            if (contextKey != null && contextKey.mounted) {
                              showFailureSnackBar(widget.context, x);
                            } else {
                              throw x;
                            }
                          },
                        )
                        // else
                        //   const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSelectedComponent(builderContext) {
    // Use the new provider
    bool isSignedIn = ref.watch(accessTokenNotifierProvider).value == null;
    switch (ref.read(bookingVenueStateProvider)) {
      case BookingVenueComponent.zoom:
        if (isSignedIn) {
          //change5
          // return const ZoomSignInComponent();
          return const BookingZoomComponent(key: ValueKey('zoom'));
        } else {
          return const BookingZoomComponent(key: ValueKey('zoom'));
        }

      case BookingVenueComponent.location:
        return BookingLocationComponent(_googleController, builderContext,
            key: const ValueKey('location'));
      case BookingVenueComponent.hybrid:
        if (isSignedIn) {
          return BookingHyrbidComponent(
              googleController: _googleController,
              key: const ValueKey('hybrid'));
        } else {
          return BookingHyrbidComponent(
              googleController: _googleController,
              key: const ValueKey('hybrid'));
          //change6
          // return const ZoomSignInComponent();
        }
      // Fallback
    }
  }
}

class ZoomSignInComponent extends StatelessWidget {
  const ZoomSignInComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          const ZoomRoute(zoomLoginRoute).push(context);
        } catch (e, s) {
          showFailureSnackBar(
            context,
            e.toString() + s.toString(),
          );
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
  }
}
