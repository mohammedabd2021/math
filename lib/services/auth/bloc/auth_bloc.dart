
import 'package:bloc/bloc.dart';
import 'package:mohammedabdnewproject/services/auth/auth_provider.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(isLoading: true),
        ) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerify();
      emit(state);
    });
    //register
    on<AuthEventRegister>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while i sign you up'),
      );
      final email = event.email;
      final passWord = event.password;
      try {
        await provider.createUser(
          id: email,
          password: passWord,
        );
        await provider.sendEmailVerify();
        emit(
          const AuthStateNeedsVerification(isLoading: false),
        );
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    //initialize
    on<AuthEventInitialize>(
          (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(
            const AuthStateNeedsVerification(isLoading: false),
          );
        } else {
          emit(
            AuthStateLogin(
              user: user,
              isLoading: false,
            ),
          );
        }
      },
    );
    //login
    on<AuthEventLogIn>(
          (event, emit) async {
        emit(
          const AuthStateLoggedOut(
              exception: null,
              isLoading: true,
              loadingText: 'Please wait while i log you in'),
        );
        final email = event.email;
        final passWord = event.passWord;
        try {
          final user = await provider.logIn(
            id: email,
            password: passWord,
          );
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              const AuthStateNeedsVerification(isLoading: false),
            );
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              AuthStateLogin(user: user, isLoading: false),
            );
          }
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(
              exception: e,
              isLoading: false,
            ),
          );
        }
      },
    );
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });
    on<AuthEventForgetPassword>((event,emit)async{
    emit(const AuthStateForgetPassword(exception: null, hasSendEmail: false, isLoading: false));
    final email=event.email;
    if(email==null){
      return;
    }
    emit(const AuthStateForgetPassword(exception: null, hasSendEmail: false, isLoading: true));
    bool didSendEmail;
    Exception? exception;
    try{provider.sendPasswordReset(toEmail: email);
    didSendEmail = true;
    exception = null;
    }
        on Exception catch(e){
      didSendEmail = false;
      exception = e;
        }
emit(AuthStateForgetPassword(exception: exception, hasSendEmail: didSendEmail, isLoading: false));
    });
  }}