import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/core/utility/failure.dart';
import 'package:el_shaddai/core/utility/future_either.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'booking_repository.g.dart';

final bookingRepositoryProvider = Provider((ref) {
  return BookingRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _book =>
      _firestore.collection(FirebaseConstants.bookingCollection);

  FutureEither<BookingModel> createBooking(
      BookingModel data, Function(String) call) async {
    try {
      await _book.doc(data.id).set(data.toJson());

      return right(data);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e, stacktrace) {
      print(stacktrace);
      if (e.toString().contains('Null check operator used on a null value')) {
        call('Booking Failed! Fill in all the Data.');
      } else {
        call(e.toString());
      }
      return left(Failure(e.toString()));
    }
  }

  void deleteGroupBooking(String id) {
    _book.doc(id).delete();
  }
}

@riverpod
Stream<List<BookingModel>> bookings(BookingsRef ref) {
  return ref
      .watch(firestoreProvider)
      .collection(FirebaseConstants.bookingCollection)
      .snapshots()
      .map(
        (value) => value.docs
            .map(
              (e) => BookingModel.fromJson({...e.data(), 'id': e.id}),
            )
            .toList(),
      );
  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}

//List<BookingData> <- List<Map> <- QuerySnapshot <-
