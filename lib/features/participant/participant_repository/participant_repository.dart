import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/features/participant/participant_controller/participant_controller.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final participantRepositoryProvider = Provider((ref) {
  return ParticipantRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class ParticipantRepository {
  final FirebaseFirestore _firestore;

  ParticipantRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _participant =>
      _firestore.collection(FirebaseConstants.participantsCollection);

  /// Adds a participant to a booking along with a timestamp (`when` field).

  Future<void> addParticipant(
    String bookingId,
    String userId,
  ) async {
    try {
      await _participant.doc(bookingId).set(
        {
          'participantsId': FieldValue.arrayUnion([
            {
              'userId': userId,
              'timestamp': DateTime.now().toIso8601String(),
            }
          ]),
        },
        SetOptions(merge: true), // Use merge to avoid overwriting existing data
      );
    } catch (e) {
      print('Error adding participant: $e');
      throw Exception('Failed to add participant');
    }
  }

  /// Fetches all participants for a given booking and returns a list of `UserModel`.
  Future<List<UserModel>> getAllParticipants(String bookingId) async {
    try {
      // Get the document for the given bookingId
      final snapshot = await _participant.doc(bookingId).get();
      if (snapshot.exists) {
        // Cast snapshot data to a Map<String, dynamic>
        final data = snapshot.data() as Map<String, dynamic>;

        // Extract the list of participant data
        final List participantsData = data['participantsId'] ?? [];

        if (participantsData.isEmpty) {
          return []; // Return an empty list if no participants are found
        }

        // Fetch user details for each participant ID
        final List<UserModel> participants = [];
        for (var participant in participantsData) {
          final participantId = participant['participantId'] as String?;
          if (participantId != null) {
            final userDoc = await _firestore
                .collection(FirebaseConstants.usersCollection)
                .doc(participantId)
                .get();

            if (userDoc.exists) {
              final userData = userDoc.data() as Map<String, dynamic>;
              participants.add(UserModel.fromJson(userData));
            }
          }
        }

        return participants;
      } else {
        // Booking document doesn't exist
        return [];
      }
    } catch (e) {
      print('Error fetching participants: $e');
      throw Exception('Failed to fetch participants');
    }
  }

  /// Checks if a participant already exists in a given booking.
  /// Checks if a participant already exists in a given booking.
  Future<bool> checkIfParticipantExists(
      String bookingId, String participantId) async {
    try {
      // Fetch the document for the given bookingId
      final snapshot = await _participant.doc(bookingId).get();

      if (snapshot.exists) {
        // Cast snapshot data to a Map<String, dynamic>
        final data = snapshot.data() as Map<String, dynamic>;

        // Extract the list of participant data
        final List participantsData = data['participantsId'] ?? [];

        // Check if the participant ID exists
        return participantsData.any((participant) {
          if (participant is Map<String, dynamic>) {
            return participant['userId'] == participantId;
          }
          return false; // Ensure we handle invalid data gracefully
        });
      }

      return false; // Booking document doesn't exist
    } catch (e) {
      print('Error checking participant existence: $e');
      throw Exception('Failed to check participant existence');
    }
  }
}
