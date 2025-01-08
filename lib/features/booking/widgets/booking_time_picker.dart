import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:el_shaddai/core/constants/constants.dart';
import 'package:el_shaddai/core/customs/custom_time_range_picker.dart';
import 'package:el_shaddai/core/theme.dart';
import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/presentations/booking_screen.dart';
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
          timeTextStyle: const TextStyle(fontSize: 22),
          activeTimeTextStyle: const TextStyle(fontSize: 22),
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
            return Container(
              child: child,
            );
          },
          snap: true,
          minDuration: const Duration(minutes: 10),
          interval: const Duration(minutes: 10),
          handlerColor: context.colors.onSurfaceVariant,
          selectedColor: Colors.transparent,
          strokeColor: context.colors.primary,
          labels: timeLabels.asMap().entries.map((e) {
            return ClockLabel.fromIndex(
              idx: e.key,
              length: 12,
              text: e.value,
            );
          }).toList(),
          ticks: 12,
        );

        // print("result $result");
        if (result != null) {
          eventFunction.setTimeRange(result);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: context.colors.outline,
              ),
              child: AutoSizeText(
                textAlign: TextAlign.center,
                minFontSize: 10, // Minimum font size
                maxFontSize: 20,
                eventReader.timeRange?.start != null
                    ? DateFormat.jm().format(eventReader.timeRange!.start)
                    : 'Start Time',
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: context.colors.outline,
              ),
              child: AutoSizeText(
                textAlign: TextAlign.center,

                minFontSize: 10, // Minimum font size
                maxFontSize: 20,
                eventReader.timeRange?.end != null
                    ? DateFormat.jm().format(eventReader.timeRange!.end)
                    : 'End Time',
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
