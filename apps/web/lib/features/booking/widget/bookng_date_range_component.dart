import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controller/booking_controller.dart';

class BookingDateRangePickerComponent extends ConsumerStatefulWidget {
  const BookingDateRangePickerComponent({super.key});

  @override
  ConsumerState<BookingDateRangePickerComponent> createState() =>
      _BookingDateRangePickerComponentState();
}

class _BookingDateRangePickerComponentState
    extends ConsumerState<BookingDateRangePickerComponent> {
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final timeRange = bookingState.timeRange;

    if (timeRange != null) {
      final newRange = PickerDateRange(timeRange.start, timeRange.end);

      // Only update if the range is actually different to avoid loops
      if (_controller.selectedRange?.startDate != newRange.startDate ||
          _controller.selectedRange?.endDate != newRange.endDate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _controller.selectedRange = newRange;
          }
        });
      }
    } else {
      // Clear selection if no time range
      if (_controller.selectedRange != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _controller.selectedRange = null;
          }
        });
      }
    }

    return Container(
      // ✅ Keep your original container decoration for consistency
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpac(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpac(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SfDateRangePicker(
        controller: _controller,
        enablePastDates: false,
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.range,
        backgroundColor: Colors.transparent,

        // ✅ Header Style
        headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: Colors.transparent,
          textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        // ✅ Month Cell Style
        monthCellStyle: DateRangePickerMonthCellStyle(
          blackoutDateTextStyle: TextStyle(
            color: Colors.redAccent.withOpac(0.4),
          ),
          cellDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white24),
          ),
        ),

        // ✅ Selection Style
        startRangeSelectionColor: Theme.of(context).colorScheme.primary,
        endRangeSelectionColor: Theme.of(context).colorScheme.primary,
        rangeSelectionColor: Theme.of(
          context,
        ).colorScheme.primary.withOpac(0.3),
        selectionShape: DateRangePickerSelectionShape.circle,
        todayHighlightColor: Theme.of(context).colorScheme.primary,

        // ✅ Selection Logic
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          final value = args.value;

          if (value is PickerDateRange && value.startDate != null) {
            final start = value.startDate!;
            // If end date is null (user only clicked one date so far), use start date
            final end = value.endDate ?? value.startDate!;

            bookingFunction.setDateRange(DateTimeRange(start: start, end: end));
          }
        },
      ),
    );
  }
}
