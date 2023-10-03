// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/enums/menu_action.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/services/cloud/firebase_cloud_storage.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/logout_dialog.dart';
import 'package:mohammedabdnewproject/views/auth/login_view.dart';
import 'package:mohammedabdnewproject/views/notes/create_update_note_view.dart';
import 'package:mohammedabdnewproject/views/notes/note_list_view.dart';

import '../../constants/routes.dart';
import '../../services/cloud/cloud_Note.dart';

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
        appBar: AppBar(
          title: const Text(
            'Your Notes ',
            style: TextStyle(color: Colors.amber),
          ),
          centerTitle: true,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          actions: [
            PopupMenuButton<MenuAction>(
              icon: const Icon(
                Icons.swipe_vertical_outlined,
                color: Colors.amber,
              ),
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.Logout:
                    final logoutShow = await showLogoutDialog(context);
                    if (logoutShow) {
                      await AuthServices.firebase().logOut();

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) {
                              return const LoginView();
                            },
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ));
                    }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.Logout,
                    child: Row(
                      children: [
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
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return const CreateUpdateNote();
                  },
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ));
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
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
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
                      ));
                }
              default:
                return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
            }
          },
        ));
  }
}

// ignore: non_constant_identifier_names
