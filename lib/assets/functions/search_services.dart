import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class User {
  final String username;

  User({
    required this.username,
  });
}

class SearchService {
  BuildContext? context;
  String currentUserUsername = '';
  String currentUserUid = '';

  Future<String?> fetchCurrentUserUsername() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      currentUserUid = user.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      if (userSnapshot.exists) {
        currentUserUsername = userSnapshot['username'] ?? '';
        return currentUserUsername;
      }
    }

    return null;
  }

  void sendInvitation(String username) {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot receiverDoc = querySnapshot.docs.first;
        String receiverDeviceToken = receiverDoc['deviceToken'];

        if (currentUserUid.isNotEmpty) {
          _sendNotificationToServer(receiverDeviceToken, 'Invitación',
              'Has recibido una invitación de $currentUserUsername');

          Fluttertoast.showToast(
            msg: 'Invitación enviada a $username',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          FirebaseFirestore.instance
              .collection('users')
              .doc(receiverDoc.id)
              .collection('notifications')
              .add({
            'type': 'invitation',
            'from': currentUserUid,
            'to': receiverDoc.id,
            'titulo': 'Invitación recibida',
            'descripcion':
                'Has recibido una invitación de $currentUserUsername',
            'fecha': FieldValue.serverTimestamp(),
            'read': false,
          });
        } else {
          Fluttertoast.showToast(
            msg: 'error.v'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'error.u'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });
  }

  Future<void> _sendNotificationToServer(
      String receiverUid, String title, String body) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(receiverUid);

      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final deviceToken = userSnapshot['deviceToken'];

        if (deviceToken != null) {
          const url = 'http://154.56.51.64:3000/enviar-notificacion';

          final client = http
              .Client(); // Crea una instancia de IOClient para conexiones HTTPS

          final response = await client.post(
            Uri.parse(url),
            body: {
              'registrationToken': deviceToken,
              'title': title,
              'body': body,
            },
          );

          client.close(); // Cierra la conexión después de usarla

          if (response.statusCode == 200) {
          } else {}
        } else {}
      } else {}
      // ignore: empty_catches
    } catch (error) {}
  }

  Future<List<String>> fetchUserSuggestions(String pattern) async {
    if (pattern.isEmpty) return [];
    List<String> suggestions = [];

    // Realiza la consulta a Firestore usando solo 'pattern'.
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        // ... tus condiciones de consulta ...
        .get();

    // Agrega nombres de usuario a 'suggestions'
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      suggestions.add(docSnapshot['username']);
    }

    return suggestions;
  }

  Future<String?> getUidFromUsername(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1) // Limitar la consulta a un solo resultado
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String uid = querySnapshot.docs[0].id;
      return uid;
    } else {
      return null; // No se encontró el usuario con el username dado
    }
  }

  void removeFriend(String username) async {
    try {
      String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      String? friendUid = await getUidFromUsername(username);

      if (friendUid != null) {
        // Eliminar al amigo de la subcolección "friends" del usuario actual
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .collection('friends')
            .where('username', isEqualTo: username)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Eliminar al usuario actual de la subcolección "friends" del amigo
        await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .collection('friends')
            .where('username', isEqualTo: currentUserUsername)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // Mostrar un mensaje emergente (toast) indicando que el amigo ha sido eliminado
        Fluttertoast.showToast(
          msg: 'send.i'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      } else {
        // Manejar el caso en que no se encuentre el UID del amigo
        Fluttertoast.showToast(
          msg: 'send.ei'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
