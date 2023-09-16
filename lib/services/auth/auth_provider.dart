import 'package:flutter/cupertino.dart';
import 'package:mohammedabdnewproject/services/auth/auth_user.dart';
@immutable
abstract class AuthProvider{
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
}