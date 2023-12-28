import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Esta función maneja el cierre de sesión
  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Muestra el SnackBar después de un cierre de sesión exitoso.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sesión cerrada con éxito')),
      );
      // No es necesario redirigir al usuario a la página de autenticación aquí
      // El StreamBuilder en NavigationScreen se encargará de esto
    } catch (e) {
      // Si ocurre un error, muestra un SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text('fix taxs'.tr()),
              onTap: () => _taxessettings(context),
            ),
            context.locale.languageCode == 'en'
                ? ListTile(
                    leading: const Icon(Icons.abc_sharp),
                    title: Text('es'.tr()),
                    onTap: () async =>
                        await (context.setLocale(Locale('es', 'ES'))),
                  )
                : ListTile(
                    leading: const Icon(Icons.abc_sharp),
                    title: Text('en'.tr()),
                    onTap: () async =>
                        await (context.setLocale(Locale('en', 'US'))),
                  ),
            ListTile(
              leading: const Icon(Icons.dangerous),
              title: Text('cooming soon'.tr()),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('logout'.tr()),
              onTap: () => _confirmSignOut(context),
            ),
            // Agrega más ListTiles aquí para otros ajustes si es necesario
          ],
        ).toList(),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    // Muestra un diálogo de confirmación al usuario
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Cierra el diálogo
              _signOut(context); // Cierra sesión
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _taxessettings(BuildContext context) async {
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

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajustar Tasas'),
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
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Guardar'),
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
                              'Por favor ingrese un número válido para ${entry.key}')),
                    );
                    break;
                  }
                }
                if (allValid) {
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
