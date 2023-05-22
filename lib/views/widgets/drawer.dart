import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:students_guide/services/auth/bloc/auth_bloc.dart';
import 'package:students_guide/services/theme/cubit/theme_cubit.dart';
import 'package:students_guide/utils/custom/c_scroll_config.dart';
import 'package:students_guide/utils/dialogs/sign_out_dialog.dart';
import 'package:students_guide/utils/enums.dart';
import 'package:students_guide/utils/extensions/string_extension.dart';
import 'package:students_guide/utils/routes/router.gr.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/utils/custom/c_icons.dart';
import 'package:students_guide/views/widgets/drawer_item.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({
    Key? key,
    required this.isLoggedIn,
  }) : super(key: key);

  final bool isLoggedIn;

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (BuildContext context, ThemeState state) {
        final themeMode =
            state.themeMode.toString().split('.').elementAt(1).toCamelCase();
        return Drawer(
          child: Column(
            children: [
              Flexible(
                child: ScrollConfig(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: DrawerHeader(
                          padding: const EdgeInsets.all(15),
                          decoration: const BoxDecoration(color: mColor),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: white,
                                  child: Icon(
                                    widget.isLoggedIn
                                        ? FontAwesomeIcons.userShield
                                        : Icons.person,
                                    size: 40,
                                    color: black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.isLoggedIn ? 'Admin' : 'Free User',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (widget.isLoggedIn)
                                  Text(FirebaseAuth.instance.currentUser!.email
                                      .toString())
                              ],
                            ),
                          ),
                        ),
                      ),
                      DrawerItem(
                        icon: Icons.home,
                        title: const DrawerText('Home'),
                        onTap: () =>
                            pushAndPopUntil(context, const HomeRoute()),
                      ),
                      if (widget.isLoggedIn)
                        DrawerItem(
                          icon: Icons.edit,
                          title: const DrawerText('Add'),
                          onTap: () => context.router.push(AddEditRoute()),
                        )
                      else
                        ...([
                          DrawerItem(
                            icon: Icons.star,
                            title: const DrawerText('Stars'),
                            onTap: () async {
                              pushAndPopUntil(context, const StarsRoute());
                            },
                          ),
                          DrawerItem(
                            icon: CustomIcons.contact,
                            title: const DrawerText('Contact'),
                            onTap: () =>
                                pushAndPopUntil(context, const ContactRoute()),
                          ),
                        ]),
                      Column(
                        children: [
                          DrawerItem(
                            icon: CustomIcons.brightness,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DrawerText('$themeMode theme'),
                                PopupMenuButton(
                                  icon: const Icon(
                                      Icons.arrow_drop_down_outlined),
                                  itemBuilder: (BuildContext context) {
                                    return Themes.values.map((theme) {
                                      final textTheme =
                                          EnumToString.convertToString(theme)
                                              .toCamelCase();
                                      return PopupMenuItem(
                                        value: theme,
                                        child: Text(
                                          textTheme,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (value) {
                                    final themeIndex =
                                        Themes.values.indexOf(value);
                                    BlocProvider.of<ThemeCubit>(context)
                                        .setTheme(
                                      themeIndex,
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  const Divider(),
                  widget.isLoggedIn
                      ? DrawerItem(
                          icon: Icons.logout_outlined,
                          title: const DrawerText('Sign Out'),
                          onTap: (() async {
                            final signOut = await showSignoutDialog(context);
                            if (signOut) {
                              Future.delayed(const Duration(milliseconds: 1),
                                  () {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(AuthEventLogout());
                                pushAndPopUntil(context, const HomeRoute());
                              });
                            }
                          }))
                      : DrawerItem(
                          icon: Icons.login_outlined,
                          title: const DrawerText('Login as Admin'),
                          onTap: (() {
                            Navigator.pop(context);
                            context.pushRoute(const LoginRoute());
                          }))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class DrawerText extends StatelessWidget {
  const DrawerText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}

pushAndPopUntil(BuildContext context, PageRouteInfo pageRoute) {
  if (context.router.current.name == pageRoute.routeName) {
    Navigator.pop(context);
  } else {
    context.router
        .pushAndPopUntil(pageRoute, predicate: (Route<dynamic> route) => false);
  }
}
