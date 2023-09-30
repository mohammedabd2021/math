// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/views/register_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(50),
        )),
        title: const Text('Verify email'),
      ),
      body: Column(children: [
        const Text(
          "We've send to you an email verification "
          ", Please press on the link that in the email.",
        ),
        const Text("If you haven't receive any email yet "
            ", press the button below"),
        TextButton(
            onPressed: () async {
              await AuthServices.firebase().sendEmailVerify();
            },
            child: const Text('send email verification ')),
        TextButton(
            onPressed: () async {
              await AuthServices.firebase().logOut();
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
            child: const Text('Restart'))
      ]),
    );
  }
}
