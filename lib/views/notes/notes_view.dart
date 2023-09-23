import 'package:flutter/material.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            )),
      title: const Text('New Note'),
      centerTitle: true,
    ),body: const Text('writing a new note ...'));
  }
}
