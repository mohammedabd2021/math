// ignore_for_file: library_prefixes, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:developer' as Devtools show log;

import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';

import '../services/auth/auth_exceptions.dart';
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
                final user1 = await AuthServices.firebase()
                    .createUser(id: email, password: password);
                Devtools.log(user1.toString());
              await  AuthServices.firebase().sendEmailVerify();
                Navigator.of(context).pushNamed(VerifyRoute);
              } on EmailIsAlreadyInUseAuthException {
                await ShowErrorDialog(context, 'you are already registered');
              } on WeakPasswordAuthException {
                await ShowErrorDialog(context, 'This is a weak password');
              } on InvalidEmailAuthException {
                await ShowErrorDialog(context, 'The email is invalid');
              } on GenericAuthException {
                ShowErrorDialog(context, 'Authentication error!');
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
