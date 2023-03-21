import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

class CustomTextFormField extends StatelessWidget {
  @override
  String? Function(String?)? validator;
  final TextEditingController textController;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? obscureText;
  TextInputType? textInputType;
  String? hintText;

  CustomTextFormField({
    Key? key,
    this.validator,
    required this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.hintText,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.1,
            offset: Offset(2, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: textController,
        cursorColor: mColor,
        keyboardType: textInputType,
        obscureText: obscureText ?? false,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: mColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black38),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
