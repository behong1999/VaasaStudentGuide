import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:students_guide/models/category_model.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/routes/router.gr.dart';
import 'package:students_guide/views/widgets/home_item.dart';

class ArticlesPage extends StatelessWidget {
  final CategoryModel categoryModel;
  const ArticlesPage(
    this.categoryModel, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      final isLoggedIn = state is AuthStateSignedIn;
      return Scaffold(
        appBar: CustomAppBar(
          actions: [if (isLoggedIn) const AddArticleButton()],
        ),
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.14,
                child: HomeItem(categoryModel))
          ],
        ),
      );
    });
  }
}

class AddArticleButton extends StatelessWidget {
  const AddArticleButton({
    super.key,
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
          onPressed: () => AutoRouter.of(context).push(const AddEditRoute()),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 5)),
            backgroundColor: MaterialStateProperty.all<Color>(mColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
