// ignore_for_file: library_prefixes, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
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
      routes: {
        RegisterRoute: (context) => const RegisterView(),
        LoginRoute: (context) => const LoginView(),
        MainRoute: (context) => const notes_view(),
        VerifyRoute: (context) => const VerifyEmailView(),
        createUpdate: (context) => const CreateUpdateNote()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLogin) {
        return const notes_view();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailView();
      } else if (state is AuthStateLoggedOut) {
        return const LoginView();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
      }
}
