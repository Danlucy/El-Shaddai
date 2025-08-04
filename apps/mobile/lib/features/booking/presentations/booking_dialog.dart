import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/utility/url_launcher.dart';
import 'package:mobile/features/booking/widgets/booking_text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../api/models/access_token_model/access_token_model.dart';
import '../../../core/constants/constants.dart';
import '../../../core/customs/custom_date_time_range.dart';
import '../../../core/router/router.dart';
import '../../../core/utility/date_time_range.dart';
import '../../../core/widgets/snack_bar.dart';
import '../../../models/booking_model/booking_model.dart';
import '../controller/booking_controller.dart';
import '../widgets/booking_book_button.dart';
import '../widgets/booking_date_range_picker.dart';
import '../widgets/booking_time_picker.dart';
import '../widgets/recurrence_component.dart';
import 'booking_screen.dart';
import 'booking_venues_component/booking_hybrid_component.dart';
import 'booking_venues_component/booking_location_component/booking_location_component.dart';
import 'booking_venues_component/booking_zoom_component.dart';

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
  final TextEditingController _googleController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages(); // Move the precache logic here
  }

  @override
  void initState() {
    super.initState();
    final booking = widget.bookingModel;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (booking != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ref
                .read(bookingControllerProvider.notifier)
                .switchVenueBasedOnCurrentState();
            setState(() => _initialized = true);
          }
        });
      } else {
        _initialized = true;
      }

      if (mounted) {
        setState(() => _initialized = true);
      }
    });
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
    ref.watch(bookingControllerProvider);
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bookingReader = ref.read(bookingControllerProvider);
    final bool isUpdating = widget.bookingModel != null;
    // final token =
    //     ref.watch(accessTokenNotifierProvider); // Use the new provider
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    // Adjust size factors based on TextScaleFactor
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    } else {
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
                                      ref.watch(bookingVenueStateProvider) ==
                                      key)
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
                              alignment: Alignment.topCenter,
                              // 🟢 Important to place child at top

                              child: _buildSelectedComponent(builderContext),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (widget.bookingModel?.id == null)
                            const RecurrenceComponent(),

                          //change6
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
  }

  Widget _buildSelectedComponent(
    BuildContext context,
  ) {
    final selected = ref.watch(bookingVenueStateProvider);

    return Column(
      children: [
        Offstage(
          offstage: selected != BookingVenueComponent.zoom,
          child: const BookingZoomComponent(
            key: ValueKey('zoom'),
          ),
        ),
        Offstage(
          offstage: selected != BookingVenueComponent.location,
          child: BookingLocationComponent(
            _googleController,
            context,
            key: const ValueKey('location'),
          ),
        ),
        Offstage(
          offstage: selected != BookingVenueComponent.hybrid,
          child: BookingHyrbidComponent(
            googleController: _googleController,
            key: const ValueKey('hybrid'),
          ),
        ),
      ],
    );
  }
}
