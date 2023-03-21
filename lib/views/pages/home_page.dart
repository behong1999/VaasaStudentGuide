import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_guide/models/category_model.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/utils/custom/c_text.dart';
import 'package:students_guide/utils/custom/c_app_bar.dart';
import 'package:students_guide/views/widgets/drawer.dart';
import 'package:students_guide/views/widgets/home_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateUninitialized) {
          context.read<AuthBloc>().add(AuthEventInitialize());
        }
        final isLoggedIn = state is AuthStateSignedIn;
        return Scaffold(
          appBar: CustomAppBar(),
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
                    return HomeItem(categoryList[index]);
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