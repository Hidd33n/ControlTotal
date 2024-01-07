import 'package:calcu/pages/ui/calcu_view.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showCalculateDialog(
      BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return CalculateDialog(
          controller: controller,
          onSave: () {},
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
