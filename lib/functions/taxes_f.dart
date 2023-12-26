import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalculadoraProvider extends ChangeNotifier {
  double _sumaCalculosIndividuales = 0.0;
  double _sumaCalculosEnEquipo = 0.0;

  double get sumaCalculosIndividuales => _sumaCalculosIndividuales;
  double get sumaCalculosEnEquipo => _sumaCalculosEnEquipo;

Future<void> calcularSumaCalculosIndividuales() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userId = user.uid;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Obtén una referencia al documento de usuario en lugar de obtenerlo directamente.
    DocumentReference userDocumentRef = usersCollection.doc(userId);

    // Escucha cambios en el documento.
    userDocumentRef.snapshots().listen((event) {
      if (event.exists && event.data() != null) {
        Map<String, dynamic> userData = event.data() as Map<String, dynamic>;

        if (userData['remainingAmountList'] is List<dynamic>) {
          List<dynamic> remainingAmountList = userData['remainingAmountList'];

          double suma = 0.0;
          for (var value in remainingAmountList) {
            if (value is double) {
              suma += value;
            }
          }

          _sumaCalculosIndividuales = suma;
          notifyListeners(); // Notifica a los oyentes (widgets) que el estado ha cambiado.
        }
      }
    });
  }
}


Future<void> calcularSumaCalculosEnEquipo() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String userId = user.uid;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Acceder a la subcolección "friends" y al documento "team" dentro de ella
    DocumentReference teamDocumentRef =
        usersCollection.doc(userId).collection('friends').doc('team');

    // Escuchar cambios en el documento "team"
    teamDocumentRef.snapshots().listen((teamDocument) {
      if (teamDocument.exists && teamDocument.data() != null) {
        // Utiliza "as Map<String, dynamic>" para especificar el tipo de los datos
        Map<String, dynamic> teamData = teamDocument.data() as Map<String, dynamic>;

        // Acceder a "remainingAmountList" y realizar una comprobación de nulidad y tipo
        if (teamData.containsKey('remainingAmountList') &&
            teamData['remainingAmountList'] is List<dynamic>) {
          List<dynamic> remainingAmountList = teamData['remainingAmountList'];

          // Si hay un solo elemento en la lista, mostrar ese elemento
          if (remainingAmountList.length == 1 && remainingAmountList[0] is double) {
            _sumaCalculosEnEquipo = remainingAmountList[0];
          } else {
            // Calcular la suma de los valores en "remainingAmountList"
            double suma = 0.0;
            for (var value in remainingAmountList) {
              if (value is double) {
                suma += value;
              }
            }
            _sumaCalculosEnEquipo = suma;
          }
          notifyListeners(); // Notifica a los oyentes (widgets) que el estado ha cambiado.
        }
      }
    });
  }
}


}
