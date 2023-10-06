// ignore_for_file: library_prefixes, camel_case_types

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammedabdnewproject/constants/routes.dart';
import 'package:mohammedabdnewproject/services/auth/auth_services.dart';
import 'package:mohammedabdnewproject/views/auth/login_view.dart';
import 'package:mohammedabdnewproject/views/auth/register_view.dart';
import 'package:mohammedabdnewproject/views/auth/Verify_view.dart';
import 'package:mohammedabdnewproject/views/notes/notes_view.dart';
import 'dart:developer' as Devtool show log;

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
      home: const HomePage(),
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('testing Bloc'),
          ),
          body: BlocConsumer<CounterBloc, CounterState>(
              listener: (context, state) {
            _controller.clear();
          }, builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(
              children: [
                Text('Current value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('Invalid input $invalidValue'),
                ),
                TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        hintText: 'Enter your number here '),
                    keyboardType: TextInputType.number),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              DecrementEvent(_controller.text),
                            );
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              IncrementEvent(_controller.text),
                            );
                      },
                      child: const Text('+'),
                    ),
                  ],
                )
              ],
            );
          })),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;

  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(
          CounterStateValid(state.value + integer),
        );
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(
          CounterStateValid(state.value - integer),
        );
      }
    });
  }
}
