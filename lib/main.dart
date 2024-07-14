// ignore_for_file: unrelated_type_equality_checks

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_guide/firebase_options.dart';
import 'package:students_guide/services/auth/auth_repository_impl.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/services/theme/cubit/theme_cubit.dart';
import 'package:students_guide/utils/constants.dart' as constants;
import 'package:students_guide/utils/custom/c_bloc_observer.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = CustomBlocObserver();

  //* Show Home screen instead of Onboarding Screen if not the first time using
  final showHomePref = await SharedPreferences.getInstance();
  final showHome = showHomePref.getBool(constants.SHOW_HOME_PREF_KEY) ?? false;
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(StudentGuideApp(showHome)));
}

class StudentGuideApp extends StatefulWidget {
  final bool showHome;

  const StudentGuideApp(this.showHome, {super.key});

  @override
  State<StudentGuideApp> createState() => _StudentGuideAppState();
}

class _StudentGuideAppState extends State<StudentGuideApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(showHome: widget.showHome);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthRepositoryImpl())),
        BlocProvider(create: (context) => ThemeCubit()..getTheme()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (BuildContext context, ThemeState state) {
          return PlatformApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Student Guide App',
            material: (context, _) => MaterialAppRouterData(
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: BlocProvider.of<ThemeCubit>(context).state.themeMode,
            ),
            routerDelegate: _appRouter.delegate(),
            routeInformationParser: _appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }
}
