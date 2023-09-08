import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

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
        title: const Text('Login'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Center(
                    child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration:
                          const InputDecoration(hintText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                    ), //email
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(
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
                          final user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(user);
                          print('Login successfully');
                        } on FirebaseAuthException catch (e) {

                          if (e.code == 'unknown') {
                            print('user not found');
                          } else if (e.code == 'wrong-password') {
                            print('The password incorrect');
                          } else if (e.code == 'unknown') {
                            print(
                                'You are in a country banned by our application');
                          }else{print(e.code);}
                        }
                        // catch (e) {
                        //   print('some thing wrong happened');
                        //   print(e);
                        //   print(e.runtimeType);
                        // }
                      },
                      child: const Text('Login'),
                    )
                  ],
                )); // TODO: Handle this case.
              default:
                return Text('loading....');
            }
          }),
    );
  }
}
