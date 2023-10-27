import 'package:flutter/foundation.dart' show immutable;

import '../auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLogin extends AuthState {
  final AuthUser user;

  const AuthStateLogin(this.user);
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering(this.exception);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  final bool isLoading;

  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception,isLoading];
}
