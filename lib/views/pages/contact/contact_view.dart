import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_guide/services/email/send_email.dart';
import 'package:students_guide/services/theme/cubit/theme_cubit.dart';

import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_elevated_button.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_text_form_field.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/custom/word_limit_text_formatter.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';
import 'package:students_guide/utils/no_glow_scroll_behavior.dart';
import 'package:students_guide/views/widgets/drawer.dart';

class ContactView extends StatefulWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  int wordCounts = 0;
  final name = TextEditingController();
  final email = TextEditingController();
  final message = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final wordLimit = 800;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final isLoggedIn = BlocProvider.of<AuthBloc>(context).state is AuthStateSignedIn;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(),
          drawer: const DrawerMenu(isLoggedIn: false),
          body: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const CustomText(
                        'Get In Touch',
                        size: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 25),
                      CustomTextFormField(
                        controller: name,
                        hint: 'Your name',
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: email,
                        inputType: TextInputType.emailAddress,
                        hint: 'Email Address',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email in order to reply';
                          }
                          return value.validateEmail()
                              ? null
                              : 'Invalid email!';
                        },
                      ),
                      const SizedBox(height: 20),
                      MessageTextField(
                        wordLimit: wordLimit,
                        message: message,
                        onChanged: (value) => setState(
                          () {
                            wordCounts = value.countWords();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${message.text == '' ? 0 : wordCounts}/$wordLimit Words')),
                      isLoading
                          ? const CustomLoadingIcon()
                          : CustomElevatedButton(
                              text: 'Send',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await sendEmail(
                                      name: name.text,
                                      email: email.text,
                                      content: message.text);
                                  setState(() {
                                    isLoading = false;
                                    name.clear();
                                    email.clear();
                                    message.clear();
                                  });
                                  Future.delayed(
                                    const Duration(milliseconds: 50),
                                    () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor: mColor,
                                          content: Text('Message Sent!'),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                      const SizedBox(height: 50),
                      const CustomText(
                        'Contact Me',
                        size: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 20),
                      const ContactRow(
                          icon: Icons.call, content: '+358 (0) 41 369 5757'),
                      const SizedBox(height: 20),
                      const ContactRow(
                          icon: Icons.mail, content: 'khonhong46632@gmail.com'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    Key? key,
    required this.wordLimit,
    required this.message,
    required this.onChanged,
  }) : super(key: key);

  final int wordLimit;
  final TextEditingController message;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    bool isLight = checkIfLightTheme(context);
    double radius = 10;
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.1,
            offset: Offset(2, 1),
          ),
        ],
      ),
      child: TextFormField(
          maxLines: 10,
          inputFormatters: [WordLimitTextInputFormatter(wordLimit)],
          controller: message,
          style: TextStyle(color: isLight ? Colors.black38 : Colors.white54),
          decoration: InputDecoration(
            hintText: 'Enter your message here',
            contentPadding: const EdgeInsets.all(10),
            filled: true,
            fillColor: isLight ? white : gray,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: mColor),
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Cannot send an empty message';
            }
            return null;
          },
          onChanged: onChanged),
    );
  }
}

class ContactRow extends StatelessWidget {
  final String content;
  final IconData icon;
  const ContactRow({
    super.key,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: MediaQuery.of(context).size.width * 0.15),
      Icon(icon),
      const SizedBox(width: 10),
      Text(
        content,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ]);
  }
}
