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
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:students_guide/models/category_model.dart' as _i9;
import 'package:students_guide/views/pages/articles/add_edit_page.dart' as _i6;
import 'package:students_guide/views/pages/articles/articles_page.dart' as _i5;
import 'package:students_guide/views/pages/contact_page.dart' as _i3;
import 'package:students_guide/views/pages/home_page.dart' as _i2;
import 'package:students_guide/views/pages/login_page.dart' as _i4;
import 'package:students_guide/views/pages/onboarding_page.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    OnboardingRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.OnboardingPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    ContactRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.ContactPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginPage(),
      );
    },
    ArticlesRoute.name: (routeData) {
      final args = routeData.argsAs<ArticlesRouteArgs>();
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.ArticlesPage(
          args.categoryModel,
          key: args.key,
        ),
      );
    },
    AddEditRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.AddEditPage(),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          OnboardingRoute.name,
          path: '/onboarding-page',
        ),
        _i7.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i7.RouteConfig(
          ContactRoute.name,
          path: '/contact-page',
        ),
        _i7.RouteConfig(
          LoginRoute.name,
          path: '/login-page',
        ),
        _i7.RouteConfig(
          ArticlesRoute.name,
          path: '/articles-page',
        ),
        _i7.RouteConfig(
          AddEditRoute.name,
          path: '/add-edit-page',
        ),
      ];
}

/// generated route for
/// [_i1.OnboardingPage]
class OnboardingRoute extends _i7.PageRouteInfo<void> {
  const OnboardingRoute()
      : super(
          OnboardingRoute.name,
          path: '/onboarding-page',
        );

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.ContactPage]
class ContactRoute extends _i7.PageRouteInfo<void> {
  const ContactRoute()
      : super(
          ContactRoute.name,
          path: '/contact-page',
        );

  static const String name = 'ContactRoute';
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-page',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i5.ArticlesPage]
class ArticlesRoute extends _i7.PageRouteInfo<ArticlesRouteArgs> {
  ArticlesRoute({
    required _i9.CategoryModel categoryModel,
    _i8.Key? key,
  }) : super(
          ArticlesRoute.name,
          path: '/articles-page',
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

  final _i9.CategoryModel categoryModel;

  final _i8.Key? key;

  @override
  String toString() {
    return 'ArticlesRouteArgs{categoryModel: $categoryModel, key: $key}';
  }
}

/// generated route for
/// [_i6.AddEditPage]
class AddEditRoute extends _i7.PageRouteInfo<void> {
  const AddEditRoute()
      : super(
          AddEditRoute.name,
          path: '/add-edit-page',
        );

  static const String name = 'AddEditRoute';
}
