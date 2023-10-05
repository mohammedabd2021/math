import 'package:mohammedabdnewproject/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCanNotShareEmptyDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You can not share an empty dialog',
    optionsBuilder: () => {'OK': null},
  );
}
