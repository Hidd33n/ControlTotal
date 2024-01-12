import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Muestra el SnackBar después de un cierre de sesión exitoso.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada con éxito')),
      );
      // No es necesario redirigir al usuario a la página de autenticación aquí
      // El StreamBuilder en NavigationScreen se encargará de esto
    } catch (e) {
      // Si ocurre un error, muestra un SnackBar.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  Future<void> confirmSignOut(BuildContext context) async {
    // Muestra un diálogo de confirmación al usuario
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero, // Elimina el margen del contenido
        backgroundColor: Colors
            .transparent, // Hace que el fondo del AlertDialog sea transparente
        content: Container(
          color: Colors.black, // Establece el color de fondo negro
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Cerrar sesión',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '¿Estás seguro de que quieres cerrar sesión?',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Cierra el diálogo
                      signOut(context); // Cierra sesión
                    },
                    child: Text(
                      'Cerrar sesión',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        color: Colors.white,
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

  Future<void> taxessettings(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convertir las tasas decimales a porcentajes enteros para la visualización
    Map<String, double> fees = {
      'Personalizado': (prefs.getDouble('one_payment_credit') ?? 0.078) * 100,
      'Efectivo': (prefs.getDouble('cash') ?? 0.0) * 100,
      '6 cuotas': (prefs.getDouble('six_payments') ?? 0.2285) * 100,
      '3 cuotas': (prefs.getDouble('three_payments_credit') ?? 0.184) * 100,
      'Transferencia': (prefs.getDouble('transfer') ?? 0.05) * 100,
    };

    // Crear controladores de texto para cada campo
    Map<String, TextEditingController> controllers = {
      for (var entry in fees.entries)
        entry.key: TextEditingController(
            text: entry.value.toInt().toString()) // Muestra como entero
    };

    // ignore: use_build_context_synchronously
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ajustar Tasas',
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontFamily: 'poppins', fontWeight: FontWeight.w400),
                color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                for (var entry in controllers.entries)
                  TextField(
                    controller: entry.value,
                    decoration:
                        InputDecoration(labelText: 'Tasa ${entry.key} (%)'),
                    keyboardType:
                        TextInputType.number, // Acepta sólo números enteros
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontFamily: 'poppins', fontWeight: FontWeight.w400),
                    color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Guardar',
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontFamily: 'poppins', fontWeight: FontWeight.w400),
                    color: Colors.white),
              ),
              onPressed: () async {
                bool allValid = true;
                for (var entry in controllers.entries) {
                  final newFee = int.tryParse(entry.value.text);
                  if (newFee != null) {
                    // Guarda el valor como decimal después de convertirlo de porcentaje entero
                    await prefs.setDouble(entry.key, newFee / 100);
                  } else {
                    allValid = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                        'Por favor ingrese un número válido para ${entry.key}',
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400),
                            color: Colors.white),
                      )),
                    );
                    break;
                  }
                }
                if (allValid) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
