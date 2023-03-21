part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEventInitialize extends AuthEvent {}

class AuthEventLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthEventLogout extends AuthEvent {}

class AuthEventResetPassword extends AuthEvent {
  final String email;

  const AuthEventResetPassword(this.email);

  @override
  List<Object> get props => [email];
}
