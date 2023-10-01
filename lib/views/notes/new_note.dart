import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/services/crud/notes_service.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener((_textControllerListener));
    _textEditingController.addListener((_textControllerListener));
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final user = AuthServices.firebase().currentUser!;
    final email = user.email!;
    final owner = await _notesService.getUser(email: email);
    print(email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty()async {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
     await _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && _textEditingController.text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
      // print(text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        title: const Text('New Note', style: TextStyle(color: Colors.amber)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:

              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListener();
              // print(_textEditingController.text);
              return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: 'write your note here :'));

            default:
              return const Center(child: CircularProgressIndicator(color:Colors.amber));
          }
        },
      ),
    );
  }
}
