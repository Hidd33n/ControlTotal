// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadUsername(void Function(String) setUsername) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      setUsername(userDoc.get('username'));
    }
  }

  Future<void> eliminarCalculoParaTodos(String documentoId) async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .doc('team')
          .collection('calculos')
          .doc(documentoId)
          .delete();

      var friendsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .get();

      if (friendsSnapshot.docs.isNotEmpty) {
        for (var friendDoc in friendsSnapshot.docs) {
          var friendUid = friendDoc.id;

          await _firestore
              .collection('users')
              .doc(friendUid)
              .collection('friends')
              .doc('team')
              .collection('calculos')
              .doc(documentoId)
              .delete();
        }
      }
    }
  }
}
