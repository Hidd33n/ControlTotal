import 'package:calcu/pages/models/calculo.dart';
import 'package:calcu/pages/services/firebase_service.dart';
import 'package:calcu/pages/ui/calcu_view.dart';
import 'package:calcu/services/calculations_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instancia de FirebaseFirestore
  String _username = ''; // Variable para almacenar el nombre de usuario
  bool _showFriendsCalculations = false;

  late final Stream<List<Calculo>> streamCalculos;
  late final User? user;

  @override
  void initState() {
    // Cargar el nombre de usuario cuando el estado se inicialice
    _loadUsername();
    user = _auth.currentUser;
    if (user != null) {
      streamCalculos = FirebaseService().obtenerCalculos(user!.uid);
    }
    super.initState();
  }

  Future<void> _loadUsername() async {
    User? user = _auth.currentUser; // Obtener el usuario actual
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
        // Verificar si el State está montado antes de llamar a setState()
        setState(() {
          _username =
              userDoc.get('username'); // Actualizar el nombre de usuario
        });
      }
    }
  }

  void calculate() {
    showDialog(
        context: context,
        builder: ((context) {
          return CalculateDialog(
            controller: _controller,
            onSave: () {},
            onCancel: () => Navigator.of(context).pop(),
          );
        }));
  }

  void eliminarCalculoParaTodos(String documentoId) async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Obtener el 'username' del usuario actual
      var userDoc = await _firestore.collection('users').doc(user.uid).get();
      var username = userDoc['username'];

      // Eliminar en la colección del usuario actual
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .doc('team')
          .collection('calculos')
          .doc(documentoId)
          .delete();

      // Obtener la lista de amigos del usuario actual
      var friendsSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friends')
          .get();

      if (friendsSnapshot.docs.isNotEmpty) {
        for (var friendDoc in friendsSnapshot.docs) {
          // Obtener el 'uid' de cada amigo
          var friendUid = friendDoc.id;

          // Eliminar en la colección de cálculos de cada amigo
          await _firestore
              .collection('users')
              .doc(friendUid)
              .collection('friends')
              .doc('team')
              .collection('calculos')
              .doc(documentoId)
              .delete();
        }
      }
    }
  }

  Widget _buildAccountList() {
    if (user == null) {
      return const Center(child: Text('No hay usuario autenticado.'));
    }

    return StreamBuilder(
      stream: streamCalculos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(
            child: Text(
              'Error al cargar los calculos',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No hay cuentas que cargar :c',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        }

        List<Calculo> calculosLista = snapshot.data!;
        return ListView.builder(
          itemCount: calculosLista.length,
          itemBuilder: (context, index) {
            final calculo = calculosLista[index];

            // Comprobar si el campo 'fecha' existe y no es null antes de convertirlo a DateTime
            // Formateo de la fecha sin segundos
            DateTime? fecha;
            if (calculo.fecha != null) {
              // fecha = (calculo.fecha as Timestamp).toDate();
            }
            String fechaFormateada = fecha != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(fecha)
                : 'No disponible';

            return Dismissible(
              key: Key(calculo.id),
              onDismissed: (direction) {
                // Eliminar el documento deslizado de Firestore
                // calculos[index]..delete();
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text('Monto: ${calculo.montoFinal}'),
                subtitle: Text(
                    'Impuesto: ${calculo.impuestoResta} - Fecha: $fechaFormateada'),
                trailing: const Icon(Icons.delete),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTeamAccountList() {
    User? user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('No hay usuario autenticado.'));
    }

    return StreamBuilder<List<Calculo>>(
      stream: streamCalculos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text(
            'Error al cargar los cálculos',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
            'No hay cálculos que cargar',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ));
        }

        List<Calculo> calculosLista = snapshot.data!;
        return ListView.builder(
          itemCount: calculosLista.length,
          itemBuilder: (context, index) {
            final calculo = calculosLista[index];

            // Comprobar si el campo 'fecha' existe y no es null antes de convertirlo a DateTime
            // Formateo de la fecha sin segundos
            final fecha = DateFormat('dd/MM/yyyy').format(calculo.fecha);
            //  if (calculo.fecha != null) {
            //  fecha = (calculo.fecha as Timestamp).toDate();
            //    }
            //  String fechaFormateada = fecha != null
            //    ? DateFormat('yyyy-MM-dd HH:mm').format(fecha)
            //  : 'No disponible';

            return Dismissible(
              key: Key(calculo.id),
              onDismissed: (direction) {
                // Eliminar el documento deslizado de Firestore
                // calculos[index]..delete();
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text('Monto: ${calculo.montoFinal}'),
                subtitle:
                    Text('Impuesto: ${calculo.impuestoResta} - Fecha: $fecha'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido $_username',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFriendsCalculations ? Icons.group : Icons.person,
                color: Colors.black),
            onPressed: () {
              setState(() {
                _showFriendsCalculations = !_showFriendsCalculations;
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: calculate,
        elevation: 0,
        backgroundColor: Colors.black87,
        label: const Text('Calcular'),
        icon: const Icon(Icons.calculate),
      ),
      body: _showFriendsCalculations
          ? _buildTeamAccountList()
          : _buildAccountList(),
    );
  }
}
