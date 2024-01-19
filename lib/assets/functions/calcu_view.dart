import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CalculateDialog extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const CalculateDialog({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  _CalculateDialogState createState() => _CalculateDialogState();
}

class _CalculateDialogState extends State<CalculateDialog> {
  String dropdownValue = 'Efectivo';
  double calculatedAmount = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _saveToDifferentLocation = false;
  final List<String> paymentTypes = [
    'Efectivo',
    'Transferencia',
    '3 Cuotas',
    '6 Cuotas',
    'Personalizado'
  ];
  void dispose() {
    super.dispose();
  }

  void calculateAndSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double amount = double.tryParse(widget.controller.text) ?? 0.0;
    double feePercentage = 0.0;
    double feeAmount = 0.0;

    switch (dropdownValue) {
      case 'Efectivo':
        feePercentage = prefs.getDouble('cash') ?? 0.1;
        break;
      case 'Transferencia':
        feePercentage = prefs.getDouble('transfer') ?? 0.05;
        break;
      case '3 Cuotas':
        feePercentage = prefs.getDouble('three_payments_credit') ?? 0.184;
        break;
      case '6 Cuotas':
        feePercentage = prefs.getDouble('six_payments') ?? 0.2285;
        break;
      case 'Personalizado':
        feePercentage = prefs.getDouble('one_payment_credit') ?? 0.1;
        break;
    }

    feeAmount = amount * feePercentage;
    calculatedAmount = amount - feeAmount;

    User? user = _auth.currentUser;
    if (user != null) {
      Map<String, dynamic> calculationData = {
        'monto_final': calculatedAmount,
        'impuesto_resta': feeAmount,
        'fecha': FieldValue.serverTimestamp(),
      };

      if (_saveToDifferentLocation) {
        // Guardar en la colección de equipo del usuario actual
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('friends')
            .doc('team')
            .collection('calculos')
            .add(calculationData);

        // Obtener la lista de amigos (nombres de usuario)
        QuerySnapshot friendsSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('friends')
            .get();

        for (DocumentSnapshot friendDoc in friendsSnapshot.docs) {
          String friendUsername =
              friendDoc['username']; // Obtén el nombre de usuario del amigo

          // Obtener el UID del amigo a partir del nombre de usuario
          QuerySnapshot userSnapshot = await _firestore
              .collection('users')
              .where('username', isEqualTo: friendUsername)
              .limit(1)
              .get();

          if (userSnapshot.docs.isNotEmpty) {
            String friendUid = userSnapshot.docs.first.id;

            // Guardar el cálculo en la colección del amigo
            await _firestore
                .collection('users')
                .doc(friendUid)
                .collection('friends')
                .doc('team')
                .collection('calculos')
                .add(calculationData);
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Datos guardados en equipo con éxito')),
          );
        }
      } else {
        // Guardar en la ubicación habitual (individual)
        CollectionReference individualCalculationsRef =
            _firestore.collection('users').doc(user.uid).collection('calculos');

        await individualCalculationsRef.add(calculationData);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Guardado con exito",
          ),
        );
      }
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context)
          .colorScheme
          .shadow, // Hace el fondo del AlertDialog transparente
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: Theme.of(context).colorScheme.primary,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "m.team".tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Switch(
                    inactiveThumbColor: Colors.red,
                    activeColor: Colors.green,
                    value: _saveToDifferentLocation,
                    onChanged: (bool value) {
                      setState(() {
                        _saveToDifferentLocation = value;
                      });
                    },
                  ),
                ],
              ),
              TextField(
                style: Theme.of(context).textTheme.bodyLarge,
                controller: widget.controller,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'cv'.tr(),
                    hintStyle: Theme.of(context).textTheme.bodyLarge),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                style: Theme.of(context).textTheme.bodyLarge,
                focusColor: Theme.of(context).colorScheme.onPrimary,
                dropdownColor: Theme.of(context).colorScheme.primary,
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items:
                    paymentTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'pm'.tr(),
                    labelStyle: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.shadow,
                      ),
                      onPressed: calculateAndSave,
                      child: Text(
                        "calculate".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundColor:
                              Theme.of(context).colorScheme.shadow),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "cancel.bu".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
