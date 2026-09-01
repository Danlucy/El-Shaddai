import 'package:repositories/repositories.dart';

enum BookingSubmissionStatus { idle, submitting, success, failure }

class BookingSubmissionState {
  const BookingSubmissionState({
    this.status = BookingSubmissionStatus.idle,
    this.request,
    this.message,
    this.bookingIds = const [],
  });

  final BookingSubmissionStatus status;
  final BookingDTO? request;
  final String? message;
  final List<String> bookingIds;
}
