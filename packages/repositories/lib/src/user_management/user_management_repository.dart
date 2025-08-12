import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_repository.g.dart';

/// ✅ **Provider for UserManagementRepository**
@riverpod
UserManagementRepository userManagementRepository(Ref ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserManagementRepository(firestore);
}

/// ✅ **Normal Class (Not an `_riverpod` class)**
class UserManagementRepository {
  final FirebaseFirestore _firestore;

  /// 🔥 **Default Constructor**
  UserManagementRepository(this._firestore);

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  /// ✅ **Update user role**
  Future<void> updateUserRole(String role, String uId) async {
    try {
      await _user
          .doc(uId)
          .update({'role': role}); // Use `name` instead of `toString()`
    } catch (e) {
      print('Failed to update role: $e');
    }
  }

  /// ✅ **Delete user**
  Future<void> deleteUserData(String uid) async {
    await _user.doc(uid).delete();
  }

  Future<void> clearUserDataExcept(
    String uid,
  ) async {
    try {
      // First get the current document
      DocumentSnapshot doc = await _user.doc(uid).get();

      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> updatedData = {};

      // Set all fields to null except those we want to keep
      for (String key in userData.keys) {
        if (['name', 'role', 'uid'].contains(key)) {
          // Keep the original value for fields we want to preserve
          updatedData[key] = userData[key];
        } else {
          // Set all other fields to null
          updatedData[key] = null;
        }
      }

      // Update the document with the new data
      await _user.doc(uid).update(updatedData);
    } catch (e) {
      print('Error clearing user data: $e');
      rethrow;
    }
  }

  /// ✅ **usersByRole is now a method of the repository**
}

@riverpod
Stream<List<UserModel>> usersByRole(Ref ref,
    {UserRole? role, String searchTerm = ''}) {
  // Watch the userManagementRepositoryProvider to get the Firestore instance
  final userRepo = ref.watch(userManagementRepositoryProvider);
  final firestore =
      userRepo._firestore; // Access the private _firestore instance

  // Start with a base query
  Query<Map<String, dynamic>> query =
      firestore.collection(FirebaseConstants.usersCollection);

  // ✅ Step 1: Filter by role on the server if a role is provided
  if (role != null) {
    query = query.where('role',
        isEqualTo: role.name); // Using role.name for comparison
  }

  // ✅ Step 2: Sort the results on the server
  query = query.orderBy('name');

  return query.snapshots().map((snapshot) {
    List<UserModel> users = snapshot.docs.map((doc) {
      final userData = doc.data();
      final user = UserModel.fromJson({...userData, 'id': doc.id});
      return user;
    }).toList();

    // ✅ Step 3: Apply the name search filter on the client
    if (searchTerm.isNotEmpty) {
      users = users
          .where((user) =>
              user.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    return users;
  });
}
