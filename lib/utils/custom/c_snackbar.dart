import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

SnackBar customSnackBar({required String content, Duration? duration}) {
  return SnackBar(
    content: Text(
      content,
      style: const TextStyle(color: white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: mColor,
    duration: duration ?? const Duration(milliseconds: 500),
  );
}
