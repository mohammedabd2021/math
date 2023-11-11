import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_bloc.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_state.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/error_dialog.dart';
import 'package:mohammedabdnewproject/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgetPassword) {
          if (state.hasSendEmail) {
            _controller.clear();
            await showPasswordResetEmailSentDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(context,
                'We could not process your request,Please make sure you are a registered user,Or if not,go back and register now ');
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
              fit: BoxFit.fill,
            )),
            width: width,
            height: height,
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.1),
              child: Column(
                children: [
                  const Image(
                      image: AssetImage(
                          'assets/images/—Pngtree—golden wonderful lock png_5548675.png'),
                      height: 200),
                  const Text('Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amberAccent,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 40, left: 30, right: 30),
                    child: TextField(
                      cursorColor: Colors.amberAccent,style: const TextStyle(color: Colors.white),
                      controller: _controller,
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
                  ElevatedButton(style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      backgroundColor: Colors.amber,
                      fixedSize: Size(width - 30, 60)),
                      onPressed: () {
                        final email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgetPassword(email: email));
                      },
                      child: const Text('Send me password reset link',textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17))),
                  TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      },
                      child: const Text('Back to login page',style: TextStyle(color: Colors.amberAccent, fontSize: 15)))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
