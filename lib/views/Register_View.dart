// ignore_for_file: library_prefixes, non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as Devtools show log;

import 'package:mohammedabdnewproject/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('sign in'),
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
                final user1 = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                Devtools.log(user1.toString());
                final user =await FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
                Navigator.of(context).pushNamed(VerifyRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  await ShowErrorDialog(context, 'you are already registered');
                } else if (e.code == 'weak-password') {
                  await ShowErrorDialog(context, 'This is a weak password');
                } else if (e.code == 'unknown') {
                  await ShowErrorDialog(context,
                      'You are in a country banned by our application');
                } else if (e.code == 'invalid-email') {
                  await ShowErrorDialog(context, 'The email is invalid');
                } else {
                  ShowErrorDialog(context, 'Error : ${e.code}');
                }
              }catch(e){
                ShowErrorDialog(context, e.toString());
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(LoginRoute, (route) => false);
              },
              child: const Text('already registered? Login here'))
        ],
      )),
    );
  }
}

