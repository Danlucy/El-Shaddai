import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repositories/repositories.dart';

import '../state/booking_submission_state.dart';

export '../state/booking_submission_state.dart';

final bookingSubmissionProvider =
    NotifierProvider<BookingSubmissionNotifier, BookingSubmissionState>(
      BookingSubmissionNotifier.new,
    );

class BookingSubmissionNotifier extends Notifier<BookingSubmissionState> {
  final List<BookingDTO> _queue = [];
  bool _isProcessing = false;

  @override
  BookingSubmissionState build() => const BookingSubmissionState();

  void submit(BookingDTO request) {
    _queue.add(request);
    if (!_isProcessing) {
      unawaited(_drainQueue());
    }
  }

  void retry() {
    final failedRequest = state.request;
    if (failedRequest != null &&
        state.status == BookingSubmissionStatus.failure) {
      submit(failedRequest);
    }
  }

  Future<void> _drainQueue() async {
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final request = _queue.removeAt(0);
      state = BookingSubmissionState(
        status: BookingSubmissionStatus.submitting,
        request: request,
        message: 'Saving booking…',
      );

      try {
        final response =
            await FirebaseFunctions.instanceFor(region: 'asia-southeast1')
                .httpsCallable('submitBooking')
                .call<Map<String, dynamic>>(request.toCallableData());
        final data = response.data;
        final bookingIds =
            (data['bookingIds'] as List<dynamic>? ?? const <dynamic>[])
                .map((id) => id.toString())
                .toList(growable: false);

        state = BookingSubmissionState(
          status: BookingSubmissionStatus.success,
          request: request,
          message: data['message']?.toString() ?? 'Booking saved.',
          bookingIds: bookingIds,
        );
      } on FirebaseFunctionsException catch (error) {
        state = BookingSubmissionState(
          status: BookingSubmissionStatus.failure,
          request: request,
          message: error.message ?? _messageForCode(error.code),
        );
      } catch (_) {
        state = BookingSubmissionState(
          status: BookingSubmissionStatus.failure,
          request: request,
          message:
              'The booking could not be confirmed by the server. Check your connection and retry.',
        );
      }
    }

    _isProcessing = false;
  }

  String _messageForCode(String code) {
    return switch (code) {
      'unauthenticated' => 'Please sign in again before retrying this booking.',
      'unavailable' || 'deadline-exceeded' =>
        'The server could not be reached. Check your connection and retry.',
      _ => 'The booking could not be saved. Please retry.',
    };
  }
}
