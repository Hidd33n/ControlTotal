import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SwitchList extends StatelessWidget {
  SwitchList({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instancia de FirebaseFirestore
  int totalAmount = 0; // Nueva propiedad para almacenar el total de montos
  final TextEditingController counterController = TextEditingController();

  Widget buildAccountList() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('No hay usuario autenticado.'));
    }

    return StreamBuilder(
      stream: _firestore
          .collection('users')
          .doc(user.uid)
          .collection('calculos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'error.t'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'empty.t'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                docs[index].data() as Map<String, dynamic>;

            // Comprobar si el campo 'fecha' existe y no es null antes de convertirlo a DateTime
            // Formateo de la fecha sin segundos
            DateTime? fecha;
            if (data['fecha'] != null) {
              fecha = (data['fecha'] as Timestamp).toDate();
            }
            String fechaFormateada = fecha != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(fecha)
                : 'No disponible';

            return Dismissible(
              key: Key(docs[index].id),
              onDismissed: (direction) {
                // Eliminar el documento deslizado de Firestore
                docs[index].reference.delete();
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(
                  'Monto: ${data['monto_final']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Impuesto: ${data['impuesto_resta']} - Fecha: $fechaFormateada',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: const Icon(Icons.delete),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTeamAccountList() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('No hay usuario autenticado.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .doc('team')
          .collection('calculos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text(
            'error.t'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'empty.t'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ));
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                docs[index].data() as Map<String, dynamic>;

            // Formateo de la fecha sin segundos
            DateTime? fecha;
            if (data['fecha'] != null) {
              fecha = (data['fecha'] as Timestamp).toDate();
            }
            String fechaFormateada = fecha != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(fecha)
                : 'No disponible';

            return Dismissible(
              key: Key(docs[index].id),
              onDismissed: (direction) {
                // Eliminar el documento deslizado de Firestore
                docs[index].reference.delete();
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(
                  'Monto: ${data['monto_final']}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                subtitle: Text(
                  'Impuesto: ${data['impuesto_resta']} - Fecha: $fechaFormateada',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: const Icon(Icons.delete),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAccountList(),
        buildTeamAccountList(),
      ],
    );
  }
}
