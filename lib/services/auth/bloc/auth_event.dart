import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String passWord;

  const AuthEventLogIn(this.email, this.passWord);
}
class AuthEventLogOut extends AuthEvent{
  const AuthEventLogOut();
}
