import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/core/utility/failure.dart';
import 'package:el_shaddai/core/utility/future_either.dart';
import 'package:el_shaddai/models/event_model/event_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'event_repository.g.dart';

final eventRepositoryProvider = Provider((ref) {
  return EventRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class EventRepository {
  final FirebaseFirestore _firestore;

  EventRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _book =>
      _firestore.collection(FirebaseConstants.eventCollection);

  FutureEither<EventModel> createEvent(
      EventModel data, Function(String) call) async {
    try {
      await _book.doc(data.id).set(data.toJson());

      return right(data);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      if (e.toString().contains('Null check operator used on a null value')) {
        call('Event Failed! Fill in all the Data.');
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
Stream<List<EventModel>> events(EventsRef ref) {
  return ref
      .watch(firestoreProvider)
      .collection(FirebaseConstants.bookingCollection)
      .snapshots()
      .map(
        (value) => value.docs
            .map(
              (e) => EventModel.fromJson({...e.data(), 'id': e.id}),
            )
            .toList(),
      );
  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}

//List<BookingData> <- List<Map> <- QuerySnapshot <-
