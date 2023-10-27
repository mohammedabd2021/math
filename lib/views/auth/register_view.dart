// ignore_for_file: library_prefixes, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../../utilities/dialogs/error_dialog.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailIsAlreadyInUseAuthException) {
            await showErrorDialog(context, 'This Email is already in use!');
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'This is a weak password');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'An authentication error happened!');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(50),
          )),
          title: const Text(
            'sign in',
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
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    hintText: 'Enter your email'),
                keyboardType: TextInputType.emailAddress,
              ), //email
              TextField(
                cursorColor: Colors.amber,
                controller: _password,
                decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    hintText: 'Enter your password'),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ), //password
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventRegister(email, password),
                      );
                },
                child: const Text(
                    style: TextStyle(color: Colors.amber), 'Register'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text(
                  style: TextStyle(color: Colors.amber),
                  'already registered? Login here',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
