import 'package:el_shaddai/api/models/access_token_model/access_token_model.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/router/router.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/core/widgets/snack_bar.dart';
import 'package:el_shaddai/features/auth/controller/zoom_auth_controller.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_screen.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_hybrid_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_location_component/booking_location_component.dart';
import 'package:el_shaddai/features/booking/presentations/booking_venues_component/booking_zoom_component.dart';
import 'package:el_shaddai/features/booking/widgets/booking_book_button.dart';
import 'package:el_shaddai/features/booking/widgets/booking_date_range_picker.dart';
import 'package:el_shaddai/features/booking/widgets/booking_time_picker.dart';
import 'package:el_shaddai/features/booking/widgets/recurrence_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class BookingDialog extends ConsumerStatefulWidget {
  const BookingDialog(
    this.context, {
    super.key,
    required this.width,
    required this.height,
  });
  final BuildContext context;
  final double width;
  final double height;

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
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
                        const Text('Book Your Prayer Time',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const BookingDateRangePickerComponent(),

                        BookingTimePickerComponent(
                            controller: _googleController),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextFormField(
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
                        _buildSelectedComponent(builderContext),
                        const RecurrenceComponent(),

                        if ((token.value == null &&
                                ref.read(bookingVenueStateProvider) ==
                                    BookingVenueComponent.location) ||
                            token.value != null)
                          BookButton(
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
                        else
                          const SizedBox.shrink(),
                        // IconButton(onPressed: () {}, icon: const Icon(Icons.close)),]
                      ],
                    )),
                  ),
                ));
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
          return const ZoomSignInComponent();
        } else {
          return const BookingZoomComponent();
        }

      case BookingVenueComponent.location:
        return BookingLocationComponent(_googleController, builderContext);
      case BookingVenueComponent.hybrid:
        if (isSignedIn) {
          return const ZoomSignInComponent();
        } else {
          return BookingHyrbidComponent(googleController: _googleController);
        }
      default:
        return const SizedBox.shrink(); // Fallback
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
