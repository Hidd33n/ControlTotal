import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomSDialog extends StatelessWidget {
  final Function onConfirm;
  const CustomSDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('cdelete'.tr(), style: Theme.of(context).textTheme.bodyLarge),
      content:
          Text('cdeletesub'.tr(), style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('cancel.bu'.tr(),
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child:
              Text('delete'.tr(), style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
