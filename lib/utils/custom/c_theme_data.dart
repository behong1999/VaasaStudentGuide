import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_guide/cubit/theme_cubit.dart';

const white = Colors.white;
const black = Colors.black;
const grey = Colors.grey;
Color gray = Colors.grey.shade800;
const Color mColor = Color.fromRGBO(249, 168, 38, 1);
const Color lBackgroundColor = Color.fromRGBO(255, 247, 235, 1);
const Color lCaptionColor = Color.fromRGBO(7, 17, 26, 1);
const Color dBackgroundColor = Color.fromRGBO(47, 46, 65, 1);
const Color dCaptionColor = Color.fromRGBO(253, 253, 253, 0.941);

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      foregroundColor: white,
      backgroundColor: dBackgroundColor,
      iconTheme: IconThemeData(color: white),
    ),
    primaryColor: mColor,
    scaffoldBackgroundColor: dBackgroundColor,
    canvasColor: dBackgroundColor,
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.latoTextTheme().toString(),
          displayColor: dCaptionColor,
          bodyColor: dCaptionColor,
        ),
  );
}

ThemeData lightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      foregroundColor: black,
      backgroundColor: lBackgroundColor,
      iconTheme: IconThemeData(color: black),
    ),
    primaryColor: mColor,
    iconTheme: const IconThemeData(color: black),
    scaffoldBackgroundColor: lBackgroundColor,
    canvasColor: lBackgroundColor,
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.latoTextTheme().toString(),
          displayColor: lCaptionColor,
          bodyColor: lCaptionColor,
        ),
  );
}

bool checkIfLightTheme(BuildContext context) {
  //*Check if the device is in light mode when choosing System theme option
  if (MediaQuery.of(context).platformBrightness == Brightness.light &&
      BlocProvider.of<ThemeCubit>(context).state.themeMode ==
          ThemeMode.system) {
    return true;
  }
  //* Or when Light theme option has been chosen
  if (BlocProvider.of<ThemeCubit>(context).state.themeMode == ThemeMode.light) {
    return true;
  }
  return false;
}
