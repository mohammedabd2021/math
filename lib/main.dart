import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mohammedabdnewproject/views/Login_View.dart';
import 'package:mohammedabdnewproject/views/Register_View.dart';

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
      home: HomePage(),
      routes: {
        "/Register/": (context) => RegisterView(),
        "/Login/": (context) => LoginView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          // final user = FirebaseAuth.instance.currentUser;
          // print(user);
          // if (user?.emailVerified ?? false) {
          //   return Center(child: const Text('done'));
          // } else {
          //   return VerifyEmailView();
          // }

            


            return const LoginView();
          default:
            return Center(child: const Text('Loading...'));
        }
      },
    );
  }
}
