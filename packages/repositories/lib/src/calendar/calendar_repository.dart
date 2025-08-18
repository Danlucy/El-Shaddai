import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_repository.g.dart';

@riverpod
class CalendarDateNotifier extends _$CalendarDateNotifier {
  @override
  DateTime build() {
    return DateTime.now(); // Initial state
  }

  void updateSelectedDate(DateTime date) {
    state = date; // Update the state with the selected date
  }
}

class CalendarRepository {
  final FirebaseFirestore _firestore;

  CalendarRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
}
