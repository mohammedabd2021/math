import 'package:flutter/material.dart';

typedef DialogOptionalBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionalBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title,style: const TextStyle(color: Colors.amber),),
          backgroundColor: Colors.white,
          content: Text(content,style: const TextStyle(color: Colors.amberAccent)),
          actions: options.keys.map((optionTitle) {
            final T value = options[optionTitle];
            return TextButton(
                onPressed: () {
                  if (value != null) {
                    Navigator.of(context).pop(value);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(optionTitle,
                    style: const TextStyle(color: Colors.amber)));
          }).toList(),
        );
      });
}
