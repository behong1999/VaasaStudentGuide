import 'package:auto_route/auto_route.dart';
import 'package:students_guide/utils/routes/router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'View,Route',
)
class AppRouter extends $AppRouter {
  final bool showHome;

  AppRouter({super.navigatorKey, required this.showHome});

  @override
  List<AutoRoute> get routes {
    /*
    HomeRoute for showHome is true (user has used the app before).
    OnboardingRoute for showHome is false (first-time user).
    */
    bool toHome = false;
    bool toOnboarding = true;
    
    if (showHome) {
      toHome = true;
      toOnboarding = false;
    }

    return [
      AutoRoute(page: HomeRoute.page, initial: toHome),
      AutoRoute(page: OnboardingRoute.page, initial: toOnboarding),
      AutoRoute(page: ArticlesRoute.page),
      AutoRoute(page: ArticleDetailsRoute.page),
      AutoRoute(page: LoginRoute.page),
      AutoRoute(page: AddEditRoute.page),
      AutoRoute(page: ContactRoute.page),
      AutoRoute(page: StarsRoute.page),
    ];
  }
}
