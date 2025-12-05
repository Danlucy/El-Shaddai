import 'package:constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:util/util.dart';

import '../controller/booking_controller.dart';

class BookingDateRangePickerComponent extends ConsumerStatefulWidget {
  const BookingDateRangePickerComponent({super.key});

  @override
  ConsumerState<BookingDateRangePickerComponent> createState() =>
      _BookingDateRangePickerComponentState();
}

class _BookingDateRangePickerComponentState
    extends ConsumerState<BookingDateRangePickerComponent> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _hoverDate;
  DateTime? _selectingStart;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingControllerProvider);
    final bookingFunction = ref.read(bookingControllerProvider.notifier);
    final timeRange = bookingState.timeRange;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with month navigation
          _buildHeader(context),
          Gap(8),
          // Weekday labels
          _buildWeekdayLabels(context),

          // Calendar grid
          _buildCalendarGrid(context, timeRange, bookingFunction),

          // Selected range display
          if (timeRange != null) _buildRangeDisplay(context, timeRange),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(_currentMonth),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(
                    _currentMonth.year,
                    _currentMonth.month - 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous month',
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(
                    _currentMonth.year,
                    _currentMonth.month + 1,
                  );
                });
              },
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next month',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdayLabels(BuildContext context) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    CustomDateTimeRange? timeRange,
    BookingController bookingFunction,
  ) {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the month starts
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // ✅ CHECK: Are we currently selecting a new range?
    final bool isSelectingNewRange = _selectingStart != null;

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isPast = date.isBefore(todayDate);

      // ✅ LOGIC UPDATE:
      // If we are selecting a new range, we hide the old 'timeRange' visualization.
      // We only show the circle for the new '_selectingStart'.
      final isSelected = isSelectingNewRange
          ? date.isAtSameMomentAs(_selectingStart!)
          : timeRange != null &&
                (date.isAtSameMomentAs(
                      DateTime(
                        timeRange.start.year,
                        timeRange.start.month,
                        timeRange.start.day,
                      ),
                    ) ||
                    date.isAtSameMomentAs(
                      DateTime(
                        timeRange.end.year,
                        timeRange.end.month,
                        timeRange.end.day,
                      ),
                    ));

      // ✅ LOGIC UPDATE:
      // If we are selecting a new range, we ignore the old 'isInRange'.
      // The visual range is now handled purely by 'isInHoverRange' below.
      final isInRange =
          !isSelectingNewRange &&
          timeRange != null &&
          date.isAfter(
            DateTime(
              timeRange.start.year,
              timeRange.start.month,
              timeRange.start.day,
            ),
          ) &&
          date.isBefore(
            DateTime(
              timeRange.end.year,
              timeRange.end.month,
              timeRange.end.day,
            ),
          );

      final isHovered =
          _hoverDate != null &&
          date.isAtSameMomentAs(
            DateTime(_hoverDate!.year, _hoverDate!.month, _hoverDate!.day),
          );

      // Logic for the temporary hover range (remains the same)
      final isInHoverRange =
          _selectingStart != null &&
          _hoverDate != null &&
          ((date.isAfter(_selectingStart!) && date.isBefore(_hoverDate!)) ||
              (date.isAfter(_hoverDate!) && date.isBefore(_selectingStart!)));

      dayWidgets.add(
        _buildDayCell(
          context,
          date,
          day,
          isPast: isPast,
          isSelected: isSelected,
          isInRange: isInRange,
          isHovered: isHovered,
          isInHoverRange: isInHoverRange,
          onTap: isPast
              ? null
              : () {
                  if (_selectingStart == null) {
                    setState(() {
                      // Start selecting a new range
                      _selectingStart = date;
                    });
                  } else {
                    // Finish selecting
                    final start = _selectingStart!.isBefore(date)
                        ? _selectingStart!
                        : date;
                    final end = _selectingStart!.isBefore(date)
                        ? date
                        : _selectingStart!;

                    bookingFunction.setDateRange(
                      DateTimeRange(start: start, end: end),
                    );

                    setState(() {
                      _selectingStart = null;
                      _hoverDate = null;
                    });
                  }
                },
          onHover: (isHovering) {
            if (!isPast) {
              setState(() {
                _hoverDate = isHovering ? date : null;
              });
            }
          },
        ),
      );
    }

    return GridView.count(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: dayWidgets,
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime date,
    int day, {
    required bool isPast,
    required bool isSelected,
    required bool isInRange,
    required bool isHovered,
    required bool isInHoverRange,
    VoidCallback? onTap,
    required Function(bool) onHover,
  }) {
    Color? backgroundColor;
    Color? textColor;
    BoxDecoration? decoration;

    if (isPast) {
      textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.3);
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      );
    } else if (isInRange || isInHoverRange) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.2);
      textColor = Theme.of(context).colorScheme.onSurface;
      decoration = BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      );
    } else if (isHovered) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
      textColor = Theme.of(context).colorScheme.onSurface;
      decoration = BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
      );
    } else {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      cursor: isPast ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: decoration,
          child: Center(
            child: Text(
              day.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRangeDisplay(
    BuildContext context,
    CustomDateTimeRange timeRange,
  ) {
    final isSameDay =
        timeRange.start.year == timeRange.end.year &&
        timeRange.start.month == timeRange.end.month &&
        timeRange.start.day == timeRange.end.day;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            isSameDay
                ? DateFormat('MMM d, yyyy').format(timeRange.start)
                : '${DateFormat('MMM d').format(timeRange.start)} - ${DateFormat('MMM d, yyyy').format(timeRange.end)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              ref
                  .read(bookingControllerProvider.notifier)
                  .setDateRange(
                    DateTimeRange(start: DateTime.now(), end: DateTime.now()),
                  );
              setState(() {
                _selectingStart = null;
                _hoverDate = null;
              });
            },
            child: Icon(Icons.close, size: 30, color: context.colors.error),
          ),
        ],
      ),
    );
  }
}
