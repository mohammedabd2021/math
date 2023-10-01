import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'cancel': false,
      'log out': true,
    },
  ).then((value) => value ?? false);
}
