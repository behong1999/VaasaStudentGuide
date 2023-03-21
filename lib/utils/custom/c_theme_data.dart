import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color mColor = Color.fromRGBO(249, 168, 38, 1);
const Color lBackgroundColor = Color.fromRGBO(255, 247, 235, 1);
const Color lCaptionColor = Color.fromRGBO(7, 17, 26, 1);
const Color dBackgroundColor = Color.fromRGBO(47, 46, 65, 1);
const Color dCaptionColor = Color.fromRGBO(253, 253, 253, 0.941);

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      backgroundColor: dBackgroundColor,
      iconTheme: IconThemeData(color: Colors.white),
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
      foregroundColor: Colors.black,
      backgroundColor: lBackgroundColor,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    primaryColor: mColor,
    iconTheme: const IconThemeData(color: Colors.black),
    scaffoldBackgroundColor: lBackgroundColor,
    canvasColor: lBackgroundColor,
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.latoTextTheme().toString(),
          displayColor: lCaptionColor,
          bodyColor: lCaptionColor,
        ),
  );
}
