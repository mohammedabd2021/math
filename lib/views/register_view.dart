// ignore_for_file: library_prefixes, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:developer' as Devtools show log;

import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/views/login_view.dart';

import '../services/auth/auth_exceptions.dart';
import '../utilities/show_error_dialog.dart';
import 'Verify_view.dart';

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
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(50),
        )),
        title: const Text('sign in'),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            cursorColor: Colors.amber,
            controller: _email,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter your email'),
            keyboardType: TextInputType.emailAddress,
          ), //email
          TextField(
            cursorColor: Colors.amber,
            controller: _password,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                hintText: 'Enter your password'),
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
                await AuthServices.firebase().sendEmailVerify();
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return const VerifyEmailView();
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
            child:
                const Text(style: TextStyle(color: Colors.amber), 'Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
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
              },
              child: const Text(
                style: TextStyle(color: Colors.amber),
                'already registered? Login here',
              ))
        ],
      )),
    );
  }
}
