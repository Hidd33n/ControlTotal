import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ErrorCases {
  static void handleLoginError(BuildContext context, dynamic e) {
    if (e is FirebaseAuthException) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "user-not-found".tr();
          break;
        case 'wrong-password':
          errorMessage = "wrong-password".tr();
          break;
        case 'invalid-email':
          errorMessage = "invalid-email".tr();
          break;
        case 'user-disabled':
          errorMessage = "user-disabled".tr();
          break;
        case 'too-many-requests':
          errorMessage = "too-many-requests".tr();
          break;
        case 'operation-not-allowed':
          errorMessage = "operation-not-allowed".tr();
          break;
        case 'empty-fields':
          errorMessage = "empty-fields";
          break;
        default:
          errorMessage = "login_error".tr();
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
    if (e is FirebaseAuthException) {
      String errorMessage;

      switch (e.code) {
        case 'weak-password':
          errorMessage = "weak-password".tr();
          break;
        case 'email-already-in-use':
          errorMessage = "email-already-in-use".tr();
          break;
        case 'invalid-email':
          errorMessage = "invalid-email".tr();
          break;
        case 'empty-fields':
          errorMessage = "empty-fields".tr();
          break;
        default:
          errorMessage = "registration_error".tr();
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
