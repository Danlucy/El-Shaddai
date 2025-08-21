import 'package:flutter/foundation.dart';
import 'package:repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/controller/auth_controller.dart';
import '../state/participant_state.dart';

part 'participant_controller.g.dart';

@riverpod
class ParticipantController extends _$ParticipantController {
  @override
  ParticipantState build(String bookingId) {
    // Initialize state with the provided bookingId and userId
    final userId = ref.watch(userProvider)?.uid;
    return ParticipantState(
      userId: userId ?? 'default_user_id',
      bookingId: bookingId,
    );
  }

  // void initialize() {
  //   final repository = ref.read(participantRepositoryProvider);
  //   if (state.bookingId != null && state.userId != null) {
  //   } else {
  //     throw 'User unavailable, check Internet connection';
  //   }
  // }
  setUserId(String id) {
    state = state.copyWith(userId: id);
  }

  setBookingId(String bookingId) {
    state = state.copyWith(bookingId: bookingId);
  }

  Future<void> addParticipant() async {
    final repository = ref.read(participantRepositoryProvider);

    if (state.userId!.isNotEmpty && state.userId != null) {
      try {
        // Check if the participant already exists in the booking
        final exists = await repository.checkIfParticipantExists(
          state.bookingId!,
          state.userId!,
        );
        if (!exists) {
          // Add the participant along with a timestamp ("when" field)
          await repository.addParticipant(state.bookingId!, state.userId!);
        } else {
          if (kDebugMode) {
            print('Participant already exists in the booking');
          }
        }
      } catch (e) {
        throw 'Failed to add participant: $e';
      }
    } else {
      throw 'Booking unavailable or participant ID is invalid';
    }
  }

  Future<void> removeParticipant() async {
    final repository = ref.read(participantRepositoryProvider);

    if (state.userId!.isNotEmpty && state.userId != null) {
      try {
        // Check if the participant already exists in the booking
        final exists = await repository.checkIfParticipantExists(
          state.bookingId!,
          state.userId!,
        );
        if (exists) {
          // Add the participant along with a timestamp ("when" field)
          await repository.removeParticipant(state.bookingId!, state.userId!);
          // await repository.isEmptyThenRemove(state.bookingId!);
        } else {
          if (kDebugMode) {
            print('Participant does not exists in the booking');
          }
        }
      } catch (e) {
        throw 'Failed to add participant: $e';
      }
    } else {
      throw 'Booking unavailable or participant ID is invalid';
    }
  }
}
