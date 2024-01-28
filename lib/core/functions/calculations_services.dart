// import 'package:calcu/models/calculos.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CalculationServices {
//   Stream<Calculos> getCalculations(User user) {
//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('calculos')
//         .withConverter<Calculos>(
//           fromFirestore: (snapshot, _) => Calculos.fromJson(snapshot.data()!),
//           toFirestore: (model, _) => model.toJson(),
//         )
//         .snapshots();
//   }
// }
