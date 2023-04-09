import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_guide/models/article_model.dart';

import 'package:students_guide/models/category_model.dart';
import 'package:students_guide/services/articles/cloud_service.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/views/widgets/articles/view_all/add_edit_article_button.dart';
import 'package:students_guide/views/widgets/articles/view_all/article_card.dart';
import 'package:students_guide/views/widgets/articles/view_all/search_bar.dart';
import 'package:students_guide/views/widgets/home/home_item.dart';

class ArticlesView extends StatefulWidget {
  final CategoryModel categoryModel;

  const ArticlesView(this.categoryModel, {super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  late final CloudService _cloudFirebase;
  late final StarsService _starsService;
  late final TextEditingController _search;
  late final CategoryModel categoryModel;
  late final String category;
  late final Stream<Iterable<ArticleModel>> stream;
  late final StreamSubscription<Iterable<ArticleModel>> subscription;
  Iterable _results = [];
  String _keyword = '';

  //* Update Stars' data when an article is updated on Firebase
  streamListener() {
    subscription = stream.listen((_) => _starsService.updateStars(stream));
  }

  @override
  void initState() {
    _cloudFirebase = CloudService();
    _starsService = StarsService();
    _search = TextEditingController();

    categoryModel = widget.categoryModel;
    category = categoryModel.category.name;
    stream = _cloudFirebase.getArticlesByCategory(category: category);

    _starsService.init();
    streamListener();
    super.initState();
  }

  @override
  void dispose() {
    _starsService.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        BlocProvider.of<AuthBloc>(context).state is AuthStateSignedIn;

    return Scaffold(
      appBar: CustomAppBar(
        actions: [if (isLoggedIn) AddArticleButton(category: category)],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Category title
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              child: HomeItem(categoryModel)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                //* Search bar
                SearchBar(
                  controller: _search,
                  onChanged: (value) => setState(() {
                    _keyword = value;
                  }),
                  suffixIcon: _keyword.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel, color: mColor),
                          onPressed: () => setState(() {
                            _search.clear();
                            _keyword = '';
                          }),
                        )
                      : const Icon(Icons.search, color: mColor),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                //* Stream to display a list of articles related to the chosen category
                StreamBuilder<Iterable<ArticleModel>>(
                  stream: stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CustomLoadingIcon());
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            _results = snapshot.data!;
                          } else {
                            return const Center(
                                child: Text(
                                    'No article for this category at the moment.'));
                          }
                          if (_keyword.isNotEmpty) {
                            _results = snapshot.data!.where((element) => element
                                .title
                                .toLowerCase()
                                .contains(_keyword.toLowerCase()));
                          }
                          if (_keyword.isNotEmpty && _results.isEmpty) {
                            return const Text('No results found!');
                          }
                        }

                        return Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              return ArticleCard(
                                isLoggedIn: isLoggedIn,
                                articleModel: _results.elementAt(index),
                              );
                            },
                          ),
                        );

                      default:
                        return const CustomLoadingIcon();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
