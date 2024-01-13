import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ErrorCases {
  // Método estático para que pueda ser utilizado sin instanciar la clase
  static void handleLoginError(BuildContext context, dynamic e) {
    // Muestra mensajes de error específicos según el tipo de error
    if (e is FirebaseAuthException) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "Usuario no encontrado";
          break;
        case 'wrong-password':
          errorMessage = "Contraseña incorrecta";
          break;
        // Agrega más casos según tus necesidades
        case 'invalid-email':
          errorMessage = "Correo electrónico no válido";
          break;
        case 'user-disabled':
          errorMessage = "La cuenta de usuario está deshabilitada";
          break;
        case 'too-many-requests':
          errorMessage = "Demasiados intentos fallidos. Inténtelo más tarde.";
          break;
        case 'operation-not-allowed':
          errorMessage = "Operación no permitida. Comuníquese con el soporte.";
          break;
        case 'empty-fields':
          errorMessage = "Rellena los campos.";
          break;
        default:
          errorMessage = "Error durante el inicio de sesión";
      }

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: errorMessage,
        ),
      );
    }
  }

  static void handleRegisterError(BuildContext context, dynamic e) {
    // Muestra mensajes de error específicos según el tipo de error
    if (e is FirebaseAuthException) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage =
              "La contraseña es débil. Debe tener al menos 6 caracteres.";
          break;
        case 'email-already-in-use':
          errorMessage = "La dirección de correo electrónico ya está en uso.";
          break;
        case 'invalid-email':
          errorMessage = "Correo electrónico no válido.";
          break;
        case 'empty-fields':
          errorMessage = "Rellena todos los campos.";
          break;
        // Agrega más casos según tus necesidades
        default:
          errorMessage = "Error durante el registro.";
      }

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: errorMessage,
        ),
      );
    }
  }
}
