import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/firebase_providers.dart';
import '../../../models/user_model/user_model.dart';

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

  Future<void> removeParticipant(String bookingId, String userId) async {
    try {
      // 1️⃣ Fetch the document
      final snapshot = await _participant.doc(bookingId).get();
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> participantsData = data['participantsId'] ?? [];

      // 2️⃣ Filter out the userId
      final updatedParticipants = participantsData
          .where((participant) => participant['userId'] != userId)
          .toList();

      // 3️⃣ Overwrite the array in Firestore
      await _participant.doc(bookingId).update({
        'participantsId': updatedParticipants,
      }).then((d) {
        if (updatedParticipants.isEmpty) {
          _participant.doc(bookingId).delete();
        }
      });

      if (kDebugMode) {
        print("Participant removed successfully");
      }
    } catch (e) {
      print('Error removing participant: $e');
      throw Exception('Failed to remove participant');
    }
  }

  Future<void> isEmptyThenRemove(String bookingId) async {
    try {
      final snapshot = await _participant.doc(bookingId).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List participants = data['participantsId'] ?? [];

        if (participants.isEmpty) {
          await _participant.doc(bookingId).delete();
        }
      }
    } catch (e) {
      print('Error checking if booking is empty: $e');
    }
  }

  /// Fetches all participants for a given booking and returns a list of `UserModel`.
  Stream<List<UserModel>> getAllParticipants(String bookingId) {
    return _participant.doc(bookingId).snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) return [];

      final data = snapshot.data() as Map<String, dynamic>;
      final List participantsData = data['participantsId'] ?? [];

      if (participantsData.isEmpty) return [];

      final userIds = participantsData.map((p) => p['userId']).toList();

      // Fetch all users in a single query
      final userSnapshots = await _firestore
          .collection(FirebaseConstants.usersCollection)
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      return userSnapshots.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
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
