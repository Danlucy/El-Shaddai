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

  /// ✅ **Delete user and all their bookings across ALL organizations**
  Future<void> deleteUserAccount(String uid) async {
    try {
      final batch = _firestore.batch();

      // 1. Find all bookings hosted by this user anywhere in the database
      // Using collectionGroup searches every subcollection named "bookings"
      final bookingsQuery = await _firestore
          .collectionGroup(FirebaseConstants.bookingsCollection)
          .where('userId', isEqualTo: uid)
          .get();

      // 2. Queue all those bookings for deletion
      for (var doc in bookingsQuery.docs) {
        batch.delete(doc.reference);
      }

      // 3. Queue the actual user document for deletion
      final userDocRef = _user.doc(
        uid,
      ); // Assumes _user is defined as the users collection
      batch.delete(userDocRef);

      // 4. Commit everything simultaneously
      await batch.commit();
    } catch (e) {
      print('Error deleting user data and bookings: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .orderBy(UserModel.fields.name)
        .get(); // 👈 Using .get() instead of .snapshots()

    return snapshot.docs.map((doc) {
      final userData = doc.data();
      return UserModel.fromJson({...userData, 'id': doc.id});
    }).toList();
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

  query = query.orderBy(UserModel.fields.name);

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
