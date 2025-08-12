import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:util/util.dart';

import '../controller/booking_controller.dart';

class RecurrenceComponent extends ConsumerStatefulWidget {
  const RecurrenceComponent({super.key});

  @override
  ConsumerState createState() => _RecurrenceComponentState();
}

class _RecurrenceComponentState extends ConsumerState<RecurrenceComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateAnimation(RecurrenceState recurrenceState) {
    if (recurrenceState != RecurrenceState.none) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final bookingReader = ref.watch(bookingControllerProvider);

    // Update animation when recurrence state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimation(bookingReader.recurrenceState);
    });

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
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _slideAnimation,
                axis: Axis.horizontal,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 2),
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
                      const SizedBox(width: 10),
                      Text(
                        'Times',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
