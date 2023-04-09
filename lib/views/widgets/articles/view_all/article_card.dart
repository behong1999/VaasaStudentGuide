import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/articles/cloud_service.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/dialogs/delete_dialog.dart';
import 'package:students_guide/utils/routes/router.gr.dart';
import 'package:students_guide/views/widgets/articles/stars/star_button.dart';

class ArticleCard extends StatefulWidget {
  final bool isLoggedIn;
  final ArticleModel articleModel;
  const ArticleCard({
    Key? key,
    required this.isLoggedIn,
    required this.articleModel,
  }) : super(key: key);

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  late final StarsService _starsService;
  late final CloudService _cloudService;
  bool isStarred = false;

  @override
  void initState() {
    _starsService = StarsService();
    _cloudService = CloudService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = widget.isLoggedIn;
    final article = widget.articleModel;
    final title = article.title.toString();
    final id = article.documentId.toString();
    final address = article.address.toString();
    final email = article.email.toString();
    final date = DateFormat('dd/MM/yyyy').format(article.date);

    return Card(
      child: ListTile(
        onTap: () async {
          bool isChanged =
              await AutoRouter.of(context).push(ArticleDetailsRoute(
            article: article,
            isStarred: isStarred,
            isLoggedIn: isLoggedIn,
          )) as bool;

          if (isChanged == true) {
            setState(() {});
          }
        },
        title: CustomText(title, fontWeight: FontWeight.bold),
        subtitle: AutoSizeText(
            address.isNotEmpty ? address : (email.isNotEmpty ? email : date)),
        trailing: widget.isLoggedIn
            ? Wrap(
                children: [
                  IconButton(
                      onPressed: () {
                        AutoRouter.of(context)
                            .push(AddEditRoute(article: article));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () async {
                        bool delete = await showDeleteDialog(context);
                        if (delete) _cloudService.deleteArticle(id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              )
            : StreamBuilder<bool>(
                stream: _starsService.checkStar(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return StarButton(
                      isStarred: false,
                      onPressed: () {},
                    );
                  } else {
                    isStarred = snapshot.data ?? false;
                    return StarButton(
                      isStarred: isStarred,
                      onPressed: () => setState(() {
                        isStarred = !isStarred;
                        if (isStarred) {
                          _starsService.addStar(article);
                        } else {
                          _starsService.deleteStar(id);
                        }
                      }),
                    );
                  }
                }),
      ),
    );
  }
}
