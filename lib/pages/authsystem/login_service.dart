import 'package:calcu/assets/widgets/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'error_cases.dart'; // Importa la clase ErrorCases

class LoginService {
  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    // Verifica si los campos están vacíos para evitar el inicio de sesión automático
    if (email.trim().isEmpty || password.trim().isEmpty) {
      // Llama al método de manejo de errores de inicio de sesión desde ErrorCases
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Los campos tienen que estar llenos",
        ),
      );
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
      // Llama al método de manejo de errores de inicio de sesión desde ErrorCases
      // ignore: use_build_context_synchronously
      ErrorCases.handleLoginError(context, e);
    }
  }
}
