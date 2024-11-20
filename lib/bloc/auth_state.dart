part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  final bool isLoading;

  const AuthState({
    required this.isLoading,
  });

  @override
  List<Object> get props => [isLoading];
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateSignedIn extends AuthState {
  final AdminModel admin;

  const AuthStateSignedIn({
    required this.admin,
    required isLoading,
  }) : super(isLoading: isLoading);

  @override
  List<Object> get props => [admin, isLoading];
}

class AuthStateSignedOut extends AuthState {
  final Exception? exception;

  const AuthStateSignedOut({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateResetPassword extends AuthState {
  final Exception? exception;
  final bool emailSent;
  const AuthStateResetPassword({
    required this.exception,
    required this.emailSent,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}
