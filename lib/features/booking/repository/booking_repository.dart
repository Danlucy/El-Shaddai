import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/api/models/recurrence_configuration_model/recurrence_configuration_model.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/customs/custom_date_time_range.dart';
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
      {required BookingModel model,
      required Function(String) call,
      RecurrenceConfigurationModel? recurrence}) async {
    print('recurrent');
    print(recurrence);
    try {
      if (recurrence == null) {
        await _book.doc(model.id).set(model.toJson());
        return right(model);
      } else {
        for (int i = 0; i < recurrence.recurrenceFrequency; i++) {
          print('id');
          print(i);
          DateTime newDate = recurrence.type == 1
              ? model.timeRange.start.add(Duration(days: i))
              : model.timeRange.start.add(Duration(days: i * 7));
          final doc = _book.doc();
          BookingModel newBookingModel = BookingModel(
            timeRange: CustomDateTimeRange(
              start: newDate, // Update start time
              end: newDate.add(model.timeRange.end
                  .difference(model.timeRange.start)), // Preserve duration
            ),
            createdAt: DateTime.now(),
            recurrenceState: model.recurrenceState,
            title: model.title,
            host: model.host,
            userId: model.userId,
            id: doc.id, // Generate a new ID for each booking
            location: model.location,
            description: model.description,
          );
          await doc.set({
            ...newBookingModel.toJson(),
            'recurrence': recurrence.toJson(),
          });
        }
        return right(model);
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e, stacktrace) {
      // print(e);
      // print(stacktrace);
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
        (value) => value.docs.map(
          (e) {
            final x = BookingModel.fromJson({...e.data(), 'id': e.id});
            return x;
          },
        ).toList(),
      );
  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}

//List<BookingData> <- List<Map> <- QuerySnapshot <-
