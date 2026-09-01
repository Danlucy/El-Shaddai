import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:constants/constants.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeRepositoryProvider = Provider.family<HomeRepository, String>((
  ref,
  organizationId,
) {
  return HomeRepository(
    firestore: ref.watch(firestoreProvider),
    organizationId: organizationId,
  );
});

final homeTextStreamProvider = StreamProvider.autoDispose
    .family<String?, String>((ref, organizationId) {
      return ref.watch(homeRepositoryProvider(organizationId)).watchHomeText();
    });

class HomeRepository {
  HomeRepository({
    required FirebaseFirestore firestore,
    required String organizationId,
  }) : _firestore = firestore,
       _organizationId = organizationId;

  static const _contentDocumentId = 'content';

  final FirebaseFirestore _firestore;
  final String _organizationId;

  DocumentReference<Map<String, dynamic>> get _contentDocument => _firestore
      .collection(FirebaseConstants.churchesCollection)
      .doc(_organizationId)
      .collection(FirebaseConstants.homeCollection)
      .doc(_contentDocumentId);

  Stream<String?> watchHomeText() {
    return _contentDocument.snapshots().map((snapshot) {
      final text = snapshot.data()?['text'];
      return text is String && text.trim().isNotEmpty ? text : null;
    });
  }

  Future<void> updateHomeText({
    required String text,
    required String updatedBy,
  }) {
    return _contentDocument.set({
      'text': text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    }, SetOptions(merge: true));
  }
}
