import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/services/crud/notes_service.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setUpTextControllerListener() {
    _textController.removeListener(() {
      _textControllerListener();
    });
    _textController.addListener(() {
      _textControllerListener();
    });
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _notesService = NotesService();
    super.initState();
  }

  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

// ignore: non_constant_identifier_names
  Future<DatabaseNotes> CreateNote() async {
    final noteIsExist = _note;
    if (noteIsExist != null) {
      return noteIsExist;
    }
    final currentUser = AuthServices.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNotes(owner: owner);
  }

  void _deleteNoteIFEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfNotEmpty() {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      _notesService.updateNote(note: note, text: text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIFEmpty();
    _saveNoteIfNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          title: const Text('New Note'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: CreateNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as DatabaseNotes;
                _setUpTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  decoration:
                      const InputDecoration(hintText: 'Enter your note'),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
