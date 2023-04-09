import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

class StarCard extends StatefulWidget {
  const StarCard({
    Key? key,
    required this.articleModel,
  }) : super(key: key);

  final ArticleModel articleModel;

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
    final title = widget.articleModel.title.toString();
    final id = widget.articleModel.documentId.toString();
    final address = widget.articleModel.address.toString();
    final email = widget.articleModel.email.toString();
    final date = DateFormat('dd/MM/yyyy').format(widget.articleModel.date);

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _starsService.deleteStar(id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      child: Card(
          child: ListTile(
        onTap: () async {
          await AutoRouter.of(context).push(ArticleDetailsRoute(
            article: article,
            isStarred: true,
            isLoggedIn: false,
          )) as bool;
        },
        title: CustomText(title),
        subtitle: AutoSizeText(
            address.isNotEmpty ? address : (email.isNotEmpty ? email : date)),
      )),
    );
  }
}
