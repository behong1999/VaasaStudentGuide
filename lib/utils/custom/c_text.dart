import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  const CustomText(
    this.text, {
    super.key,
    this.size,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: mColor,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
