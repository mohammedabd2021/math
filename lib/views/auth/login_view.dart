// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: library_prefixes

import 'package:mohammedabdnewproject/views/auth/register_view.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';
import '../../utilities/dialogs/error_dialog.dart';

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
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(50),
        )),
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.amber),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            cursorColor: Colors.amber,
            controller: _email,
            decoration: const InputDecoration(
                labelStyle: TextStyle(color: Colors.amber),
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
                context.read<AuthBloc>().add(AuthEventLogIn(email, password));
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'The user not found');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'The password is wrong');
              } on GenericAuthException {
                showErrorDialog(context, 'Authentication error!');
              }

              // catch (e) {
              //   print('some thing wrong happened');
              //   print(e);
              //   print(e.runtimeType);
              // }
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.amber),
            ),
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
                        return const RegisterView();
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
                'not Register yet? click here',
                style: TextStyle(color: Colors.amber),
              ))
        ],
      )),
    );
  }
}
