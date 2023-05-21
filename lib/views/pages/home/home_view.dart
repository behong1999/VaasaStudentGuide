import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_guide/models/category_model.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/utils/dialogs/location_permission_dialog.dart';
import 'package:students_guide/views/widgets/drawer.dart';
import 'package:students_guide/views/widgets/home/home_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () async => await requestLocationPermission(context),
    );
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateUninitialized) {
          context.read<AuthBloc>().add(AuthEventInitialize());
        }
        final isLoggedIn = state is AuthStateSignedIn;
        return Scaffold(
          appBar: const CustomAppBar(),
          drawer: DrawerMenu(isLoggedIn: isLoggedIn),
          body: Column(
            children: [
              CustomText(
                isLoggedIn ? 'Welcome back' : 'Welcome',
                size: 22,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 24),
              Flexible(
                child: ListView.builder(
                  itemExtent: MediaQuery.of(context).size.height * 0.14,
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return HomeItem(
                      categoryList[index],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
