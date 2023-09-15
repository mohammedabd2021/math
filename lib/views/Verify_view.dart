// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';

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
        title: const Text('Verify email'),
      ),
      body: Column(children: [
        const Text(
            "We've send to you an email verification , Please press on the link that in the email."),
        const Text(
            "If you haven't receive any email yet , press the button below"),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('send email verification ')),
      TextButton(onPressed: ()async {
        await FirebaseAuth.instance.signOut();
       Navigator.of(context).pushNamedAndRemoveUntil(RegisterRoute, (route) => false);
      }, child: const Text('Restart'))]),
    );
  }
}
