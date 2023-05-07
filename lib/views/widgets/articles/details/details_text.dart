import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';

class DetailsText extends StatelessWidget {
  final String title;
  final String? content;
  final TextStyle? style;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const DetailsText({
    Key? key,
    required this.title,
    this.content,
    this.style,
    this.onTap,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: content != null && content!.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: title.countWords() > 1
                        ? title
                        : '${title.toCamelCase()}: ',
                    style: style?.copyWith(
                        color: mColor, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: content,
                      style: style,
                      recognizer: TapGestureRecognizer()..onTap = onTap),
                ]),
                textDirection: TextDirection.ltr,
              ),
            ),
            suffixIcon ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
