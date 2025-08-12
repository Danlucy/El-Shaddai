import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final calendarRepositoryProvider = Provider((ref) {
  return CalendarRepository(
    firestore: ref.watch(firestoreProvider),
  );
});

class CalendarRepository {
  final FirebaseFirestore _firestore;

  CalendarRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
}
