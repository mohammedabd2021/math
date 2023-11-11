import 'package:flutter/cupertino.dart';
import 'package:mohammedabdnewproject/services/auth/auth_user.dart';
@immutable
abstract class AuthProvider{
  Future<void>initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String id,
    required String password
});
  Future<AuthUser> createUser({
    required String id,
    required String password
});
  Future<void> logOut();
  Future<void> sendEmailVerify();
  Future<void> sendPasswordReset({required String toEmail});
}