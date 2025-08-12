import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/booking/widgets/booking_text_field.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';

import '../controller/booking_controller.dart';
import '../widgets/booking_book_button.dart';
import '../widgets/booking_date_range_picker.dart';
import '../widgets/booking_time_picker.dart';
import '../widgets/recurrence_component.dart';
import '../widgets/zoom_display_widget.dart';
import 'booking_screen.dart';
import 'booking_venues_component/booking_location_component/booking_location_component.dart';

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
  bool _initialized = false;
  static final formKey = GlobalKey<FormState>();
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages();
  }

  @override
  void initState() {
    super.initState();
    final booking = widget.bookingModel;

    // A single, clean initialization block
    if (booking != null) {
      // Use addPostFrameCallback to ensure the widget tree is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() {
          if (!mounted) return;

          // Set the booking data
          ref.read(bookingControllerProvider.notifier).setState(booking);

          // Set the venue based on the booking data
          Future.delayed(const Duration(milliseconds: 50), () {
            ref
                .read(bookingControllerProvider.notifier)
                .switchVenueBasedOnCurrentState();
          });

          // Now we can safely set the initialized flag
          setState(() => _initialized = true);
        });
      });
    } else {
      // No existing booking, so we're creating a new one
      _initialized = true;
    }
  }

  Future<void> _precacheImages() async {
    await precacheImage(
      const AssetImage('assets/zoom.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingControllerProvider);
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bookingReader = ref.read(bookingControllerProvider);
    final bool isUpdating = widget.bookingModel != null;
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

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
                        const BookingDateRangePickerComponent(),
                        const BookingTimePickerComponent(),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                BookingTextField(
                                  label: 'Theme of Prayer Focus',
                                  validationMessage: 'Enter a Focus',
                                  initialValue: bookingReader.title,
                                  onChanged: bookingFunction.setTitle,
                                ),
                                const SizedBox(height: 10),
                                BookingTextField(
                                  label: 'Prayer Points',
                                  validationMessage: 'Enter Points',
                                  initialValue: bookingReader.description,
                                  onChanged: bookingFunction.setDescription,
                                  maxLines: 3,
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

                        // Simplified Component Rendering
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: _buildVenueContent(builderContext),
                        ),

                        const SizedBox(height: 10),
                        if (widget.bookingModel?.id == null)
                          const RecurrenceComponent(),

                        BookButton(
                          isUpdating: isUpdating,
                          formKey: formKey,
                          errorCall: (x) {
                            final contextKey = formKey.currentContext;
                            if (contextKey != null && contextKey.mounted) {
                              showFailureSnackBar(widget.context, x);
                            } else {
                              throw x;
                            }
                          },
                        )
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

  Widget _buildVenueContent(BuildContext context) {
    final selected = ref.watch(bookingVenueStateProvider);

    return Column(
      children: [
        // Show ZoomDisplayComponent for zoom and hybrid modes
        if (selected != BookingVenueComponent.location)
          const ZoomDisplayComponent(),

        // Add spacing between components when both are visible
        if (selected == BookingVenueComponent.hybrid) const SizedBox(height: 8),

        // Show GoogleMapComponent for location and hybrid modes
        if (selected != BookingVenueComponent.zoom) const GoogleMapComponent(),
      ],
    );
  }
}
