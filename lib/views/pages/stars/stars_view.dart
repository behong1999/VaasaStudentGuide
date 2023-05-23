import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/articles/cloud_service.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_elevated_button.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/routes/router.gr.dart';
import 'package:students_guide/views/widgets/articles/stars/star_card.dart';
import 'package:students_guide/utils/custom/c_search_bar.dart';
import 'package:students_guide/views/widgets/drawer.dart';

final StarsService _starsService = StarsService();
final CloudService _cloudService = CloudService();

class StarsView extends StatefulWidget {
  const StarsView({Key? key}) : super(key: key);

  @override
  State<StarsView> createState() => _StarsViewState();
}

class _StarsViewState extends State<StarsView> {
  late final TextEditingController _search;
  late final Stream<Iterable<ArticleModel>> stream;
  late final StreamSubscription<Iterable<ArticleModel>> subscription;
  Iterable<ArticleModel> results = [];
  String keyword = '';

  streamListener() {
    subscription = stream.listen((_) => _starsService.updateStars(stream));
  }

  @override
  initState() {
    _search = TextEditingController();
    _starsService.init();
    stream = _cloudService.getAllArticles();
    streamListener();
    super.initState();
  }

  @override
  dispose() {
    _search.dispose();
    // _starsService.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  _starsService.getStars();
                  setState(() {});
                },
                icon: const Icon(Icons.refresh, color: mColor)),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Center(
                        child: CustomText(
                          'HELP',
                          fontWeight: FontWeight.bold,
                          size: 20,
                        ),
                      ),
                      content: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                'You can swipe a starred article to remove it from the Star list.'),
                            const SizedBox(height: 20),
                            RichText(
                                text: const TextSpan(children: [
                              TextSpan(text: 'Click '),
                              WidgetSpan(
                                child: Icon(Icons.refresh, size: 14),
                              ),
                              TextSpan(
                                text: " to get the latest updated list.",
                              ),
                            ]))
                          ],
                        ),
                      ),
                      actions: [
                        Center(
                          child: CustomElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              text: 'OKAY'),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.help, color: mColor))
          ],
        ),
        drawer: const DrawerMenu(isLoggedIn: false),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSearchBar(
                controller: _search,
                onChanged: (value) => setState(() {
                  keyword = _search.text;
                }),
                suffixIcon: keyword.isEmpty
                    ? const Icon(
                        Icons.search,
                        color: mColor,
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _search.clear();
                            keyword = '';
                          });
                        },
                        icon: const Icon(Icons.cancel),
                        color: mColor,
                      ),
              ),
              const SizedBox(height: 15),
              StreamBuilder<Iterable<ArticleModel>>(
                  stream: _starsService.starsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('You have no starred articles yet.'));
                        } else {
                          results = snapshot.data!;
                        }
                      }

                      if (keyword.isNotEmpty) {
                        results = snapshot.data!.where((element) => element
                            .title
                            .toLowerCase()
                            .contains(keyword.toLowerCase()));
                      }

                      if (keyword.isNotEmpty && results.isEmpty) {
                        return const Text('No results found!');
                      }

                      return Flexible(
                        child: ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final id =
                                results.elementAt(index).documentId.toString();
                            return Dismissible(
                                key: Key(id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  _starsService.deleteStar(id);
                                  setState(() {});
                                },
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                child: StarCard(
                                  onTap: () async {
                                    bool result = await AutoRouter.of(context)
                                        .push(ArticleDetailsRoute(
                                      article: results.elementAt(index),
                                      isStarred: true,
                                      isLoggedIn: false,
                                    )) as bool;
                                    if (result) {
                                      setState(() {});
                                    }
                                  },
                                  articleModel: results.elementAt(index),
                                ));
                          },
                        ),
                      );
                    } else {
                      return const CustomLoadingIcon();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
