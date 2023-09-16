// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/enums/menu_action.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
class notes_view extends StatefulWidget {
  const notes_view({Key? key}) : super(key: key);

  @override
  State<notes_view> createState() => notes_viewState();
}

// ignore: constant_identifier_names

class notes_viewState extends State<notes_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
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
        body: const Text('Welcome to syria'));
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
