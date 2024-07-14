import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:students_guide/services/url_launcher.dart';
import 'package:students_guide/utils/custom/c_scroll_config.dart';
import 'package:students_guide/views/widgets/articles/details/map_view.dart';

import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/articles/cloud_const.dart';
import 'package:students_guide/services/articles/cloud_service.dart';
import 'package:students_guide/services/stars/stars_service.dart';
import 'package:students_guide/utils/custom/c_loading_icon.dart';
import 'package:students_guide/utils/custom/c_snackbar.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/dialogs/delete_dialog.dart';
import 'package:students_guide/utils/routes/router.gr.dart';
import 'package:students_guide/views/widgets/articles/details/details_container.dart';
import 'package:students_guide/views/widgets/articles/details/details_text.dart';
import 'package:students_guide/views/widgets/articles/stars/star_button.dart';

@RoutePage()
class ArticleDetailsView extends StatefulWidget {
  final ArticleModel article;
  final bool isStarred;
  final bool isLoggedIn;
  const ArticleDetailsView({
    Key? key,
    required this.article,
    required this.isStarred,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  State<ArticleDetailsView> createState() => _ArticleDetailsViewState();
}

class _ArticleDetailsViewState extends State<ArticleDetailsView> {
  late final StarsService _starsService;
  late final CloudService _cloudService;

  ScrollController scrollController = ScrollController();

  bool starredStatus = false;
  //* Used to return to the previous stack to decide whether it needs rebuilding or not
  bool isChanged = false;

  //* Spacing between leading icon and the title
  double spacing = 16;
  double titleSize = 14;
  double expandedHeight = 200;

  @override
  initState() {
    _starsService = StarsService();
    _cloudService = CloudService();
    starredStatus = widget.isStarred;
    scrollController.addListener(() {
      //* Scroll down
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse ||
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        setState(() {
          spacing = 40;
          titleSize = 16;
        });
      }

      //* Scroll up or when scrolling to up to half of the view
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward ||
          scrollController.position.pixels ==
              scrollController.position.minScrollExtent ||
          (scrollController.position.userScrollDirection ==
                  ScrollDirection.forward &&
              scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent / 2)) {
        setState(() {
          spacing = 16;
          titleSize = 14;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final id = article.documentId.toString();
    final title = article.title.toString();
    final image = article.imageUrl.toString();
    final intro = article.intro.toString();
    final info = article.info.toString();
    final address = article.address.toString();
    final email = article.email.toString();
    final website = article.website.toString();
    final tel = article.tel.toString();
    final lastBy = article.lastModifiedBy.toString();
    final date = DateFormat('dd/MM/yyyy').format(article.date);

    final loggedIn = widget.isLoggedIn;

    //* TextStyle for the title and the detailed information
    TextStyle titleStyle = TextStyle(
        fontSize: titleSize, fontWeight: FontWeight.bold, color: white);
    const contentStyle = TextStyle(fontSize: 18);
    const dateStyle = TextStyle(fontStyle: FontStyle.italic);

    //* Check Brightness
    bool isLight = checkIfLightTheme(context);

    //* Height and width of the screen
    double mediaHeight = MediaQuery.of(context).size.height;
    double hBetween = mediaHeight * 0.01;

    //* Pop up options for admins
    final options = {
      'Edit': () {
        AutoRouter.of(context).push(AddEditRoute(article: article));
      },
      'Delete': () {
        Future.delayed(
          const Duration(seconds: 0),
          () async {
            bool delete = await showDeleteDialog(context);
            if (delete) {
              await _cloudService.deleteArticle(id);
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        );
      }
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScrollConfig(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            //* App bar including Image and Title
            SliverAppBar(
              iconTheme: IconThemeData(color: isLight ? black : white),
              leading: PlatformIconButton(
                  color: white,
                  materialIcon: const Icon(Icons.arrow_back),
                  cupertinoIcon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context, isChanged);
                  }),
              expandedHeight: expandedHeight,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.all(0),
                title: SafeArea(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(spacing, 8, 0, 8),
                    color: black.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //* TITLE
                        Flexible(
                          child: Text(
                            title,
                            textAlign: TextAlign.start,
                            style: titleStyle,
                          ),
                        ),
                        //* MENU ICON
                        loggedIn
                            //* POP UP MENU FOR ADMIN ONLY
                            ? PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert_rounded,
                                  color: white,
                                ),
                                color: isLight ? white : gray,
                                itemBuilder: (context) {
                                  return options.entries
                                      .map(
                                        (e) => PopupMenuItem(
                                          onTap: e.value,
                                          child: SizedBox(child: Text(e.key)),
                                        ),
                                      )
                                      .toList();
                                },
                              )
                            //* STAR BUTTON
                            : StarButton(
                                isStarred: starredStatus,
                                onPressed: () => setState(
                                  () {
                                    starredStatus = !starredStatus;
                                    isChanged = !isChanged;

                                    if (starredStatus) {
                                      _starsService.addStar(article);
                                    } else {
                                      _starsService.deleteStar(id);
                                    }
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                background: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CustomLoadingIcon(),
                  errorWidget: (context, url, error) =>
                      const Center(child: CustomText('No image to show')),
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      Text('Latest Update on $date', style: dateStyle),
                      Visibility(
                        visible: loggedIn,
                        child: Text(
                          ' by ${lastBy.split('@')[0]}',
                          style: dateStyle,
                        ),
                      ),
                    ],
                  ),
                ),

                //* INTRODUCTION
                DetailsContainer(
                  content: intro,
                  style: contentStyle,
                ),

                SizedBox(height: hBetween),

                //* DETAILED INFORMATION
                DetailsContainer(
                  title: 'Detailed Information',
                  content: info,
                  style: contentStyle,
                ),

                Visibility(
                  visible: address.isNotEmpty,
                  child: SizedBox(height: hBetween * 3),
                ),

                //* ADDRESS
                DetailsText(
                  title: addressField,
                  content: address,
                  style: contentStyle,
                ),

                Visibility(
                  visible: address.isNotEmpty,
                  child: SizedBox(height: hBetween * 2),
                ),

                //* MAP
                Visibility(
                  visible: address.isNotEmpty,
                  child: MapView(address: address),
                ),

                Visibility(
                  visible: email.isNotEmpty,
                  child: SizedBox(height: hBetween),
                ),

                //* EMAIL
                DetailsText(
                  title: emailField,
                  content: email,
                  style: contentStyle,
                  onTap: () => launcher(email, emailField),
                  suffixIcon: IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: email));
                        ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(
                            content: "Copied to clipboard",
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16)),
                ),

                Visibility(
                  visible: tel.isNotEmpty,
                  child: SizedBox(height: hBetween),
                ),

                //* TELEPHONE
                DetailsText(
                  title: 'Phone Number: ',
                  content: tel,
                  style: contentStyle,
                  onTap: () => launcher(tel, telField),
                ),

                Visibility(
                  visible: website.isNotEmpty,
                  child: SizedBox(height: hBetween * 3),
                ),

                //* WEBSITE LINK
                DetailsText(
                  title: websiteField,
                  content: website,
                  style: contentStyle,
                  onTap: () {
                    launcher(website, websiteField);
                  },
                ),

                SizedBox(height: hBetween),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
