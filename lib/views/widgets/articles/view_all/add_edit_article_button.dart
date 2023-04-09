import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

class AddArticleButton extends StatelessWidget {
  final String? category;

  const AddArticleButton({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.1,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 0.1,
              offset: Offset(3, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () =>
              AutoRouter.of(context).push(AddEditRoute(category: category)),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 5)),
            backgroundColor: MaterialStateProperty.all<Color>(mColor),
            foregroundColor: MaterialStateProperty.all<Color>(white),
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
