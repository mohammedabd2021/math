import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/cannot_share_empty_dialog.dart';
import 'package:mohammedabdnewproject/utilities/get_argument.dart';
import 'package:mohammedabdnewproject/services/cloud/cloud_note.dart';
import 'package:mohammedabdnewproject/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNote extends StatefulWidget {
  const CreateUpdateNote({super.key});

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textEditingController;
  late final TextEditingController _titleEditingController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    _titleEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    final title = _titleEditingController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
      title: title,
    );
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener((_textControllerListener));
    _textEditingController.addListener((_textControllerListener));
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      _titleEditingController.text = widgetNote.title;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final user = AuthServices.firebase().currentUser!;
    final userId = user.id; // print(email);
    final newNote = await _notesService.createNewNote(ownerUserId: userId);

    _note = newNote; // --------------------- problem here
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textEditingController.text.isEmpty &&
        note != null &&
        _titleEditingController.text.isEmpty) {
      await _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    final title = _titleEditingController.text;
    if (note != null &&
        _textEditingController.text.isNotEmpty &&
        _titleEditingController.text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
        title: title,
      );
      // print(text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    _titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textEditingController.text;
              final title = _titleEditingController.text;
              if (_note == null || (text.isEmpty && title.isEmpty)) {
                await showCanNotShareEmptyDialog(context);
              } else {
                Share.share('{$title    $text}');
              }
            },
            icon: const Icon(Icons.share_outlined, color: Colors.amber),
          )
        ],
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        title: const Text('New Note', style: TextStyle(color: Colors.amber)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              // print(_textEditingController.text);
              return Column(
                children: [TextField(
                  cursorColor: Colors.amber,
                  controller: _titleEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.amber,fontWeight: FontWeight.bold,),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.amber)),
                      hintText: 'Title')),
                  TextField(
                      cursorColor: Colors.amber,
                      controller: _textEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.amber),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber)),
                          hintText: '      write your note here :')),
                ],
              );

            default:
              return const Center(
                  child: CircularProgressIndicator(color: Colors.amber));
          }
        },
      ),
    );
  }
}
