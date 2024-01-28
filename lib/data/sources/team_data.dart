import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> teamCalculosStream() {
    User? user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]); // Si no hay usuario, retorna un stream vacío.
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .doc('team')
        .collection('calculos')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
