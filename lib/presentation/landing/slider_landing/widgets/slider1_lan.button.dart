import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanButton extends StatelessWidget {
  final VoidCallback LanChange;

  const LanButton({super.key, required this.LanChange});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: LanChange,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Column(
        children: [
          Icon(
            Icons.language,
            size: 40,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          const SizedBox(height: 8),
          Text(
            context.locale.languageCode == 'en' ? 'es'.tr() : 'en'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
