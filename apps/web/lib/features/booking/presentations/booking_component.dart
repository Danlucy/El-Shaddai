import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:website/features/booking/controller/booking_controller.dart';
import 'package:website/features/booking/widget/book_button.dart';
import 'package:website/features/booking/widget/booking_location_component.dart';
import 'package:website/features/booking/widget/booking_text_field.dart';
import 'package:website/features/booking/widget/booking_time_picker_component.dart';
import 'package:website/features/booking/widget/bookng_date_range_component.dart';
import 'package:website/features/booking/widget/recurrence_component.dart';
import 'package:website/features/booking/widget/zoom_display_component.dart';

class BookingDialogPage extends ConsumerWidget {
  final BookingModel? extraModel;

  const BookingDialogPage({super.key, this.extraModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookingModel? booking = extraModel;
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // 1. DESKTOP: Render as a Dialog
    if (isDesktop) {
      return Hero(
        tag: "booking_fab", // Same tag as FAB

        child: Center(
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
              // Tighter constraints for a cleaner look on large screens
              constraints: const BoxConstraints(maxWidth: 900, maxHeight: 950),
              child: Padding(
                padding: EdgeInsetsGeometry.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),

                  child: Column(
                    children: [
                      // Header with Close Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking == null
                                  ? 'Book Prayer Time'
                                  : 'Edit Prayer Time',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => context.pop(),
                            ),
                          ],
                        ),
                      ),
                      // The Form Content
                      Expanded(child: BookingFormWidget(bookingModel: booking)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 2. MOBILE: Render as a Fullscreen Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          booking == null ? 'Book Prayer Time' : 'Edit Prayer Time',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(child: BookingFormWidget(bookingModel: booking)),
    );
  }
}

class BookingFormWidget extends ConsumerStatefulWidget {
  final BookingModel? bookingModel;
  const BookingFormWidget({super.key, this.bookingModel});

  @override
  ConsumerState<BookingFormWidget> createState() => _BookingFormWidgetState();
}

class _BookingFormWidgetState extends ConsumerState<BookingFormWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(24), // Unified padding
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BookingDateRangePickerComponent(),
        const SizedBox(height: 16),
        const BookingTimePickerComponent(),
        const SizedBox(height: 16),
        _buildTextFieldsSection(),
        const SizedBox(height: 16),
        _buildVenueSection(),
        const SizedBox(height: 16),
        _buildRecurrenceSection(),
        const SizedBox(height: 24),
        _buildSubmitButton(),
      ],
    );
  }

  /// Layout for Desktop: Horizontal Split for Date/Time, Vertical for the rest
  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Horizontal Date & Time Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar on the left
            const Expanded(flex: 3, child: BookingDateRangePickerComponent()),
            const SizedBox(width: 24),
            // Time & Recurrence on the right
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const BookingTimePickerComponent(),
                  const SizedBox(height: 16),
                  _buildRecurrenceSection(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SizedBox(height: 24),

        // Form Fields (Theme, Points, Venue)
        _buildTextFieldsSection(),
        const SizedBox(height: 16),
        _buildVenueSection(),
        const SizedBox(height: 24),

        // Button aligned to right on desktop for better UX
        Align(alignment: Alignment.center, child: _buildSubmitButton()),
      ],
    );
  }

  // ===========================================================================
  // REUSABLE SECTIONS
  // ===========================================================================

  Widget _buildTextFieldsSection() {
    final bookingReader = ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);

    return Column(
      children: [
        BookingTextField(
          label: 'Theme of Prayer Focus',
          validationMessage: 'Enter a Focus',
          initialValue: bookingReader.title,
          onChanged: bookingFunction.setTitle,
        ),
        const SizedBox(height: 12),
        BookingTextField(
          label: 'Prayer Points',
          validationMessage: 'Enter Points',
          initialValue: bookingReader.description,
          onChanged: bookingFunction.setDescription,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildVenueSection() {
    return Column(
      children: [
        Center(
          child: ToggleButtons(
            isSelected: BookingVenueComponent.values
                .map((key) => ref.watch(bookingVenueStateProvider) == key)
                .toList(),
            onPressed: (int index) {
              ref
                  .read(bookingVenueStateProvider.notifier)
                  .setVenue(BookingVenueComponent.values[index]);
            },
            borderRadius: BorderRadius.circular(8),
            constraints: const BoxConstraints(
              minHeight: 35,
              maxHeight: 40,
              minWidth: 80,
            ),
            children: BookingVenueComponent.values
                .map((key) => Text(key.name.toUpperCase()))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _buildVenueContent(),
        ),
      ],
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

  Widget _buildRecurrenceSection() {
    // Only show recurrence if creating a new booking
    return const RecurrenceComponent();
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: BookButton(
        formKey: _formKey,
        isUpdating: widget.bookingModel != null,
        errorCall: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
      ),
    );
  }
}
