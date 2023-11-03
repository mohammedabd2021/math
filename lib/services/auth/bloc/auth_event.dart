import 'package:mohammedabdnewproject/services/cloud/cloud_note.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  const AuthEventRegister(this.email,this.password);
}

class AuthEventForgetPassword extends AuthEvent{
  final String? email;

  const AuthEventForgetPassword({this.email});
}
class AuthEventCreatingUpdatingNote extends AuthEvent{
  CloudNote? note;
   AuthEventCreatingUpdatingNote(this.note);
}
class AuthEventShouldRegister extends AuthEvent{
  const AuthEventShouldRegister();
}
class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String passWord;

  const AuthEventLogIn(this.email, this.passWord);
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
