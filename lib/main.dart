// ignore_for_file: library_prefixes, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/helpers/loading/loading_screen.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_bloc.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_state.dart';
import 'package:mohammedabdnewproject/services/auth/firebase_auth_provider.dart';
import 'package:mohammedabdnewproject/views/auth/login_view.dart';
import 'package:mohammedabdnewproject/views/auth/register_view.dart';
import 'package:mohammedabdnewproject/views/auth/Verify_view.dart';
import 'package:mohammedabdnewproject/views/notes/notes_view.dart';

import 'package:mohammedabdnewproject/views/notes/create_update_note_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {createUpdate: (context) => const CreateUpdateNote()},
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a minute');
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLogin) {
        return const notes_view();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else if (state is AuthStateRegistering) {
        return const RegisterView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
