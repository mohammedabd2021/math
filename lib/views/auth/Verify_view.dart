// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';

import '../../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
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
            padding: EdgeInsets.only(top: height * 0.2),
            child: Column(children: [
              Image(
                image: const AssetImage('assets/images/4.png'),
                height: height * 0.2,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 30, right: 30),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "We've send to you an email verification "
                    ", Please press on the link that in the email.",
                    style: TextStyle(color: Colors.amber, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 70, left: 30, right: 30),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    "If you haven't receive any email yet "
                    ", press the button below",
                    style: TextStyle(color: Colors.amber, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  backgroundColor: Colors.amber,
                  fixedSize: Size(width - 130, 50)),
                  onPressed: () async {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventSendEmailVerification());
                  },
                  child: const Text('send email verification ',
                      style: TextStyle(color: Colors.white, fontSize: 20))),TextButton(onPressed: () {
                context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
              },
                child: const Text(
                  textAlign: TextAlign.end,
                  'Do you need to login again? click here',
                  style: TextStyle(color: Colors.amber),
                ),)
            ]),
          ),
        ),
      ),
    );
  }
}
