import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_text.dart';

class StarCard extends StatefulWidget {
  const StarCard({
    super.key,
    required this.articleModel,
    required this.onTap,
  });

  final ArticleModel articleModel;
  final VoidCallback onTap;

  @override
  State<StarCard> createState() => StarCardState();
}

class StarCardState extends State<StarCard> {
  late final StarsService _starsService;

  @override
  initState() {
    _starsService = StarsService();
    super.initState();
  }

  @override
  void dispose() {
    _starsService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.articleModel;
    final title = article.title.toString();
    final address = article.address.toString();
    final email = article.email.toString();
    final date = DateFormat('dd/MM/yyyy').format(article.date);

    return Card(
      child: ListTile(
        onTap: widget.onTap,
        title: CustomText(title),
        subtitle: AutoSizeText(
            address.isNotEmpty ? address : (email.isNotEmpty ? email : date)),
      ),
    );
  }
}
