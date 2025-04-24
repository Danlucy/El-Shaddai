import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shaddai/core/constants/firebase_constants.dart';
import 'package:el_shaddai/core/firebase_providers.dart';
import 'package:el_shaddai/models/user_model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_repository.g.dart';

/// ✅ **Provider for UserManagementRepository**
@riverpod
UserManagementRepository userManagementRepository(
    UserManagementRepositoryRef ref) {
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
  Future<void> updateUserRole(UserRole role, String uId) async {
    try {
      await _user.doc(uId).update({
        'role': role.name.toLowerCase()
      }); // Use `name` instead of `toString()`
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
}

@riverpod
Stream<List<UserModel>> usersByRole(UsersByRoleRef ref,
    {String searchTerm = ''}) {
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection(FirebaseConstants.usersCollection)
      .snapshots()
      .map((snapshot) {
    List<UserModel> users = snapshot.docs.map((doc) {
      final userData = doc.data();
      final user = UserModel.fromJson({...userData, 'id': doc.id});
      return user;
    }).toList();

    // ✅ Apply name search filter
    if (searchTerm.isNotEmpty) {
      users = users
          .where((user) =>
              user.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    // ✅ Sort users by role and then by name
    users.sort((a, b) {
      // First, compare by role
      final roleComparison = a.role.toString().compareTo(b.role.toString());

      // If roles are the same, compare by name
      if (roleComparison == 0) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return roleComparison;
    });

    return users;
  });
}
