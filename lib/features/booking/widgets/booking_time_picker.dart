import 'dart:io';

import 'package:el_shaddai/core/customs/custom_time_range_picker.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:flutter/foundation.dart';
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
      onTap: () async {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        widget.controller.clear();
        sleep(const Duration(milliseconds: 100));
        TimeRange? result = await showCustomTimeRangePicker(
          disabledTime: eventReader.timeRange?.start.upToMinute ==
                  eventReader.timeRange?.end.upToMinute
              ? TimeRange(
                  startTime: const TimeOfDay(hour: 23, minute: 50),
                  endTime: const TimeOfDay(hour: 0, minute: 0))
              : null,
          start: eventReader.timeRange?.start != null
              ? TimeOfDay.fromDateTime(eventReader.timeRange!.start)
              : TimeOfDay(
                  hour:
                      (TimeOfDay.now().hour + 1), // Wrap around after midnight
                  minute: 0),
          end: eventReader.timeRange?.end != null
              ? TimeOfDay.fromDateTime(eventReader.timeRange!.end)
              : TimeOfDay(
                  hour:
                      (TimeOfDay.now().hour + 2), // Wrap around after midnight
                  minute: 10),
          handlerRadius: 10,
          use24HourFormat: false,
          clockRotation: 180,
          autoAdjustLabels: false,
          context: context,
          builder: (context, child) {
            return Column(
              children: [
                Container(
                  child: child,
                ),
                Container(
                  color: context.colors.surface,
                  width: 300,
                  height: 100,
                  child: Row(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.add))
                    ],
                  ),
                )
              ],
            );
          },
          snap: true,
          minDuration: const Duration(minutes: 10),
          interval: const Duration(minutes: 10),
          handlerColor: context.colors.onSurfaceVariant,
          selectedColor: Colors.transparent,
          strokeColor: context.colors.primary,
          labels: [
            '12 AM',
            '2 AM',
            '4 AM',
            '6 AM',
            '8 AM',
            '10 AM',
            '12 PM',
            '2 PM',
            '4 PM',
            '6 PM',
            '8 PM',
            '10 PM',
          ].asMap().entries.map((e) {
            return ClockLabel.fromIndex(
              idx: e.key,
              length: 12,
              text: e.value,
            );
          }).toList(),
          ticks: 12,
        );
        if (kDebugMode) {
          print("result $result");
          if (result != null) {
            print(result);
            eventFunction.setTimeRange(result);
          }
          // if (result != null &&
          //     result.endTime.hour != 0 &&
          //     !(result.startTime.hour == 23 && result.endTime.hour == 0) &&
          //     result.endTime.hour <= result.startTime.hour) {
          //   print('SUCESSS');
          //
          //   print('Start Time${result.startTime.hour}');
          //
          //   print('Start Time${result.endTime.hour}');
          //   print(result);
          //   eventFunction.setTimeRange(result);
          // } else {
          //   print('FAILED');
          // }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                print(eventReader.timeRange);
              },
              icon: const Icon(Icons.add)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: context.colors.outline,
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
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const Icon(Icons.arrow_right_alt_outlined),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              Icons.access_time_filled,
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10),
              color: context.colors.outline,
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
