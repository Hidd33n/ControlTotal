import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CountServices extends StatefulWidget {
  final String userId;
  final bool isTeamCount;

  CountServices({
    required this.userId,
    required this.isTeamCount,
    Key? key,
  }) : super(key: key);

  @override
  _CountServicesState createState() => _CountServicesState();
}

class _CountServicesState extends State<CountServices> {
  final ValueNotifier<int> totalAmountNotifier = ValueNotifier<int>(0);

  void updateTotalAmount(int newAmount) {
    totalAmountNotifier.value = newAmount;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.isTeamCount
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('friends')
              .doc('team')
              .collection('calculos')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('calculos')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          updateTotalAmount(0); // Mostrar el total inicial
        }

        // Calcular el total sumando los valores de 'monto_final'
        int totalAmount = 0;
        for (var doc in snapshot.data!.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          final montoFinal = data['monto_final'];
          if (montoFinal is int) {
            totalAmount += montoFinal;
          } else if (montoFinal is num) {
            totalAmount += montoFinal.toInt();
          } else {
            print('Warning: data[\'monto_final\'] no es de tipo int o num.');
          }
        }

        updateTotalAmount(totalAmount);

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ValueListenableBuilder<int>(
            valueListenable: totalAmountNotifier,
            builder: (context, totalAmount, _) {
              return Text(
                'Total: $totalAmount',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
