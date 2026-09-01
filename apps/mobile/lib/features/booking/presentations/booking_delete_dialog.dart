import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/confirm_dialog.dart';
import 'package:models/models.dart';

enum BookingDeleteChoice { thisOccurrence, entireSeries }

Future<BookingDeleteChoice?> showBookingDeleteConfirmation({
  required BuildContext context,
  required BookingModel booking,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => ConfirmDialog(
      confirmText: 'Delete',
      cancelText: 'Cancel',
      description: 'Are you sure you want to delete this booking?',
      confirmAction: () => Navigator.of(dialogContext).pop(true),
      title: 'Delete Booking',
    ),
  );

  if (confirmed != true || !context.mounted) return null;

  if (booking.groupId == null) {
    return BookingDeleteChoice.thisOccurrence;
  }

  return showDialog<BookingDeleteChoice>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Recurring Event'),
      content: const Text(
        'This is a recurring session. Do you want to delete only this session or the entire series?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(
            dialogContext,
          ).pop(BookingDeleteChoice.thisOccurrence),
          child: const Text('This Only'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(dialogContext).pop(BookingDeleteChoice.entireSeries),
          child: const Text(
            'Entire Series',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
