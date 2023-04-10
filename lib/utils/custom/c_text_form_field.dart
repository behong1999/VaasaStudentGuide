import 'package:flutter/material.dart';

import 'package:students_guide/utils/custom/c_theme_data.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  String? Function(String?)? validator;
  String? hint;
  String? label;
  bool? obscure;
  double? radius;
  int? maxLines = 1;
  TextInputType? inputType;
  Widget? suffixIcon;
  Widget? prefixIcon;

  CustomTextFormField({
    Key? key,
    required this.controller,
    this.radius,
    this.maxLines,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.obscure,
    this.inputType,
    this.hint,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLight = checkIfLightTheme(context);

    double radius = this.radius ?? 10;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: radius,
            spreadRadius: 0.1,
            offset: const Offset(2, 1),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: mColor,
        keyboardType: inputType,
        maxLines: maxLines ?? 1,
        obscureText: obscure ?? false,
        enableInteractiveSelection: true,
        validator: validator,
        style: TextStyle(color: isLight ? Colors.black38 : Colors.white54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(radius),
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
          hintText: hint,
          // hintStyle: const TextStyle(colo r: Colors.black38),
          labelText: label,
          floatingLabelStyle: TextStyle(
              color: mColor,
              fontWeight: FontWeight.bold,
              backgroundColor: isLight ? lBackgroundColor : dBackgroundColor),
          labelStyle:
              TextStyle(color: isLight ? Colors.black38 : Colors.white54),
          prefixIcon: prefixIcon,
          prefixIconColor: white,
          suffixIcon: suffixIcon,
          suffixIconColor: white,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
