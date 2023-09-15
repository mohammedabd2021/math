// ignore_for_file: library_prefixes, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/views/Login_View.dart';
import 'package:mohammedabdnewproject/views/Register_View.dart';
import 'package:mohammedabdnewproject/views/Verify_view.dart';
import 'dart:developer' as Devtool show log;
import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        RegisterRoute: (context) => const RegisterView(),
        LoginRoute: (context) => const LoginView(),
        MainRoute: (context) => const notes_view(),
        VerifyRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                Devtool.log(user.toString());
                return const LoginView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          // return const Text('done.');
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class notes_view extends StatefulWidget {
  const notes_view({Key? key}) : super(key: key);

  @override
  State<notes_view> createState() => notes_viewState();
}

// ignore: constant_identifier_names
enum MenuAction { Logout }

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
                      FirebaseAuth.instance.signOut();
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
