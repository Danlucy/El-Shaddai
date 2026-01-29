import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mobile/features/booking/controller/booking_controller.dart';
import 'package:mobile/features/booking/presentations/booking_screen.dart';
import 'package:mobile/features/booking/presentations/booking_venues_component/booking_location_component/booking_location_component.dart';
import 'package:mobile/features/booking/widgets/booking_book_button.dart';
import 'package:mobile/features/booking/widgets/booking_date_range_picker.dart';
import 'package:mobile/features/booking/widgets/booking_text_field.dart';
import 'package:mobile/features/booking/widgets/booking_time_picker.dart';
import 'package:mobile/features/booking/widgets/recurrence_component.dart';
import 'package:mobile/features/booking/widgets/zoom_display_component.dart';
import 'package:models/models.dart';
import 'package:util/util.dart';

class BookingDialog extends ConsumerStatefulWidget {
  const BookingDialog(this.context, {this.bookingModel, super.key});
  final BuildContext context;
  final BookingModel? bookingModel;

  @override
  ConsumerState<BookingDialog> createState() => BookingDialogState();
}

class BookingDialogState extends ConsumerState<BookingDialog> {
  bool _initialized = false;
  static final formKey = GlobalKey<FormState>();

  // 1. Define Controllers
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages();
  }

  @override
  void initState() {
    super.initState();

    // 2. Initialize Controllers with existing data (if editing)
    _titleController = TextEditingController(
      text: widget.bookingModel?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.bookingModel?.description ?? '',
    );

    final booking = widget.bookingModel;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (booking != null) {
        Future.microtask(() {
          if (!mounted) return;
          ref.read(bookingControllerProvider.notifier).setState(booking);

          Future.delayed(const Duration(milliseconds: 50), () {
            if (!mounted) return;
            ref
                .read(bookingControllerProvider.notifier)
                .switchVenueBasedOnCurrentState();
          });

          setState(() => _initialized = true);
        });
      } else {
        setState(() => _initialized = true);
      }
    });
  }

  @override
  void dispose() {
    // 3. Dispose Controllers
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _precacheImages() async {
    await precacheImage(const AssetImage('assets/zoom.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state so the UI rebuilds
    final bookingState = ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final isUpdating = widget.bookingModel != null;
    final textScaler = MediaQuery.textScalerOf(context).scale(1);

    // 4. LISTEN to State Changes (Fixes the Paste Issue)
    ref.listen(bookingControllerProvider, (previous, next) {
      // If the state title changes externally (paste), update the controller
      if (next.title != _titleController.text) {
        _titleController.text = next.title ?? '';
        // Move cursor to end to prevent weird jumping if user is typing
        _titleController.selection = TextSelection.fromPosition(
          TextPosition(offset: _titleController.text.length),
        );
      }
      if (next.description != _descController.text) {
        _descController.text = next.description ?? '';
      }
    });

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Hero(
          tag: "booking_fab",
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: FractionallySizedBox(
              widthFactor:
                  (TextScaleFactor.oldMan ==
                      TextScaleFactor.scaleFactor(textScaler)
                  ? 0.95
                  : 0.92),
              heightFactor: 0.92,
              child: GlassmorphicContainer(
                width: double.infinity,
                height: double.infinity,
                borderRadius: 20,
                blur: 4,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.onSurface.withOpac(0.1),
                    Theme.of(context).colorScheme.onSurface.withOpac(0.05),
                  ],
                  stops: const [0.1, 1],
                ),
                borderGradient: LinearGradient(
                  colors: [
                    Colors.white.withOpac(0.5),
                    Colors.white.withOpac(0.5),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {}, // Prevents tap bubbling to Scaffold
                  child: Form(
                    key: formKey,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isUpdating
                                          ? 'Edit Your Prayer Time '
                                          : 'Book Your Prayer Time ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // 5. Paste Button (Only visible if clipboard has data)
                                    IconButton(
                                      tooltip: "Paste last copied booking",
                                      onPressed: () {
                                        ref
                                            .read(
                                              bookingControllerProvider
                                                  .notifier,
                                            )
                                            .pasteFromClipboard(context);
                                      },
                                      icon: const Icon(Icons.paste),
                                    ),
                                  ],
                                ),
                                const BookingDateRangePickerComponent(),
                                const BookingTimePickerComponent(),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        // 6. Updated TextFields to use Controllers
                                        BookingTextField(
                                          label: 'Theme of Prayer Focus',
                                          validationMessage: 'Enter a Focus',
                                          controller:
                                              _titleController, // Use controller
                                          onChanged: bookingFunction.setTitle,
                                        ),
                                        const SizedBox(height: 10),
                                        BookingTextField(
                                          label: 'Prayer Points',
                                          validationMessage: 'Enter Points',
                                          controller:
                                              _descController, // Use controller
                                          onChanged:
                                              bookingFunction.setDescription,
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
                                        .map(
                                          (key) =>
                                              ref.watch(
                                                bookingVenueStateProvider,
                                              ) ==
                                              key,
                                        )
                                        .toList(),
                                    onPressed: (int index) {
                                      ref
                                          .read(
                                            bookingVenueStateProvider.notifier,
                                          )
                                          .setVenue(
                                            BookingVenueComponent.values[index],
                                          );
                                    },
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    constraints: const BoxConstraints(
                                      minHeight: 25,
                                      maxHeight: 35,
                                      minWidth: 80,
                                      maxWidth: 120,
                                    ),
                                    children: BookingVenueComponent.values
                                        .map(
                                          (key) => Text(key.name.capitalize()),
                                        )
                                        .toList(),
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  alignment: Alignment.topCenter,
                                  child: _buildVenueContent(),
                                ),
                                const SizedBox(height: 10),
                                if (widget.bookingModel?.id == null)
                                  const RecurrenceComponent(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.viewInsetsOf(
                                          context,
                                        ).bottom +
                                        20,
                                  ),
                                  child: BookButton(
                                    isUpdating: isUpdating,
                                    formKey: formKey,
                                    errorCall: (x) {
                                      final contextKey = formKey.currentContext;
                                      if (contextKey != null &&
                                          contextKey.mounted) {
                                        showFailureSnackBar(widget.context, x);
                                      } else {
                                        throw x;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVenueContent() {
    final selected = ref.watch(bookingVenueStateProvider);
    return Column(
      children: [
        if (selected != BookingVenueComponent.location)
          const ZoomDisplayComponent(),
        if (selected == BookingVenueComponent.hybrid) const SizedBox(height: 8),
        if (selected != BookingVenueComponent.zoom) const GoogleMapComponent(),
      ],
    );
  }
}
