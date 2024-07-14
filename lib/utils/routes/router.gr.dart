// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:students_guide/models/article_model.dart' as _i11;
import 'package:students_guide/models/category_model.dart' as _i12;
import 'package:students_guide/views/pages/articles/add_edit_view.dart' as _i1;
import 'package:students_guide/views/pages/articles/article_details_view.dart'
    as _i2;
import 'package:students_guide/views/pages/articles/articles_view.dart' as _i3;
import 'package:students_guide/views/pages/contact/contact_view.dart' as _i4;
import 'package:students_guide/views/pages/home/home_view.dart' as _i5;
import 'package:students_guide/views/pages/login/login_view.dart' as _i6;
import 'package:students_guide/views/pages/onboarding/onboarding_view.dart'
    as _i7;
import 'package:students_guide/views/pages/stars/stars_view.dart' as _i8;

abstract class $AppRouter extends _i9.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AddEditRoute.name: (routeData) {
      final args = routeData.argsAs<AddEditRouteArgs>(
          orElse: () => const AddEditRouteArgs());
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddEditView(
          key: args.key,
          category: args.category,
          article: args.article,
        ),
      );
    },
    ArticleDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ArticleDetailsRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ArticleDetailsView(
          key: args.key,
          article: args.article,
          isStarred: args.isStarred,
          isLoggedIn: args.isLoggedIn,
        ),
      );
    },
    ArticlesRoute.name: (routeData) {
      final args = routeData.argsAs<ArticlesRouteArgs>();
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ArticlesView(
          args.categoryModel,
          key: args.key,
        ),
      );
    },
    ContactRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ContactView(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.HomeView(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.LoginView(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.OnboardingView(),
      );
    },
    StarsRoute.name: (routeData) {
      return _i9.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.StarsView(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddEditView]
class AddEditRoute extends _i9.PageRouteInfo<AddEditRouteArgs> {
  AddEditRoute({
    _i10.Key? key,
    String? category,
    _i11.ArticleModel? article,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          AddEditRoute.name,
          args: AddEditRouteArgs(
            key: key,
            category: category,
            article: article,
          ),
          initialChildren: children,
        );

  static const String name = 'AddEditRoute';

  static const _i9.PageInfo<AddEditRouteArgs> page =
      _i9.PageInfo<AddEditRouteArgs>(name);
}

class AddEditRouteArgs {
  const AddEditRouteArgs({
    this.key,
    this.category,
    this.article,
  });

  final _i10.Key? key;

  final String? category;

  final _i11.ArticleModel? article;

  @override
  String toString() {
    return 'AddEditRouteArgs{key: $key, category: $category, article: $article}';
  }
}

/// generated route for
/// [_i2.ArticleDetailsView]
class ArticleDetailsRoute extends _i9.PageRouteInfo<ArticleDetailsRouteArgs> {
  ArticleDetailsRoute({
    _i10.Key? key,
    required _i11.ArticleModel article,
    required bool isStarred,
    required bool isLoggedIn,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ArticleDetailsRoute.name,
          args: ArticleDetailsRouteArgs(
            key: key,
            article: article,
            isStarred: isStarred,
            isLoggedIn: isLoggedIn,
          ),
          initialChildren: children,
        );

  static const String name = 'ArticleDetailsRoute';

  static const _i9.PageInfo<ArticleDetailsRouteArgs> page =
      _i9.PageInfo<ArticleDetailsRouteArgs>(name);
}

class ArticleDetailsRouteArgs {
  const ArticleDetailsRouteArgs({
    this.key,
    required this.article,
    required this.isStarred,
    required this.isLoggedIn,
  });

  final _i10.Key? key;

  final _i11.ArticleModel article;

  final bool isStarred;

  final bool isLoggedIn;

  @override
  String toString() {
    return 'ArticleDetailsRouteArgs{key: $key, article: $article, isStarred: $isStarred, isLoggedIn: $isLoggedIn}';
  }
}

/// generated route for
/// [_i3.ArticlesView]
class ArticlesRoute extends _i9.PageRouteInfo<ArticlesRouteArgs> {
  ArticlesRoute({
    required _i12.CategoryModel categoryModel,
    _i10.Key? key,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ArticlesRoute.name,
          args: ArticlesRouteArgs(
            categoryModel: categoryModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ArticlesRoute';

  static const _i9.PageInfo<ArticlesRouteArgs> page =
      _i9.PageInfo<ArticlesRouteArgs>(name);
}

class ArticlesRouteArgs {
  const ArticlesRouteArgs({
    required this.categoryModel,
    this.key,
  });

  final _i12.CategoryModel categoryModel;

  final _i10.Key? key;

  @override
  String toString() {
    return 'ArticlesRouteArgs{categoryModel: $categoryModel, key: $key}';
  }
}

/// generated route for
/// [_i4.ContactView]
class ContactRoute extends _i9.PageRouteInfo<void> {
  const ContactRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i5.HomeView]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i6.LoginView]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute({List<_i9.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i7.OnboardingView]
class OnboardingRoute extends _i9.PageRouteInfo<void> {
  const OnboardingRoute({List<_i9.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}

/// generated route for
/// [_i8.StarsView]
class StarsRoute extends _i9.PageRouteInfo<void> {
  const StarsRoute({List<_i9.PageRouteInfo>? children})
      : super(
          StarsRoute.name,
          initialChildren: children,
        );

  static const String name = 'StarsRoute';

  static const _i9.PageInfo<void> page = _i9.PageInfo<void>(name);
}
