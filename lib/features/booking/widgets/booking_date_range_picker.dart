import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookingDateRangePickerComponent extends ConsumerStatefulWidget {
  const BookingDateRangePickerComponent({
    super.key,
    this.initialSelectedRange,
  });
  final PickerDateRange? initialSelectedRange;
  @override
  ConsumerState<BookingDateRangePickerComponent> createState() =>
      _BookingDateRangePickerComponentState();
}

class _BookingDateRangePickerComponentState
    extends ConsumerState<BookingDateRangePickerComponent> {
  final DateRangePickerController controller = DateRangePickerController();
  @override
  Widget build(BuildContext context) {
    final eventFunction = ref.read(bookingControllerProvider.notifier);
    return SfDateRangePicker(
      initialSelectedRange: widget.initialSelectedRange,
      enablePastDates: false,
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.start,
        backgroundColor: context.colors.secondaryContainer,
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: TextStyle(
          color: Colors.redAccent.withOpac(0.4),
        ),
        cellDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(color: Colors.white24),
        ),
      ),
      monthViewSettings: const DateRangePickerMonthViewSettings(),
      view: DateRangePickerView.month,
      onSelectionChanged: (d) {
        final value = d.value;

        try {
          if (value is PickerDateRange) {
            if (value.endDate != null) {
              eventFunction.setDateRange(
                  DateTimeRange(start: value.startDate!, end: value.endDate!));
            } else {
              eventFunction.setDateRange(DateTimeRange(
                  start: value.startDate!, end: value.startDate!));
            }
          } else {
            if (value is DateTimeRange) {
              eventFunction.setDateRange(
                  DateTimeRange(start: value.start, end: value.end));
            }
          }
        } catch (e) {
          throw e;
        }
      },
      backgroundColor: context.colors.secondaryContainer,
      selectionMode: DateRangePickerSelectionMode.range,
    );
  }
}
