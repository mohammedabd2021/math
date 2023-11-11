// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/images/wallpapertip_black-pattern-wallpaper_118104.jpg'),
                    fit: BoxFit.fill)),
            width: width,
            height: height,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.1),
              child: Column(
                children: [
                  const Image(
                      image: AssetImage('assets/images/tmp-654d81f413539.png'),
                      height: 170),
                  const Text('Welcome back',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('Login to continue',
                      style: TextStyle(color: Colors.amberAccent)),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 30, right: 30),
                    child: TextField(style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.amberAccent,
                      controller: _email,
                      decoration: const InputDecoration(
                          suffix:
                              Icon(Icons.email_outlined, color: Colors.amber),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70)),
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: Colors.amberAccent),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          hintText: 'Enter email address',
                          hintStyle: TextStyle(color: Colors.white70)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  //email
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 30, right: 30),
                    child: TextField(style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.amberAccent,
                      controller: _password,
                      decoration: const InputDecoration(
                          suffix: Icon(Icons.password_outlined,
                              color: Colors.amber),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70)),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.amberAccent),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amberAccent),
                          ),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.white70)),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(const AuthEventForgetPassword());
                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.amberAccent),
                      )),
                  //password
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        backgroundColor: Colors.amber,
                        fixedSize: Size(width - 30, 60)),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldRegister(),
                          );
                    },
                    child: const Text(
                      textAlign: TextAlign.end,
                      'Do not have an account? sign up now',
                      style: TextStyle(color: Colors.amber),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
