import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InvitationDialog extends StatelessWidget {
  final String suggestion;
  final void Function() onCancel;
  final void Function() onAccept;

  const InvitationDialog({
    required this.suggestion,
    required this.onCancel,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'send.bu'.tr(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Text(
        '¿Quieres enviar una invitación a $suggestion?',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onCancel,
          child: Text(
            'cancel.bu'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: onAccept,
          child: Text(
            'accept.bu'.tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
