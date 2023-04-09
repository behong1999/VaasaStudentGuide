import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';

class DetailsContainer extends StatelessWidget {
  const DetailsContainer({
    super.key,
    this.title,
    required this.content,
    this.style,
  });
  final String? title;
  final String content;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null && title!.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: CustomText(
              title.toString(),
              size: style?.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: checkIfLightTheme(context) ? white : gray,
          child: Text(content.toString(), style: style),
        )
      ],
    );
  }
}
