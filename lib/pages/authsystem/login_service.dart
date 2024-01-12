import 'package:calcu/assets/ui/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginService {
  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    // Verifica si los campos están vacíos para evitar el inicio de sesión automático
    if (email.trim().isEmpty || password.trim().isEmpty) {
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Obtener el token de dispositivo actualizado
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      // Actualizar el token en la base de datos si el usuario está autenticado
      if (FirebaseAuth.instance.currentUser != null) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'deviceToken': deviceToken,
        });

        // Navegar a la nueva página después de iniciar sesión
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException (puedes imprimir e.code y e.message para depurar)
      print('Error during sign in: ${e.code} - ${e.message}');
    } catch (e) {
      // Handle otros tipos de errores
      print('Error during sign in: $e');
    }
  }
}
