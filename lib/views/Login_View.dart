// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: library_prefixes
import 'dart:developer' as Devtools show log;

import 'package:mohammedabdnewproject/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Login'),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
          ), //email
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ), //password
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                // ignore: await_only_futures
                final user = await FirebaseAuth.instance.currentUser;
                if ((user != null) && (user.emailVerified)) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(MainRoute, (route) => false);
                  Devtools.log('Login successfully');
                } else {
                  ShowErrorDialog(context, "your email aren't verify");
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await ShowErrorDialog(context, 'The user not found');
                } else if (e.code == 'wrong-password') {
                  await ShowErrorDialog(context, 'The password is wrong');
                } else if (e.code == 'unknown') {
                  await ShowErrorDialog(context,
                      'You are in a country banned by our application');
                } else {
                  ShowErrorDialog(context, 'Error : ${e.code}');
                }
              } catch (e) {
                ShowErrorDialog(context, e.toString());
              }
              // catch (e) {
              //   print('some thing wrong happened');
              //   print(e);
              //   print(e.runtimeType);
              // }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RegisterRoute,
                  (route) => false,
                );
              },
              child: const Text('not Register yet? click here'))
        ],
      )),
    );
  }
}
