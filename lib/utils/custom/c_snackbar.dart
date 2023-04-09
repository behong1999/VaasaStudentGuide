import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

SnackBar customSnackBar({required String content, Duration? duration}) {
  return SnackBar(
    content: Text(content),
    backgroundColor: mColor,
    duration: duration ?? const Duration(milliseconds: 500),
  );
}
