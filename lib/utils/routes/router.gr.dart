// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:students_guide/models/article_model.dart' as _i12;
import 'package:students_guide/models/category_model.dart' as _i11;
import 'package:students_guide/views/pages/articles/add_edit_view.dart' as _i6;
import 'package:students_guide/views/pages/articles/article_details_view.dart'
    as _i4;
import 'package:students_guide/views/pages/articles/articles_view.dart' as _i3;
import 'package:students_guide/views/pages/contact/contact_view.dart' as _i7;
import 'package:students_guide/views/pages/home/home_view.dart' as _i2;
import 'package:students_guide/views/pages/login/login_view.dart' as _i5;
import 'package:students_guide/views/pages/onboarding/onboarding_view.dart'
    as _i1;
import 'package:students_guide/views/pages/stars/stars_view.dart' as _i8;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    OnboardingRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.OnboardingView(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeView(),
      );
    },
    ArticlesRoute.name: (routeData) {
      final args = routeData.argsAs<ArticlesRouteArgs>();
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.ArticlesView(
          args.categoryModel,
          key: args.key,
        ),
      );
    },
    ArticleDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<ArticleDetailsRouteArgs>();
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.ArticleDetailsView(
          key: args.key,
          article: args.article,
          isStarred: args.isStarred,
          isLoggedIn: args.isLoggedIn,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoginView(),
      );
    },
    AddEditRoute.name: (routeData) {
      final args = routeData.argsAs<AddEditRouteArgs>(
          orElse: () => const AddEditRouteArgs());
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.AddEditView(
          key: args.key,
          category: args.category,
          article: args.article,
        ),
      );
    },
    ContactRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.ContactView(),
      );
    },
    StarsRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.StarsView(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding-view',
        ),
        _i9.RouteConfig(
          HomeRoute.name,
          path: '/home-view',
        ),
        _i9.RouteConfig(
          ArticlesRoute.name,
          path: '/articles-view',
        ),
        _i9.RouteConfig(
          ArticleDetailsRoute.name,
          path: '/article-details-view',
        ),
        _i9.RouteConfig(
          LoginRoute.name,
          path: '/login-view',
        ),
        _i9.RouteConfig(
          AddEditRoute.name,
          path: '/add-edit-view',
        ),
        _i9.RouteConfig(
          ContactRoute.name,
          path: '/contact-view',
        ),
        _i9.RouteConfig(
          StarsRoute.name,
          path: '/stars-view',
        ),
      ];
}

/// generated route for
/// [_i1.OnboardingView]
class OnboardingRoute extends _i9.PageRouteInfo<void> {
  const OnboardingRoute()
      : super(
          OnboardingRoute.name,
          path: '/onboarding-view',
        );

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [_i2.HomeView]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-view',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.ArticlesView]
class ArticlesRoute extends _i9.PageRouteInfo<ArticlesRouteArgs> {
  ArticlesRoute({
    required _i11.CategoryModel categoryModel,
    _i10.Key? key,
  }) : super(
          ArticlesRoute.name,
          path: '/articles-view',
          args: ArticlesRouteArgs(
            categoryModel: categoryModel,
            key: key,
          ),
        );

  static const String name = 'ArticlesRoute';
}

class ArticlesRouteArgs {
  const ArticlesRouteArgs({
    required this.categoryModel,
    this.key,
  });

  final _i11.CategoryModel categoryModel;

  final _i10.Key? key;

  @override
  String toString() {
    return 'ArticlesRouteArgs{categoryModel: $categoryModel, key: $key}';
  }
}

/// generated route for
/// [_i4.ArticleDetailsView]
class ArticleDetailsRoute extends _i9.PageRouteInfo<ArticleDetailsRouteArgs> {
  ArticleDetailsRoute({
    _i10.Key? key,
    required _i12.ArticleModel article,
    required bool isStarred,
    required bool isLoggedIn,
  }) : super(
          ArticleDetailsRoute.name,
          path: '/article-details-view',
          args: ArticleDetailsRouteArgs(
            key: key,
            article: article,
            isStarred: isStarred,
            isLoggedIn: isLoggedIn,
          ),
        );

  static const String name = 'ArticleDetailsRoute';
}

class ArticleDetailsRouteArgs {
  const ArticleDetailsRouteArgs({
    this.key,
    required this.article,
    required this.isStarred,
    required this.isLoggedIn,
  });

  final _i10.Key? key;

  final _i12.ArticleModel article;

  final bool isStarred;

  final bool isLoggedIn;

  @override
  String toString() {
    return 'ArticleDetailsRouteArgs{key: $key, article: $article, isStarred: $isStarred, isLoggedIn: $isLoggedIn}';
  }
}

/// generated route for
/// [_i5.LoginView]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-view',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i6.AddEditView]
class AddEditRoute extends _i9.PageRouteInfo<AddEditRouteArgs> {
  AddEditRoute({
    _i10.Key? key,
    String? category,
    _i12.ArticleModel? article,
  }) : super(
          AddEditRoute.name,
          path: '/add-edit-view',
          args: AddEditRouteArgs(
            key: key,
            category: category,
            article: article,
          ),
        );

  static const String name = 'AddEditRoute';
}

class AddEditRouteArgs {
  const AddEditRouteArgs({
    this.key,
    this.category,
    this.article,
  });

  final _i10.Key? key;

  final String? category;

  final _i12.ArticleModel? article;

  @override
  String toString() {
    return 'AddEditRouteArgs{key: $key, category: $category, article: $article}';
  }
}

/// generated route for
/// [_i7.ContactView]
class ContactRoute extends _i9.PageRouteInfo<void> {
  const ContactRoute()
      : super(
          ContactRoute.name,
          path: '/contact-view',
        );

  static const String name = 'ContactRoute';
}

/// generated route for
/// [_i8.StarsView]
class StarsRoute extends _i9.PageRouteInfo<void> {
  const StarsRoute()
      : super(
          StarsRoute.name,
          path: '/stars-view',
        );

  static const String name = 'StarsRoute';
}
