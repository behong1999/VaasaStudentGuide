import 'package:flutter/material.dart';

import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';

class ArticleDetailsPage extends StatelessWidget {
  final ArticleModel article;
  const ArticleDetailsPage({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
    );
  }
}
