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

    // ✅ Sync controller with state - this is the approach that works
    final timeRange = bookingState.timeRange;

    if (timeRange != null) {
      final newRange = PickerDateRange(timeRange.start, timeRange.end);

      // Only update if the range is actually different
      if (_controller.selectedRange?.startDate != newRange.startDate ||
          _controller.selectedRange?.endDate != newRange.endDate) {
        // Use post-frame callback to avoid modifying state during build
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

    return SfDateRangePicker(
      controller: _controller,
      enablePastDates: false,
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.start,
        backgroundColor: Colors.transparent,
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: TextStyle(color: Colors.redAccent.withOpac(0.4)),
        cellDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white24),
        ),
      ),
      view: DateRangePickerView.month,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        final value = args.value;

        if (value is PickerDateRange) {
          final start = value.startDate!;
          final end = value.endDate ?? value.startDate!;

          bookingFunction.setDateRange(DateTimeRange(start: start, end: end));
        }
      },
      backgroundColor: Colors.transparent,
      selectionMode: DateRangePickerSelectionMode.range,
    );
  }
}
