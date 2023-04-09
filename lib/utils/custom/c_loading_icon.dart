import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

class CustomLoadingIcon extends StatelessWidget {
  const CustomLoadingIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: mColor));
  }
}
