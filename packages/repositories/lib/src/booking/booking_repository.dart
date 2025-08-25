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
  void deleteBooking(String bookingId) async {
    try {
      await _bookingCollection.doc(bookingId).delete();
    } on FirebaseException catch (e) {
      throw Failure(e.message ?? 'An error occurred.');
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  FutureEither<BookingModel> createOrEditBooking({
    required BookingModel bookingModel,
    String? bookingId, // Nullable booking ID (null = create, not null = update)
    required Function(String) call,
    RecurrenceConfigurationModel? recurrence,
  }) async {
    final model = bookingModel.copyWith(recurrenceModel: recurrence);

    print('Organization: $_organizationId');
    print('Booking ID: $bookingId');
    print('Booking Model: $bookingModel');

    try {
      if (bookingId == null) {
        // 🔹 Create New Booking
        final docRef = _bookingCollection.doc(); // Generate a new document ID
        final newModel = model.copyWith(
          id: docRef.id, // Assign the generated ID
          createdAt: DateTime.now(),
        );

        if (recurrence == null) {
          // Simple one-time booking
          await docRef.set(newModel.toJson());
        } else {
          // Recurring bookings with batch writes
          final batch = _firestore.batch();
          for (int i = 0; i < recurrence.recurrenceFrequency; i++) {
            DateTime newDate = recurrence.type == 1
                ? model.timeRange.start.add(Duration(days: i))
                : model.timeRange.start.add(Duration(days: i * 7));

            final recurringDoc = _bookingCollection.doc();
            BookingModel newRecurringModel = newModel.copyWith(
              id: recurringDoc.id,
              timeRange: CustomDateTimeRange(
                start: newDate,
                end: newDate.add(
                  model.timeRange.end.difference(model.timeRange.start),
                ),
              ),
            );

            batch.set(recurringDoc, newRecurringModel.toJson());
          }

          await batch.commit(); // Commit all writes in a single request
        }
        return right(newModel);
      } else {
        // 🔹 Update Existing Booking
        final docRef = _bookingCollection.doc(bookingId);
        final existingBooking = await docRef.get();

        if (!existingBooking.exists) {
          throw "Booking with ID $bookingId does not exist in organization $_organizationId.";
        }

        // **Ensure only the updated fields remain**
        final updatedModel = model.copyWith(id: bookingId);

        await docRef.set(updatedModel.toJson(), SetOptions(merge: false));

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
