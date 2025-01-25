import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/features/booking/repository/booking_repository.dart';
import 'package:el_shaddai/models/booking_model/booking_model.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_repository.g.dart';

class UserManagementRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Future<void> updateUserRole(UserRole role, String uId) async {
    try {
      await _user.doc(uId).update({
        'role': role.toString(),
      });
    } catch (e) {
      print('Failed to update role: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}

@riverpod
Stream<List<UserModel>> users(UsersRef ref) {
  return ref
      .watch(firestoreProvider)
      .collection(FirebaseConstants.usersCollection)
      .snapshots()
      .map(
        (value) => value.docs.map(
          (e) {
            final x = UserModel.fromJson({...e.data(), 'id': e.id});
            return x;
          },
        ).toList(),
      );
  //List<BookingData> <- List<Map> <- QuerySnapshot <-
}
