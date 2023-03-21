import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:students_guide/models/admin_model.dart';
import 'package:students_guide/services/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthRepository repository)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //* initialize
    on<AuthEventInitialize>((event, emit) async {
      await repository.initialize();
      final admin = repository.currentAdmin;
      if (admin == null) {
        emit(const AuthStateSignedOut(exception: null, isLoading: false));
      } else {
        emit(AuthStateSignedIn(admin: admin, isLoading: false));
      }
    });
    //* login
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateSignedOut(exception: null, isLoading: true));
      final email = event.email;
      final password = event.password;
      try {
        final admin = await repository.signIn(email: email, password: password);
        emit(const AuthStateSignedOut(
          exception: null,
          isLoading: false,
        ));
        emit(AuthStateSignedIn(
          admin: admin,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
    //* logout
    on<AuthEventLogout>((event, emit) async {
      try {
        await repository.signOut();
        emit(const AuthStateSignedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateSignedOut(exception: e, isLoading: false));
      }
    });
    //* forget password
    on<AuthEventResetPassword>((event, emit) async {
      emit(const AuthStateResetPassword(
        exception: null,
        emailSent: false,
        isLoading: true,
      ));
      bool emailSent;
      Exception? exception;
      try {
        final email = event.email;
        await repository.resetPassword(email: email);
        emailSent = true;
        exception = null;
      } on Exception catch (e) {
        emailSent = false;
        exception = e;
      }
      emit(AuthStateResetPassword(
        exception: exception,
        emailSent: emailSent,
        isLoading: false,
      ));
    });
  }
}
