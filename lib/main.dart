// ignore_for_file: library_prefixes, camel_case_types

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/views/Login_View.dart';
import 'package:mohammedabdnewproject/views/Register_View.dart';
import 'package:mohammedabdnewproject/views/Verify_view.dart';
import 'package:mohammedabdnewproject/views/main_view.dart';
import 'dart:developer' as Devtool show log;

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
      future:AuthServices.firebase().initialize()      ,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthServices.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
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
