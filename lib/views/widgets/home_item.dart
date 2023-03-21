import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:students_guide/models/category_model.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

class HomeItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const HomeItem(
    this.categoryModel, {
    Key? key,
  }) : super(key: key);

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
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage(categoryModel.image),
            ),
          ),
          child: ListTile(
            onTap: () {
              // context.pushRoute(ArticlesRoute(categoryModel: categoryModel));
              AutoRouter.of(context).push(
                ArticlesRoute(categoryModel: categoryModel),
              );
            },
            title: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      categoryModel.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Text(
                      categoryModel.category.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
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
