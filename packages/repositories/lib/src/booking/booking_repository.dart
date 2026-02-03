import 'package:api/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:util/util.dart';

part 'booking_repository.g.dart';

final bookingRepositoryProvider = Provider.family<BookingRepository, String>((
  ref,
  organizationId,
) {
  return BookingRepository(
    firestore: ref.watch(firestoreProvider),
    organizationId: organizationId,
  );
});

class BookingRepository {
  final FirebaseFirestore _firestore;
  final String _organizationId;

  BookingRepository({
    required FirebaseFirestore firestore,
    required String organizationId,
  }) : _firestore = firestore,
       _organizationId = organizationId;

  CollectionReference get _bookingCollection => _firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(_organizationId)
      .collection(FirebaseConstants.bookingsCollection);

  // Inside BookingRepository class
  FutureEither<void> deleteBooking({
    required BookingModel bookingModel, // Pass the full model
    bool deleteEntireSeries = false,
  }) async {
    try {
      // --- PART A: ZOOM CLEANUP (If Zoom exists) ---
      // We just check the "receipt" (occurrenceId). If we have it, we use it.
      // if (booking.location.web != null) {
      //   final zoomId = parseZoomId(booking.location.web!);
      // if (zoomId.isNotEmpty) {
      //   final api = ApiRepository();
      //   // If deleting series, send null. If deleting one, send the receipt.
      //   await api.deleteMeeting(
      //       zoomId,
      //       occurrenceId: deleteEntireSeries ? null : booking.occurrenceId
      //   );
      // }
      // }

      // --- PART B: FIRESTORE CLEANUP (The Logic) ---
      if (deleteEntireSeries && bookingModel.groupId != null) {
        // DELETE ALL: Find everything with this GROUP ID
        final seriesQuery = await _bookingCollection
            .where('groupId', isEqualTo: bookingModel.groupId)
            .get();

        final batch = _firestore.batch();
        for (var doc in seriesQuery.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      } else {
        // DELETE ONE: Just delete this SPECIFIC ID
        await _bookingCollection.doc(bookingModel.id).delete();
      }

      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<BookingModel> createOrEditBooking({
    required BookingModel bookingModel,
    String? bookingId,
    required Function(String) call,
    RecurrenceConfigurationModel? recurrence,
    List<dynamic>? zoomOccurrences, // List from Zoom API response
  }) async {
    final model = bookingModel.copyWith(recurrenceModel: recurrence);

    try {
      if (bookingId == null) {
        // 🔹 CASE 1: CREATE NEW BOOKING

        if (recurrence != null) {
          // --- RECURRING LOGIC ---
          final batch = _firestore.batch();

          // 1. Generate ONE random "Series ID" for the whole group
          // We ask Firestore for a random ID (no read/write cost)
          final String sharedGroupId = _bookingCollection.doc().id;

          for (int i = 0; i < recurrence.recurrenceFrequency; i++) {
            // A. Calculate Local Date (Source of Truth)
            DateTime localDate = recurrence.type == 1
                ? model.timeRange.start.add(Duration(days: i))
                : model.timeRange.start.add(Duration(days: i * 7));

            // B. Match with Zoom Data (if it exists)
            // We verify i exists in the list to avoid range errors
            String? zoomOccId;
            if (zoomOccurrences != null && i < zoomOccurrences.length) {
              zoomOccId = zoomOccurrences[i]['occurrence_id'].toString();
            }

            // C. Create Document Reference
            final recurringDoc = _bookingCollection.doc();

            // D. Build the Model
            BookingModel newRecurringModel = model.copyWith(
              id: recurringDoc.id, // 1. Specific ID
              groupId: sharedGroupId, // 2. Group ID
              occurrenceId: zoomOccId, // 3. Zoom "Receipt" ID
              createdAt: DateTime.now(),
              timeRange: CustomDateTimeRange(
                start: localDate,
                end: localDate.add(
                  model.timeRange.end.difference(model.timeRange.start),
                ),
              ),
            );

            batch.set(recurringDoc, newRecurringModel.toJson());
          }
          await batch.commit();

          // Return the base model (or the first created one) just for UI updates
          return right(model.copyWith(groupId: sharedGroupId));
        } else {
          // --- SINGLE BOOKING LOGIC ---
          final docRef = _bookingCollection.doc();
          final newModel = model.copyWith(
            id: docRef.id,
            createdAt: DateTime.now(),
            groupId: null, // No series ID for single bookings
            occurrenceId: null,
          );

          await docRef.set(newModel.toJson());
          return right(newModel);
        }
      } else {
        // 🔹 CASE 2: UPDATE EXISTING BOOKING (Single Doc)
        // Note: Updating a whole recurring series is complex; this handles single edits.

        final docRef = _bookingCollection.doc(bookingId);
        final existingBooking = await docRef.get();

        if (!existingBooking.exists) {
          throw "Booking with ID $bookingId does not exist.";
        }

        // Ensure we preserve the ID and merge updates
        final updatedModel = model.copyWith(id: bookingId);

        await docRef.set(updatedModel.toJson(), SetOptions(merge: true));
        return right(updatedModel);
      }
    } on FirebaseException catch (e) {
      call(e.message ?? 'An error occurred.');
      return left(Failure(e.message ?? 'Unknown Firebase error'));
    } catch (e) {
      if (e.toString().contains('Null check operator used on a null value')) {
        call('Booking Failed! Fill in all the Data.');
      } else {
        call(e.toString());
      }
      return left(Failure(e.toString()));
    }
  }
}

@riverpod
Stream<List<BookingModel>> currentOrgBookingsStream(
  Ref ref, {
  required String organizationId,
}) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(organizationId)
      .collection(FirebaseConstants.bookingsCollection)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),
      );
}

@riverpod
Stream<BookingModel?> singleCurrentOrgBookingStream(
  Ref ref, {
  required String organizationId,
  required String bookingId,
}) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(organizationId)
      .collection(FirebaseConstants.bookingsCollection)
      .doc(bookingId)
      .snapshots()
      .map(
        (doc) => doc.exists
            ? BookingModel.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              })
            : null,
      );
}

//List<BookingData> <- List<Map> <- QuerySnapshot <-
