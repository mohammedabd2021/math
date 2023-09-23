// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/enums/menu_action.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/services/crud/notes_service.dart';

class notes_view extends StatefulWidget {
  const notes_view({Key? key}) : super(key: key);

  @override
  State<notes_view> createState() => notes_viewState();
}

// ignore: constant_identifier_names

class notes_viewState extends State<notes_view> {
  late final NotesService _notesService;

  String get userEmail => AuthServices.firebase().currentUser!.email!;

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
          title: const Text('Your Notes '),
          centerTitle: true,
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.Logout:
                    final logoutShow = await ShowDialogLogout(context);
                    if (logoutShow) {
                      await AuthServices.firebase().logOut();
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(LoginRoute, (_) => false);
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.Logout,
                    child: Row(
                      children: const [
                        Icon(Icons.logout_rounded),
                        Text(' Logout'),
                      ],
                    ),
                  )
                ];
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {Navigator.of(context).pushNamed(notesView);},
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
            child: const Icon(
              Icons. edit_note_sharp,
              size: 60,
              color: Colors.white,
            )),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('waiting for all notes');
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                );

              default:
                return const Center(child: CircularProgressIndicator());
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
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Logout'))
          ],
          title: const Text('Logout'),
          content: const Text('are you sure you want to  sign out?'),
        );
      }).then((value) => value ?? false);
}
