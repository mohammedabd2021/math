import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

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
      appBar: AppBar(title: const Text('signin'),),
      body: Center(
          child: Column(
            children: [
              TextField(
                controller: _email,
                decoration:
                const InputDecoration(hintText: 'Enter your email'),
                keyboardType: TextInputType.emailAddress,
              ),//email
              TextField(
                controller: _password,
                decoration: const InputDecoration(
                    hintText: 'Enter your password'),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),//password
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    final user1 = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                        email: email, password: password);
                    print(user1);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      print('you are already registered');
                    } else if (e.code == 'weak-password') {
                      print('The password is weak');
                    } else if (e.code == 'unknown') {
                      print(
                          'You are in a country banned by our application');
                    } else if (e.code == 'invalid-email') {
                      print('The email is invalid');
                    }
                    ;
                  }
                },
                child: const Text('Register'),
              )
           ,TextButton(onPressed: () {
             Navigator.of(context).pushNamedAndRemoveUntil('/Login/', (route) => false);
           }, child: const Text('already registered? Login here')) ],
          )),
    );
  }
}
