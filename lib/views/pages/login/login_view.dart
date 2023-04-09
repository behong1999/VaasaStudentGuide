import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:students_guide/gen/assets.gen.dart';
import 'package:students_guide/services/auth/auth_exception.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_elevated_button.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_text_form_field.dart';
import 'package:students_guide/utils/dialogs/error_dialog.dart';
import 'package:students_guide/utils/dialogs/reset_password_dialog.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isVisible = true;
  final email = TextEditingController();
  final password = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 35,
              right: 35,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.images.icon.path,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                const SizedBox(height: 22),
                const CustomText(
                  'Admin Login',
                  size: 24,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 22),
                CustomTextFormField(
                  controller: email,
                  inputType: TextInputType.emailAddress,
                  hint: 'Email',
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black38,
                  ),
                  validator: (value) {
                    RegExp regex = RegExp(r'\w+@\w+\.\w+');
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return regex.hasMatch(value) ? null : 'Invalid email!';
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: password,
                  obscure: _isVisible,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black38,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black38,
                    ),
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                  ),
                  hint: 'Password',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                ),
                TextButton(
                  child: const CustomText(
                    'Forget Password?',
                    size: 18,
                  ),
                  onPressed: () async {
                    await showResetPasswordDialog(context);
                  },
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state is AuthStateSignedOut) {
                      if (state.exception is AdminNotFoundAuthException ||
                          state.exception is WrongPasswordAuthException) {
                        await showErrorDialog(
                            context, 'Invalid Email or Password');
                      } else if (state.exception is GenericAuthException) {
                        await showErrorDialog(context, 'Unknown Error');
                      }
                    }
                    if (state is AuthStateSignedIn) {
                      Future.delayed(const Duration(milliseconds: 1),
                          () => context.pushRoute(const HomeRoute()));
                    }
                  },
                  builder: (context, state) {
                    return state.isLoading
                        ? const CustomLoadingIcon()
                        : CustomElevatedButton(
                            onPressed: () async {
                              if (_form.currentState!.validate()) {
                                context.read<AuthBloc>().add(AuthEventLogin(
                                    email.text.trim(), password.text));
                              }
                            },
                            text: 'Login');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
