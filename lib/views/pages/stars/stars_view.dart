import 'package:flutter/material.dart';
import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_elevated_button.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/views/widgets/articles/stars/star_card.dart';
import 'package:students_guide/views/widgets/articles/view_all/search_bar.dart';
import 'package:students_guide/views/widgets/drawer.dart';

final StarsService _starsService = StarsService();

class StarsView extends StatefulWidget {
  const StarsView({Key? key}) : super(key: key);

  @override
  State<StarsView> createState() => _StarsViewState();
}

class _StarsViewState extends State<StarsView> {
  late final TextEditingController _search;
  Iterable<ArticleModel> articles = [];

  String keyword = '';

  @override
  initState() {
    _search = TextEditingController();
    _starsService.init();
    super.initState();
  }

  @override
  dispose() {
    _search.dispose();
    _starsService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await _starsService.getStars();
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
                              text: " to get the latest list.",
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
            SearchBar(
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
            FutureBuilder<Iterable<ArticleModel>>(
                future: _starsService.getStars(),
                builder: (context, snapshot) {
                  Iterable<ArticleModel> results = [];
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      articles = snapshot.data!;
                    }

                    results = articles;

                    if (snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('You have no starred articles yet.'));
                    }

                    if (keyword.isNotEmpty) {
                      results = snapshot.data!.where((element) => element.title
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
                          return StarCard(
                            articleModel: results.elementAt(index),
                          );
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
    );
  }
}