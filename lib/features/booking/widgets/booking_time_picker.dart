import 'dart:io';

import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:intl/intl.dart';

class BookingTimePickerComponent extends ConsumerStatefulWidget {
  const BookingTimePickerComponent({
    required this.controller,
    super.key,
  });
  final TextEditingController controller;
  @override
  ConsumerState<BookingTimePickerComponent> createState() =>
      _BookingTimePickerComponentState();
}

class _BookingTimePickerComponentState
    extends ConsumerState<BookingTimePickerComponent> {
  @override
  Widget build(BuildContext context) {
    final eventReader = ref.watch(bookingControllerProvider);

    final eventFunction = ref.read(bookingControllerProvider.notifier);
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        widget.controller.clear();
        sleep(const Duration(milliseconds: 100));
        showTimeRangePicker(
          start: eventReader.timeRange?.start != null
              ? TimeOfDay.fromDateTime(eventReader.timeRange!.start)
              : const TimeOfDay(hour: 6, minute: 0),
          end: eventReader.timeRange?.end != null
              ? TimeOfDay.fromDateTime(eventReader.timeRange!.end)
              : const TimeOfDay(hour: 18, minute: 0),
          use24HourFormat: false,
          context: context,
          minDuration: const Duration(hours: 1),
          interval: const Duration(hours: 1),
          handlerColor: Theme.of(context).colorScheme.onSurfaceVariant,
          backgroundColor: Theme.of(context).colorScheme.primary,
          labels: [
            '12 AM',
            '3 AM',
            '6 AM',
            '9 AM',
            '12 PM',
            '3 PM',
            '6 PM',
            '9 PM'
          ].asMap().entries.map((e) {
            return ClockLabel.fromIndex(
              idx: e.key,
              length: 8,
              text: e.value,
            );
          }).toList(),
          ticks: 12,
        ).then((value) {
          if (value != null) {
            print(value);

            eventFunction.setTimeRange(value);
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: Theme.of(context).colorScheme.outline,
            ),
            child: Text(
              eventReader.timeRange?.start != null
                  ? DateFormat.jm().format(eventReader.timeRange!.start)
                  : 'Start Time',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.access_time,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Icon(Icons.arrow_right_alt_outlined),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.access_time_filled,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: Theme.of(context).colorScheme.outline,
            ),
            child: Text(
              eventReader.timeRange?.end != null
                  ? DateFormat.jm().format(eventReader.timeRange!.end)
                  : 'End Time',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
