// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'show ReadContext;
import 'package:mohammedabdnewproject/enums/menu_action.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';
import 'package:mohammedabdnewproject/services/cloud/firebase_cloud_storage.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/logout_dialog.dart';
import 'package:mohammedabdnewproject/views/notes/create_update_note_view.dart';
import 'package:mohammedabdnewproject/views/notes/note_list_view.dart';

import '../../animation/slide_animation.dart';
import '../../constants/routes.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/cloud/cloud_note.dart';

class notes_view extends StatefulWidget {
  const notes_view({Key? key}) : super(key: key);

  @override
  State<notes_view> createState() => notes_viewState();
}

// ignore: constant_identifier_names

class notes_viewState extends State<notes_view> {
  String get userId => AuthServices.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black54,
        title: const Text(
          'Your Notes ',
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,

        actions: [
          PopupMenuButton<MenuAction>(
            icon: const Icon(
              Icons.settings,
              color: Colors.amber,
            ),
            onSelected: (value) async {
              switch (value) {
                case MenuAction.Logout:
                  final logoutShow = await showLogoutDialog(context);
                  if (logoutShow) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );

                    // ignore: use_build_context_synchronously
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.Logout,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.amber,
                      ),
                      Text(' Logout'),
                    ],
                  ),
                )
              ];
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.black12,
        onPressed: () {
          Navigator.push(
            context,
            SlidePageRouteBuilder(
              page: const CreateUpdateNote(),
            ),
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.edit_note_sharp,
          size: 40,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNote = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNote,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createUpdate,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                );
              }
            default:
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              );
          }
        },
      ),
    );
  }
}

// ignore: non_constant_identifier_names
