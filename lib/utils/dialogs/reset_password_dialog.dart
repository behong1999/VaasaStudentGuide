import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_guide/services/auth/auth_exception.dart';
import 'package:students_guide/bloc/auth_bloc.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text_form_field.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/dialogs/error_dialog.dart';

showResetPasswordDialog(BuildContext context) {
  final email = TextEditingController();
  final form = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Please enter your email to reset password',
        ),
        content: Form(
          key: form,
          child: CustomTextFormField(
            hint: 'Email',
            prefixIcon: const Icon(
              Icons.email,
              color: Colors.black38,
            ),
            inputType: TextInputType.emailAddress,
            controller: email,
            validator: (value) {
              RegExp regex = RegExp(r'\w+@\w+\.\w+');
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return regex.hasMatch(value) ? null : 'Invalid Email';
            },
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateResetPassword) {
                if (state.exception is AdminNotFoundAuthException) {
                  await showErrorDialog(context, 'This email is invalid!');
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, 'Unknown Error');
                }
                if (state.emailSent) {
                  Future.delayed(
                    const Duration(milliseconds: 1),
                    () {
                      Navigator.of(context).pop();
                      BlocProvider.of<AuthBloc>(context)
                          .add(AuthEventInitialize());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: mColor,
                          content: Text('Please Check Your Email Inbox'),
                        ),
                      );
                    },
                  );
                }
              }
            },
            builder: (context, state) => state.isLoading
                ? const CustomLoadingIcon()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(mColor),
                      foregroundColor: WidgetStateProperty.all<Color>(white),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context)
                            .add(AuthEventResetPassword(email.text));
                      }
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(white),
                backgroundColor: WidgetStateProperty.all<Color>(grey),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ],
      );
    },
  );
}
