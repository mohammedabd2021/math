// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/enums/menu_action.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/services/crud/notes_service.dart';
import 'package:mohammedabdnewproject/views/login_view.dart';
import 'package:mohammedabdnewproject/views/notes/new_note.dart';

class notes_view extends StatefulWidget {
  const notes_view({Key? key}) : super(key: key);

  @override
  State<notes_view> createState() => notes_viewState();
}

// ignore: constant_identifier_names

class notes_viewState extends State<notes_view> {
  String get userEmail => AuthServices.firebase().currentUser!.email!;
  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
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
                    final logoutShow = await ShowDialogLogout(context);
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
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
                    return const NewNote();
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
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          child: const Icon(
            Icons.edit_note_sharp,
            size: 60,
            color: Colors.amber,
          ),
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (
                    context,
                    snapshot,
                  ) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.amber),
                        );
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

// ignore: non_constant_identifier_names
Future<bool> ShowDialogLogout(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.amber),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.amber),
                ))
          ],
          title: const Text('Logout'),
          content: const Text('are you sure you want to  sign out?'),
        );
      }).then((value) => value ?? false);
}
