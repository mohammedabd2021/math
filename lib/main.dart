// ignore_for_file: library_prefixes, camel_case_types

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/views/auth/login_view.dart';
import 'package:mohammedabdnewproject/views/auth/register_view.dart';
import 'package:mohammedabdnewproject/views/auth/Verify_view.dart';
import 'package:mohammedabdnewproject/views/notes/notes_view.dart';
import 'dart:developer' as Devtool show log;

import 'package:mohammedabdnewproject/views/notes/create_update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        createUpdate :(context) => const CreateUpdateNote()

      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:AuthServices.firebase().initialize()      ,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // case ConnectionState.waiting:
          //   return  const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                Devtool.log(user.toString());
                return const notes_view();
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
