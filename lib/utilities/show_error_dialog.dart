// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
Future<void> ShowErrorDialog(
    BuildContext context,
    String text,
    ) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An error'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('OK'))
        ],
        content: Text(text),
      );
    },
  );
}
