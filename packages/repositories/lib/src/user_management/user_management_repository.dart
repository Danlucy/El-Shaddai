import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_management_repository.g.dart';

/// ✅ **Provider for UserManagementRepository**
@riverpod
UserManagementRepository userManagementRepository(
  Ref ref,
  String? organizationId,
) {
  final firestore = ref.watch(firestoreProvider);
  return UserManagementRepository(
    firestore: firestore,
    organizationId: organizationId,
  );
}

/// ✅ **Normal Class (Not an `_riverpod` class)**
class UserManagementRepository {
  final FirebaseFirestore _firestore;
  final String? _organizationId;

  /// 🔥 **Default Constructor**
  UserManagementRepository({
    required FirebaseFirestore firestore,
    required String? organizationId,
  }) : _firestore = firestore,
       _organizationId = organizationId;
  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  /// ✅ **Update user role**
  Future<void> updateUserRole({
    required String uid,
    required String role,
  }) async {
    try {
      if (_organizationId == null) {
        throw Exception('Organization ID is not set.');
      }
      await _user.doc(uid).update({
        'roles.$_organizationId': role, // nested field update
      });
    } catch (e) {
      print('Failed to update role: $e');
      rethrow;
    }
  }

  /// ✅ **Delete user**
  Future<void> deleteUserData(String uid) async {
    await _user.doc(uid).delete();
  }

  Future<void> clearUserDataExcept(String uid) async {
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
Stream<List<UserModel>> usersByRoleForOrg(
  Ref ref, {
  required String orgId,
  UserRole? role,
  String searchTerm = '',
}) {
  final firestore = ref.watch(firestoreProvider);

  Query<Map<String, dynamic>> query = firestore.collection(
    FirebaseConstants.usersCollection,
  );

  query = query.orderBy('name');

  return query.snapshots().map((snapshot) {
    final users = snapshot.docs.map((doc) {
      final userData = doc.data();
      return UserModel.fromJson({...userData, 'id': doc.id});
    }).toList();

    return users.where((user) {
      final userRole = user.roles[orgId] ?? UserRole.observer;

      if (role != null && userRole != role) return false;

      if (searchTerm.isNotEmpty &&
          !user.name.toLowerCase().contains(searchTerm.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  });
}
