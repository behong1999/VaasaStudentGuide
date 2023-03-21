import 'package:auto_route/annotations.dart';
import 'package:students_guide/views/pages/articles/add_edit_page.dart';
import 'package:students_guide/views/pages/articles/articles_page.dart';
import 'package:students_guide/views/pages/contact_page.dart';
import 'package:students_guide/views/pages/home_page.dart';
import 'package:students_guide/views/pages/login_page.dart';
import 'package:students_guide/views/pages/onboarding_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: HomePage),
    AutoRoute(page: ArticlesPage),
    AutoRoute(page: LoginPage),
    AutoRoute(page: AddEditPage),
    AutoRoute(page: ContactPage),
  ],
)
class $AppRouter {}
