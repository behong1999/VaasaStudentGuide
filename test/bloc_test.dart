import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:students_guide/models/admin_model.dart';
import 'package:students_guide/services/auth/auth_exception.dart';
import 'package:students_guide/services/auth/auth_repository.dart';
import 'package:students_guide/bloc/auth_bloc.dart';
import 'package:students_guide/cubit/theme_cubit.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';

const _testEmail = "test@gmail.com";
const _testPassword = "123";

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<AdminModel> signIn({required String email, required String password}) {
    if (email == _testEmail && password == _testPassword) {
      return Future.delayed(
        const Duration(milliseconds: 0),
        () => AdminModel(
          id: "any",
          email: email,
        ),
      );
    } else if (email != _testEmail) {
      throw AdminNotFoundAuthException();
    } else if (password != _testPassword) {
      throw WrongPasswordAuthException();
    }
    throw GenericAuthException();
  }

  @override
  Future signOut() {
    return Future.delayed(const Duration(milliseconds: 0), () => null);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    if (!email.validateEmail()) {
      throw InvalidEmailAuthException();
    } else if (email != _testEmail) {
      throw AdminNotFoundAuthException();
    }
    await Future.delayed(const Duration(milliseconds: 0));
  }
}

void main() {
  group('ThemeCubit', () {
    late ThemeCubit themeCubit;

    setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

    setUp(() {
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test(
      'emits [ThemeState(system)] as initial theme state',
      () => expect(
          ThemeCubit().state, const ThemeState(themeMode: ThemeMode.system)),
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits the corresponding ThemeState when setTheme is called',
      build: () => themeCubit,
      act: (cubit) => cubit.setTheme(ThemeMode.dark.index),
      expect: () => [
        const ThemeState(themeMode: ThemeMode.dark),
      ],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits the saved ThemeState when getTheme is called',
      build: () => themeCubit,
      act: (cubit) {
        cubit.setTheme(1);
        themeCubit.close();
        ThemeCubit().getTheme();
      },
      expect: () => [
        const ThemeState(themeMode: ThemeMode.light),
      ],
    );
  });

  group('AuthBloc', () {
    late MockAuthRepository authRepository;
    late AuthBloc authBloc;

    setUp(() {
      authRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository);
    });

    setUpAll(() => TestWidgetsFlutterBinding.ensureInitialized());

    tearDown(() {
      authBloc.close();
    });

    test(
        'emits [AuthStateUninitialized] when the app starts',
        () => expect(authBloc.state,
            equals(const AuthStateUninitialized(isLoading: true))));

    blocTest<AuthBloc, AuthState>(
      'emits [AuthStateSignedIn] when AuthEventLogin is added and authentication is successful',
      build: () => authBloc,
      act: (bloc) {
        bloc.add(const AuthEventLogin(_testEmail, _testPassword));
      },
      expect: () => [
        isA<AuthStateSignedOut>()
            .having((state) => state.isLoading, 'isLoading', isTrue)
            .having((state) => state.exception, 'exception', isNull),
        isA<AuthStateSignedOut>()
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.exception, 'exception', isNull),
        isA<AuthStateSignedIn>()
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.admin.email, 'email', _testEmail),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      '''emits [AuthStateSignedOut] when AuthEventLogin is added 
      and authentication failed due to wrong password''',
      build: () => authBloc,
      act: (bloc) {
        bloc.add(const AuthEventLogin(_testEmail, "456"));
      },
      expect: () => [
        const AuthStateSignedOut(exception: null, isLoading: true),
        AuthStateSignedOut(
            exception: WrongPasswordAuthException(), isLoading: false)
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthStateSignedOut] when AuthEventLogout is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthEventLogout()),
      expect: () =>
          [const AuthStateSignedOut(exception: null, isLoading: false)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthStateResetPassword] when AuthEventResetPassword is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthEventResetPassword(_testEmail)),
      expect: () => [
        const AuthStateResetPassword(
            exception: null, isLoading: true, emailSent: false),
        const AuthStateResetPassword(
            exception: null, emailSent: true, isLoading: false)
      ],
    );

    blocTest<AuthBloc, AuthState>(
      '''emits [AuthStateResetPassword] having AdminNotFoundAuthException
       when AuthEventResetPassword is added but the mail is not found''',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthEventResetPassword("test1@gmail.com")),
      expect: () => [
        isA<AuthStateResetPassword>()
            .having((state) => state.isLoading, 'isLoading', isTrue)
            .having((state) => state.emailSent, 'isEmailSent', isFalse)
            .having((state) => state.exception, 'exception', isNull),
        isA<AuthStateResetPassword>()
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.emailSent, 'isEmailSent', isFalse)
            .having((state) => state.exception, 'exception',
                isA<AdminNotFoundAuthException>()),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      '''emits [AuthStateResetPassword] having InvalidEmailAuthException 
      when AuthEventResetPassword is added but invalid Email''',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthEventResetPassword("test.com")),
      expect: () => [
        isA<AuthStateResetPassword>()
            .having((state) => state.isLoading, 'isLoading', isTrue)
            .having((state) => state.emailSent, 'isEmailSent', isFalse)
            .having((state) => state.exception, 'exception', isNull),
        isA<AuthStateResetPassword>()
            .having((state) => state.isLoading, 'isLoading', isFalse)
            .having((state) => state.emailSent, 'isEmailSent', isFalse)
            .having((state) => state.exception, 'exception',
                isA<InvalidEmailAuthException>()),
      ],
    );
  });
}
