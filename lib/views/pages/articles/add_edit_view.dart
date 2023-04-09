// ignore_for_file: list_remove_unrelated_type

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:students_guide/models/article_model.dart';
import 'package:students_guide/services/articles/cloud_service.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/custom/c_elevated_button.dart';
import 'package:students_guide/utils/custom/c_text_form_field.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/enums.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

//* If category is passed, add new article related to the pass category
//* If article is passed, update the passed article
//* If neither of them is passed, add new article

class AddEditView extends StatefulWidget {
  final String? category;
  final ArticleModel? article;

  const AddEditView({
    Key? key,
    this.category,
    this.article,
  }) : super(key: key);

  @override
  State<AddEditView> createState() => _AddEditViewState();
}

class _AddEditViewState extends State<AddEditView> {
  late final TextEditingController title;

  late final TextEditingController image;

  late final TextEditingController intro;

  late final TextEditingController info;

  late final TextEditingController address;

  late final TextEditingController email;

  late final TextEditingController tel;

  late final TextEditingController website;

  late final CloudService cloudService;

  final formKey = GlobalKey<FormState>();

  String? currentCategory;

  @override
  void initState() {
    title = TextEditingController(
        text: (widget.article != null) ? widget.article?.title.toString() : '');
    image = TextEditingController(
        text: (widget.article != null)
            ? widget.article?.imageUrl.toString()
            : '');
    intro = TextEditingController(
        text: (widget.article != null) ? widget.article?.intro.toString() : '');
    info = TextEditingController(
        text: (widget.article != null) ? widget.article?.info.toString() : '');
    address = TextEditingController(
        text:
            (widget.article != null) ? widget.article?.address.toString() : '');
    email = TextEditingController(
        text: (widget.article != null) ? widget.article?.email.toString() : '');
    tel = TextEditingController(
        text: (widget.article != null) ? widget.article?.tel.toString() : '');
    website = TextEditingController(
        text:
            (widget.article != null) ? widget.article?.website.toString() : '');
    cloudService = CloudService();
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    image.dispose();
    intro.dispose();
    info.dispose();
    address.dispose();
    email.dispose();
    tel.dispose();
    website.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ArticleModel? passedArticle = widget.article;
    String? passedCategory = widget.category;
    double padding = 10;
    double radius = 10;
    bool isLight = checkIfLightTheme(context);

    //* List of drop down menu items
    List<DropdownMenuItem<String>> categoriesList = Categories.values
        .map((c) => DropdownMenuItem(
            value: c.name,
            child: Padding(
              padding: EdgeInsets.only(left: padding),
              child: Text(c.name.toCamelCase()),
            )))
        .toList();

    //* Default category for adding
    if (passedCategory != null) {
      currentCategory = passedCategory;
      categoriesList.remove(currentCategory);
    }

    //* Choose category when updating a passed article
    if (passedArticle != null) {
      currentCategory = passedArticle.category;
      categoriesList.remove(currentCategory);
    }

    //* List of Widgets for this screen
    List<Widget> list = [
      CustomTextFormField(
          controller: title,
          label: 'Title',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter the title';
            }
            return null;
          }),
      Container(
        decoration: BoxDecoration(
          color: isLight ? white : gray,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: radius,
              spreadRadius: 0.1,
              offset: const Offset(2, 1),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: DropdownButtonFormField(
          style: const TextStyle(color: mColor),
          decoration: const InputDecoration(border: InputBorder.none),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          iconEnabledColor: mColor,
          dropdownColor: isLight ? white : gray,
          value: currentCategory,
          hint: Padding(
            padding: EdgeInsets.only(left: padding),
            child: const Text(
              'Please choose a category',
              style: TextStyle(color: mColor),
            ),
          ),
          items: categoriesList,
          onChanged: passedCategory == null
              ? (value) {
                  currentCategory = value.toString();
                }
              : null,
        ),
      ),
      CustomTextFormField(
        inputType: TextInputType.url,
        controller: image,
        label: 'Image Link',
        validator: (value) {
          if (value!.isNotEmpty) {
            if (!value.validateUrl()) return 'Invalid Url';
          }
          return null;
        },
      ),
      CustomTextFormField(
        controller: intro,
        label: 'Introduction',
        maxLines: 3,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an introduction';
          }
          return null;
        },
      ),
      CustomTextFormField(
        controller: info,
        label: 'Description',
        maxLines: 5,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
      CustomTextFormField(
        inputType: TextInputType.streetAddress,
        controller: address,
        label: 'Address',
      ),
      CustomTextFormField(
        inputType: TextInputType.emailAddress,
        controller: email,
        label: 'Email',
        validator: (value) {
          if (value!.isNotEmpty) {
            if (!value.validateEmail()) return 'Invalid Email';
          }
          return null;
        },
      ),
      CustomTextFormField(
        inputType: TextInputType.phone,
        controller: tel,
        label: 'Phone number',
      ),
      CustomTextFormField(
        inputType: TextInputType.url,
        controller: website,
        label: 'Website',
        validator: (value) {
          if (value!.isNotEmpty) {
            if (!value.validateUrl()) return 'Invalid Website';
          }
          return null;
        },
      ),
      Center(
        child: CustomElevatedButton(
          text: 'Save & Close',
          onPressed: () async {
            String snackBarText = 'Added Successfully';
            if (formKey.currentState!.validate()) {
              if (passedArticle == null) {
                await cloudService.addNewArticle(
                  ArticleModel(
                    title: title.text,
                    imageUrl: image.text,
                    category: currentCategory.toString(),
                    intro: intro.text,
                    info: info.text,
                    date: DateTime.now(),
                    lastModifiedBy:
                        FirebaseAuth.instance.currentUser!.email.toString(),
                    address: address.text,
                    email: email.text,
                    tel: tel.text,
                    website: website.text,
                  ),
                );
              } else {
                await cloudService.updateArticle(
                  ArticleModel(
                    documentId: passedArticle.documentId,
                    title: title.text,
                    imageUrl: image.text,
                    category: currentCategory.toString(),
                    intro: intro.text,
                    info: info.text,
                    date: DateTime.now(),
                    lastModifiedBy:
                        FirebaseAuth.instance.currentUser!.email.toString(),
                    address: address.text,
                    email: email.text,
                    tel: tel.text,
                    website: website.text,
                  ),
                );
                snackBarText = 'Updated Successfully';
              }
              Future.delayed(
                const Duration(milliseconds: 100),
                () {
                  //* Pop the current route
                  Navigator.of(context).pop();
                  if (AutoRouter.of(context).current.name ==
                      ArticleDetailsRoute.name) {
                    //* Pop the Details route
                    Navigator.of(context).pop();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: mColor, content: Text(snackBarText)));
                },
              );
            }
          },
        ),
      )
    ];
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          passedArticle != null
              ? 'Edit Current Article'
              : (passedCategory != null
                  ? 'Add New ${passedCategory.toCamelCase()} Article'
                  : 'Add New Article'),
          style: const TextStyle(color: mColor),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView.separated(
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, index) => list[index],
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            itemCount: list.length),
      ),
    );
  }
}
