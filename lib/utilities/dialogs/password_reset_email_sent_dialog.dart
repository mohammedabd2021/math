import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    content:
        'We have now sent to you a password reset link ,Please check your email for more information',
    context: context,
    optionsBuilder: () => {'OK': null},
    title: 'Password Reset',
  );
}
