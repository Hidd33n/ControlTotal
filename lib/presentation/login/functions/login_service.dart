import 'package:calcu/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/auth/error_cases.dart';

class LoginService {
  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      if (email.trim().isEmpty || password.trim().isEmpty) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Los campos tienen que estar llenos",
          ),
        );
        return;
      }

      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (authResult.user != null) {
        String userId = authResult.user!.uid;

        // Obtener el token de dispositivo actualizado
        String? deviceToken = await FirebaseMessaging.instance.getToken();

        // Actualizar el token en la base de datos si el usuario está autenticado
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'deviceToken': deviceToken,
        });

        // Navegar a la nueva página después de iniciar sesión
        await fetchUserProfile(userId);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ErrorCases.handleLoginError(context, e);
    } catch (e) {
      // Manejar otros errores
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    try {
      // Obtener la información del usuario cuando inicia sesión
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        String profileImageUrl = userSnapshot['profileImageUrl'];
        // Usa profileImageUrl para mostrar la imagen en tu interfaz de usuario
      }
    } catch (error) {
      // Manejar errores
    }
  }
}
