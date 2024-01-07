import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Notificacion {
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String from;
  final String to;
  final String documentId;

  Notificacion(this.titulo, this.descripcion, this.fecha, this.documentId,
      this.from, this.to);
}

class NotificacionesService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Notificacion>> cargarNotificaciones() async {
    final user = _auth.currentUser;
    List<Notificacion> loadedNotificaciones = [];

    if (user != null) {
      String userId = user.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      loadedNotificaciones = querySnapshot.docs.map((doc) {
        String titulo = doc['titulo'];
        String descripcion = doc['descripcion'];
        String from = doc['from'];
        String to = doc['to'];
        Timestamp fechaTimestamp = doc['fecha'];
        String documentId = doc.id;

        DateTime fecha = fechaTimestamp.toDate();

        return Notificacion(titulo, descripcion, fecha, documentId, from, to);
      }).toList();
    }

    return loadedNotificaciones;
  }

  Future<String?> getUsernameFromUid(String uid) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();

    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      return userData['username'];
    } else {
      return null;
    }
  }

  void aceptarInvitacion(Notificacion notificacion) async {
    // Remover la notificación de la lista
    String senderUid = notificacion.from; // UID del remitente
    String receiverUid = notificacion.to; // UID del receptor

    // Obtén los nombres de usuario a partir de los UIDs
    String? senderUsername = await getUsernameFromUid(senderUid);
    String? receiverUsername = await getUsernameFromUid(receiverUid);

    if (senderUsername != null && receiverUsername != null) {
      // Agregar ambos usuarios a la subcolección "friends" del otro usuario
      await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .collection('friends')
          .add({'username': senderUsername});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderUid)
          .collection('friends')
          .add({'username': receiverUsername});

      // Marcar la notificación como leída y eliminarla
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('notifications')
          .doc(notificacion.documentId)
          .delete();

      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: 'Invitación aceptada',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
    } else {
      // Mostrar mensaje de error si no se encuentran los nombres de usuario
      Fluttertoast.showToast(
        msg: 'Error: No se encontró el nombre de usuario.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void rechazarInvitacion(Notificacion notificacion) async {
    try {
      User? user = FirebaseAuth
          .instance.currentUser; // Obtén el usuario actual (puede ser nulo)

      if (user != null) {
        String userId = user.uid; // Obtiene el ID del usuario actual

        // Elimina la notificación del documento del usuario actual
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .doc(notificacion.documentId)
            .update(
                {'read': true}); // CAMBIO: Marcar la notificación como leída

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('notifications')
            .doc(notificacion.documentId)
            .delete(); // Eliminar la notificación
      } else {
        // CAMBIO: Añadido manejo cuando el usuario no está autenticado
        Fluttertoast.showToast(
          msg: 'Usuario no autenticado',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // CAMBIO: Añadido manejo de excepciones con Fluttertoast
      Fluttertoast.showToast(
        msg: 'Error al eliminar la notificación: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
