import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookingDateRangePickerComponent extends ConsumerStatefulWidget {
  const BookingDateRangePickerComponent({super.key});

  @override
  ConsumerState<BookingDateRangePickerComponent> createState() =>
      _BookingDateRangePickerComponentState();
}

class _BookingDateRangePickerComponentState
    extends ConsumerState<BookingDateRangePickerComponent> {
  @override
  Widget build(BuildContext context) {
    final eventFunction = ref.read(bookingControllerProvider.notifier);
    return SfDateRangePicker(
      initialDisplayDate: DateTime.now(),
      enablePastDates: false,
      headerStyle: DateRangePickerHeaderStyle(
        textAlign: TextAlign.start,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        blackoutDateTextStyle: TextStyle(
          color: Colors.redAccent.withOpacity(0.4),
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

        if (value is PickerDateRange) {
          if (value.endDate != null) {
            eventFunction.setDateRange(
                DateTimeRange(start: value.startDate!, end: value.endDate!));
          } else {
            eventFunction.setDateRange(
                DateTimeRange(start: value.startDate!, end: value.startDate!));
          }
        } else {
          if (value is DateTimeRange) {
            eventFunction.setDateRange(
                DateTimeRange(start: value.start, end: value.end));
          }
        }
      },
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      selectionMode: DateRangePickerSelectionMode.range,
    );
  }
}
