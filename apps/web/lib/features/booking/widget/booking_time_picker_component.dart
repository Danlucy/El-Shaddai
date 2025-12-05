import 'package:auto_size_text/auto_size_text.dart';
import 'package:constants/constants.dart'; // Assuming this exists based on your imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Import Responsive Framework

import '../controller/booking_controller.dart';

class BookingTimePickerComponent extends ConsumerStatefulWidget {
  const BookingTimePickerComponent({super.key});

  @override
  ConsumerState<BookingTimePickerComponent> createState() =>
      _BookingTimePickerComponentState();
}

class _BookingTimePickerComponentState
    extends ConsumerState<BookingTimePickerComponent> {
  @override
  Widget build(BuildContext context) {
    final eventReader = ref.watch(bookingControllerProvider);
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    // 1. Create the widgets effectively (Reuse logic)
    final startPickerWidget = _TimePickerLabel(
      time: eventReader.timeRange?.start,
      defaultLabel: 'Start Time',
      icon: Icons.schedule,
      onTap: () => _showTimePickerDialog(
        context,
        title: 'Select Start Time',
        onTimeSelected: (selectedTime) {
          ref
              .read(bookingControllerProvider.notifier)
              .setStartTime(selectedTime, context);
        },
        initialTime: eventReader.timeRange?.start,
      ),
    );

    final endPickerWidget = _TimePickerLabel(
      time: eventReader.timeRange?.end,
      defaultLabel: 'End Time',
      icon: Icons.schedule,
      onTap: () => _showTimePickerDialog(
        context,
        title: 'Select End Time',
        onTimeSelected: (selectedTime) {
          ref
              .read(bookingControllerProvider.notifier)
              .setEndTime(selectedTime, context);
        },
        initialTime: eventReader.timeRange?.end,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: isDesktop
          ? _buildVerticalLayout(context, startPickerWidget, endPickerWidget)
          : _buildHorizontalLayout(context, startPickerWidget, endPickerWidget),
    );
  }

  // ✅ DESKTOP: Vertical Layout (Column)
  Widget _buildVerticalLayout(
    BuildContext context,
    Widget startPicker,
    Widget endPicker,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        startPicker,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Icon(
            Icons.arrow_downward,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        endPicker,
      ],
    );
  }

  // ✅ MOBILE: Horizontal Layout (Row)
  Widget _buildHorizontalLayout(
    BuildContext context,
    Widget startPicker,
    Widget endPicker,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: startPicker),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Expanded(child: endPicker),
      ],
    );
  }

  void _showTimePickerDialog(
    BuildContext context, {
    required String title,
    required Function(DateTime) onTimeSelected,
    DateTime? initialTime,
  }) {
    showDialog(
      context: context,
      builder: (context) => TimePickerDialog(
        title: title,
        onTimeSelected: onTimeSelected,
        initialTime: initialTime,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// The rest of your code (_TimePickerLabel, TimePickerDialog, etc.) remains exactly the same below
// -----------------------------------------------------------------------------

class _TimePickerLabel extends StatelessWidget {
  const _TimePickerLabel({
    required this.time,
    required this.defaultLabel,
    required this.icon,
    required this.onTap,
  });

  final DateTime? time;
  final String defaultLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Flexible(
              child: AutoSizeText(
                time != null ? DateFormat.jm().format(time!) : defaultLabel,
                textAlign: TextAlign.center,
                minFontSize: 12,
                maxFontSize: 16,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: time != null
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimePickerDialog extends StatefulWidget {
  const TimePickerDialog({
    required this.title,
    required this.onTimeSelected,
    this.initialTime,
    super.key,
  });

  final String title;
  final Function(DateTime) onTimeSelected;
  final DateTime? initialTime;

  @override
  _TimePickerDialogState createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int selectedHour;
  late int selectedMinute;
  bool is24HourFormat = false;
  String selectedPeriod = 'AM';

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    final initialTime = widget.initialTime ?? DateTime.now();

    if (is24HourFormat) {
      selectedHour = initialTime.hour;
    } else {
      selectedHour = initialTime.hour > 12
          ? initialTime.hour - 12
          : (initialTime.hour == 0 ? 12 : initialTime.hour);
      selectedPeriod = initialTime.hour >= 12 ? 'PM' : 'AM';
    }

    selectedMinute = (initialTime.minute / 5).floor() * 5;

    final hourIndex = is24HourFormat ? selectedHour : selectedHour - 1;
    final minuteIndex = selectedMinute ~/ 5;

    _hourController = FixedExtentScrollController(initialItem: hourIndex);
    _minuteController = FixedExtentScrollController(initialItem: minuteIndex);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  DateTime _getSelectedDateTime() {
    int hour = selectedHour;
    if (!is24HourFormat) {
      if (selectedPeriod == 'PM' && hour != 12) {
        hour += 12;
      } else if (selectedPeriod == 'AM' && hour == 12) {
        hour = 0;
      }
    }

    final now = widget.initialTime ?? DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, selectedMinute);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Format toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FormatToggle(
                  label: '12-hour',
                  isSelected: !is24HourFormat,
                  onTap: () {
                    setState(() {
                      is24HourFormat = false;
                      if (selectedHour > 12) {
                        selectedHour -= 12;
                      } else if (selectedHour == 0) {
                        selectedHour = 12;
                      }
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FormatToggle(
                  label: '24-hour',
                  isSelected: is24HourFormat,
                  onTap: () {
                    setState(() {
                      is24HourFormat = true;
                      if (selectedPeriod == 'PM' && selectedHour != 12) {
                        selectedHour += 12;
                      } else if (selectedPeriod == 'AM' && selectedHour == 12) {
                        selectedHour = 0;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Time display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpac(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    DateFormat.jm().format(_getSelectedDateTime()),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Time selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeScrollSelector(
                  controller: _hourController,
                  items: is24HourFormat
                      ? List.generate(24, (i) => i.toString().padLeft(2, '0'))
                      : List.generate(
                          12,
                          (i) => (i + 1).toString().padLeft(2, '0'),
                        ),
                  selectedValue: selectedHour.toString().padLeft(2, '0'),
                  onChanged: (value) {
                    setState(() {
                      selectedHour = int.parse(value);
                    });
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                _TimeScrollSelector(
                  controller: _minuteController,
                  items: List.generate(
                    12,
                    (i) => (i * 5).toString().padLeft(2, '0'),
                  ),
                  selectedValue: selectedMinute.toString().padLeft(2, '0'),
                  onChanged: (value) {
                    setState(() {
                      selectedMinute = int.parse(value);
                    });
                  },
                ),

                if (!is24HourFormat) ...[
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      _PeriodButton(
                        label: 'AM',
                        isSelected: selectedPeriod == 'AM',
                        onTap: () {
                          setState(() {
                            selectedPeriod = 'AM';
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _PeriodButton(
                        label: 'PM',
                        isSelected: selectedPeriod == 'PM',
                        onTap: () {
                          setState(() {
                            selectedPeriod = 'PM';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    widget.onTimeSelected(_getSelectedDateTime());
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeScrollSelector extends StatelessWidget {
  const _TimeScrollSelector({
    required this.controller,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  final FixedExtentScrollController controller;
  final List<String> items;
  final String selectedValue;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 50.0;
    const double containerHeight = 150.0;

    return Container(
      height: containerHeight,
      width: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ),

          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: itemHeight,
            physics: const FixedExtentScrollPhysics(),
            magnification: 2,
            diameterRatio: 1.5,
            squeeze: 1,
            onSelectedItemChanged: (index) {
              onChanged(items[index]);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: items.length,
              builder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedValue;

                return GestureDetector(
                  onTap: () {
                    onChanged(item);
                    controller.animateToItem(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: isSelected ? 20 : 16,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatToggle extends StatelessWidget {
  const _FormatToggle({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpac(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _PeriodButton extends StatelessWidget {
  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpac(0.3),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
