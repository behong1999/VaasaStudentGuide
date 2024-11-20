import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:students_guide/models/category_model.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

class HomeItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const HomeItem(
    this.categoryModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: categoryModel.category.name,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: categoryModel.color,
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(categoryModel.image),
            ),
          ),
          child: ListTile(
            onTap: () {
              AutoRouter.of(context).current.name == const HomeRoute().routeName
                  ? context
                      .pushRoute(ArticlesRoute(categoryModel: categoryModel))
                  : null;
            },
            title: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      categoryModel.icon,
                      color: white,
                      size: 22,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Text(
                      categoryModel.category.name.toUpperCase(),
                      style: const TextStyle(
                        color: white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
