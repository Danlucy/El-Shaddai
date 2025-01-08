import 'package:el_shaddai/core/utility/date_time_range.dart';
import 'package:el_shaddai/features/booking/controller/booking_controller.dart';
import 'package:el_shaddai/features/booking/state/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

class RecurrenceComponent extends ConsumerStatefulWidget {
  const RecurrenceComponent({super.key});

  @override
  ConsumerState createState() => _RecurrenceComponentState();
}

class _RecurrenceComponentState extends ConsumerState<RecurrenceComponent> {
  @override
  Widget build(BuildContext context) {
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bookingReader = ref.watch(bookingControllerProvider);

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Repeat',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: ToggleButtons(
              selectedColor: Theme.of(context).colorScheme.secondary,
              textStyle: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              direction: Axis.vertical,
              isSelected: RecurrenceState.values
                  .map((e) => e == bookingReader.recurrenceState)
                  .toList(),
              onPressed: (int index) {
                setState(() {
                  bookingFunction
                      .setRecurrenceState(RecurrenceState.values[index]);
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              constraints: const BoxConstraints(
                minHeight: 30,
                maxHeight: 35,
                minWidth: 90,
                maxWidth: 120,
              ),
              children: RecurrenceState.values
                  .map((key) => Text(key.name.capitalize()))
                  .toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1f9cd49f)),
            ),
            child: SizedBox(
              width: 50,
              child: NumberPicker(
                value: bookingReader.recurrenceFrequency,
                minValue: 1,
                maxValue: 60,
                itemHeight: 40,
                haptics: true,
                onChanged: (value) {
                  bookingFunction.setRecurrenceFrequency(value);
                },
              ),
            ),
          ),
          Text(
            'Times',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          )
        ],
      ),
    );
  }
}
