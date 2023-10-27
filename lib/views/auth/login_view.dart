// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/loading_dialog.dart';

// ignore: library_prefixes

import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle =
                showLoadingDialog(context: context, text: 'Loading ...');
          }
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found !');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
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
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text(
                  'not Register yet? click here',
                  style: TextStyle(color: Colors.amber),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
