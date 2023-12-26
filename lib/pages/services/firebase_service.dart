import 'package:calcu/pages/models/calculo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final firestore = FirebaseFirestore.instance;

  Stream<List<Calculo>> obtenerCalculos(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('friends')
          .doc('team')
          .collection('calculos')
          .withConverter<Calculo>(
            fromFirestore: (snapshot, _) => Calculo.fromJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson(),
          )
          .snapshots()
          .map(
            (snap) => snap.docs
                .map((doc) => doc.data())
                .whereType<Calculo>()
                .toList(),
          );

  void borrarCalculo(String uid, String id) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc('team')
        .collection('calculos')
        .doc(id)
        .delete();
  }
}
