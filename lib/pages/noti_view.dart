import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Notificacion {
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String from;
  final String to;
  final String documentId; // Agrega el campo documentId

  Notificacion(this.titulo, this.descripcion, this.fecha, this.documentId,
      this.from, this.to);
}

class NotifyView extends StatefulWidget {
  const NotifyView({Key? key}) : super(key: key);

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  List<Notificacion> notificaciones = []; // Agrega la lista de notificaciones

  @override
  void initState() {
    super.initState();
    cargarNotificaciones();
  }

  Future<void> cargarNotificaciones() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      List<Notificacion> loadedNotificaciones = [];
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        String titulo = docSnapshot['titulo'];
        String descripcion = docSnapshot['descripcion'];
        String from = docSnapshot['from'];
        String to = docSnapshot['to'];
        Timestamp fechaTimestamp = docSnapshot['fecha']; // Use Timestamp type
        String documentId = docSnapshot.id;

        DateTime fecha =
            fechaTimestamp.toDate(); // Convert Timestamp to DateTime

        Notificacion notificacion =
            Notificacion(titulo, descripcion, fecha, documentId, from, to);
        loadedNotificaciones.add(notificacion);
      }
      if (mounted) {
        setState(() {
          notificaciones = loadedNotificaciones;
        });
      }
    }
  }

  void aceptarInvitacion(Notificacion notificacion) async {
    // Remover la notificación de la lista
    setState(() {
      notificaciones.remove(notificacion);
    });

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

  Future<String?> getUsernameFromUid(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      // Realiza un cast explícito a Map<String, dynamic>
      var userData = userDoc.data() as Map<String, dynamic>;
      return userData[
          'username']; // Asegúrate de que 'username' es el nombre correcto del campo
    } else {
      return null;
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

        setState(() {
          notificaciones.remove(notificacion);
        });
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

  void mostrarMenuNotificaciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: notificaciones.isEmpty
              ? Text('No hay notificaciones disponibles.')
              : SingleChildScrollView(
                  child: Column(
                    children: notificaciones
                        .map((notificacion) => LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: constraints
                                      .maxWidth, // Asegura que no desborde horizontalmente
                                  child: ListTile(
                                    title: Text(notificacion.titulo),
                                    subtitle: Text(notificacion.descripcion),
                                    trailing: Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            aceptarInvitacion(notificacion);
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            rechazarInvitacion(notificacion);
                                          },
                                          child: Text('Rechazar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notificaciones.isEmpty
          ? const Center(
              child: Text(
                'No tienes notificaciones',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                Notificacion notificacion = notificaciones[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            notificacion.titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${notificacion.descripcion}\n${DateFormat('dd-MM-yyyy HH:mm').format(notificacion.fecha)}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  aceptarInvitacion(notificacion);
                                },
                                child: Text('Aceptar'),
                              ),
                              SizedBox(width: 16),
                              TextButton(
                                onPressed: () {
                                  rechazarInvitacion(notificacion);
                                },
                                child: Text('Rechazar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
