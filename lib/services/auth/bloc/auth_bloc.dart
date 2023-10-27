import 'package:bloc/bloc.dart';
import 'package:mohammedabdnewproject/services/auth/auth_provider.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_event.dart';
import 'package:mohammedabdnewproject/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(
          const AuthStateUninitialized(),
        ) {
    //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerify();
      emit(state);
    });
    //register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final passWord = event.password;
      try {
        await provider.createUser(
          id: email,
          password: passWord,
        );
        await provider.sendEmailVerify();
        emit(
          const AuthStateNeedsVerification(),
        );
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
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
            const AuthStateNeedsVerification(),
          );
        } else {
          emit(
            AuthStateLogin(user),
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
          ),
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
              const AuthStateNeedsVerification(),
            );
          } else {
            emit(
              const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ),
            );
            emit(
              AuthStateLogin(user),
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
  }
}
