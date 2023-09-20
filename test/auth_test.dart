// // ignore_for_file: must_be_immutable
//
// import 'dart:math';
//
// import 'package:mohammedabdnewproject/services/auth/auth_exceptions.dart';
// import 'package:mohammedabdnewproject/services/auth/auth_provider.dart';
// import 'package:mohammedabdnewproject/services/auth/auth_user.dart';
// import 'package:test/test.dart';
//
// void main() {
//   group('Mock Authentication', () {
//     final provider = MockAuthProvider();
//     test('should not be initialized to begin with', () {
//       expect(provider.isInitialized, false);
//     });
//
//     test('con not logout if not initialized', () {
//       expect(provider.logOut(),
//           throwsA(const TypeMatcher<NotInitializedException>()));
//     });
//     test('should be abel to initialize', () async {
//       await provider.initialize();
//     });
//     expect(provider.isInitialized, true);
//     test('user should be null', () {
//       expect(provider.currentUser, null);
//     });
//     test('the initialize should be less than 2 seconds', () async {
//       await provider.initialize();
//       expect(provider.isInitialized, true);
//     }, timeout: const Timeout(Duration(seconds: 2)));
//     test('Create user should delegate to login function', () async {
//       final badEmailUser =
//           provider.createUser(id: "foo@bar.com", password: 'any-password');
//       expect(badEmailUser,
//           throwsA(const TypeMatcher<UserNotFoundAuthException>()));
//       final badPasswordUser =
//           provider.createUser(id: 'any-id', password: 'foobar');
//       expect(badPasswordUser,
//           throwsA(const TypeMatcher<WrongPasswordAuthException>()));
//       final user = await provider.createUser(id: 'foo', password: 'bar');
//       expect(provider.currentUser, user);
//       expect(user.isEmailVerified, false);
//     });
//     test('logged user should be abel to get verified', () {
//       provider.sendEmailVerify();
//       final user = provider.currentUser;
//       expect(user, isNotNull);
//       expect(user!.isEmailVerified, true);
//     });
//     test('user can be abel to log out and log in again', () async {
//       await provider.logOut();
//       await provider.logIn(id: 'id', password: 'password');
//       final user = provider.currentUser;
//       expect(user, isNotNull);
//     });
//   });
// }
//
// class NotInitializedException implements Exception {}
//
// class MockAuthProvider implements AuthProvider {
//   var _isInitialized = false;
//   AuthUser? _user;
//
//   bool get isInitialized => _isInitialized;
//
//   @override
//   Future<AuthUser> createUser({
//     required String id,
//     required String password,
//   }) async {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     await Future.delayed(const Duration(seconds: 1));
//     return logIn(id: id, password: password);
//   }
//
//   @override
//   AuthUser? get currentUser => _user;
//
//   @override
//   Future<void> initialize() async {
//     await Future.delayed(const Duration(seconds: 1));
//     _isInitialized = true;
//   }
//
//   @override
//   Future<AuthUser> logIn({required String id, required String password}) {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     if (id == "foo@bar.com") {
//       throw UserNotFoundAuthException();
//     }
//     if (password == "foobar") {
//       throw WrongPasswordAuthException();
//     }
//     const user = AuthUser(isEmailVerified: false);
//     _user = user;
//     return Future.value(user);
//   }
//
//   @override
//   Future<void> logOut() async {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     if (_user == null) {
//       throw UserNotFoundAuthException();
//     }
//     await Future.delayed(const Duration(seconds: 1));
//     _user = null;
//   }
//
//   @override
//   Future<void> sendEmailVerify() async {
//     if (!isInitialized) {
//       throw NotInitializedException();
//     }
//     final user = _user;
//     if (user == null) {
//       throw UserNotFoundAuthException();
//     }
//
//     const newUser = AuthUser(isEmailVerified: true);
//     _user = newUser;
//   }
// }
