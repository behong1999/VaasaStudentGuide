import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_text.dart';

class PageViewItem extends StatelessWidget {
  final String title;
  final String content;
  final String image;

  const PageViewItem({
    super.key,
    required this.title,
    required this.content,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image),
        const SizedBox(height: 30),
        CustomText(title, size: 22, fontWeight: FontWeight.w500),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Text(
            content,
            textAlign: TextAlign.justify,
            softWrap: true,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
