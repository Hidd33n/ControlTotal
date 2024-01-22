import 'package:calcu/assets/widgets/nav.dart';
import 'package:calcu/pages/authsystem/error_cases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController cmpasswordController,
  ) async {
    if (!passwordConfirmed(passwordController, cmpasswordController)) {
      Fluttertoast.showToast(msg: 'r.error1'.tr());
      return;
    }

    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        cmpasswordController.text.trim().isEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Los campos tienen que estar llenos",
        ),
      );
      return;
    }

    try {
      // Registrar al usuario en Firebase Authentication
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Obtener el token de dispositivo
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      // Guardar datos en Firestore
      await _firestore.collection('users').doc(newUser.user!.uid).set({
        'username': usernameController.text,
        'deviceToken': deviceToken,
        // Otros datos de usuario...
      });

      // Actualizar el nombre de usuario después de guardar en Firestore
      await newUser.user!.updateDisplayName(usernameController.text);

      Fluttertoast.showToast(msg: 'Usuario registrado exitosamente');

      // Navegar a la nueva página después del registro exitoso
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NavigationScreen()),
      );
    } catch (e) {
      // Handle registration error
      ErrorCases.handleRegisterError(context, e);
    }
  }

  // Confirmar contraseña
  bool passwordConfirmed(
    TextEditingController passwordController,
    TextEditingController cmpasswordController,
  ) {
    return passwordController.text.trim() == cmpasswordController.text.trim();
  }
}
