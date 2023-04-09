import 'package:auto_route/annotations.dart';
import 'package:students_guide/views/pages/articles/add_edit_view.dart';
import 'package:students_guide/views/pages/articles/article_details_view.dart';
import 'package:students_guide/views/pages/articles/articles_view.dart';
import 'package:students_guide/views/pages/contact/contact_view.dart';
import 'package:students_guide/views/pages/home/home_view.dart';
import 'package:students_guide/views/pages/login/login_view.dart';
import 'package:students_guide/views/pages/onboarding/onboarding_view.dart';
import 'package:students_guide/views/pages/stars/stars_view.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'View,Route',
  routes: <AutoRoute>[
    AutoRoute(page: OnboardingView),
    AutoRoute(page: HomeView),
    AutoRoute(page: ArticlesView),
    AutoRoute(page: ArticleDetailsView),
    AutoRoute(page: LoginView),
    AutoRoute(page: AddEditView),
    AutoRoute(page: ContactView),
    AutoRoute(page: StarsView),
  ],
)
class $AppRouter {}
