import 'package:calcu/core/functions/count_services.dart';
import 'package:calcu/core/utils/switch_d_dialog.dart';
import 'package:calcu/data/sources/team_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamList extends StatelessWidget {
  TeamList({Key? key}) : super(key: key);
  final TeamData _teamData = TeamData();

  @override
  Widget build(BuildContext context) {
    User? user = _teamData.getCurrentUser();

    return StreamBuilder<List<DocumentSnapshot>>(
      stream: _teamData.teamCalculosStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'error.t'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        List<DocumentSnapshot> docs = snapshot.data ?? [];

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: docs.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      docs[index].data() as Map<String, dynamic>;

                  DateTime? fecha;
                  if (data['fecha'] != null) {
                    fecha = (data['fecha'] as Timestamp).toDate();
                  }
                  String fechaFormateada = fecha != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(fecha)
                      : 'No disponible';

                  return ListTile(
                    title: Text(
                      'Monto: ${data['monto_final']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      'Impuesto: ${data['impuesto_resta']} - Fecha: $fechaFormateada',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomSDialog(
                              onConfirm: () {
                                docs[index].reference.delete();
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: CountServices(userId: user?.uid ?? "", isTeamCount: true),
            ),
          ],
        );
      },
    );
  }
}
