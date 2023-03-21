import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:students_guide/services/theme/theme_preferences.dart';
import 'package:students_guide/utils/enums.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  void setTheme(int index) {
    ThemeState themeState;
    final themePref = ThemePreferences();
    themePref.setTheme(index);
    switch (index) {
      case 0:
        themeState = const ThemeState(themeMode: ThemeMode.system);
        break;
      case 1:
        themeState = const ThemeState(themeMode: ThemeMode.light);
        break;
      case 2:
        themeState = const ThemeState(themeMode: ThemeMode.dark);
        break;
      default:
        themeState = const ThemeState(themeMode: ThemeMode.system);
        break;
    }
    emit(themeState);
  }

  Future<void> getTheme() async {
    final themePref = ThemePreferences();
    final theme = await themePref.getTheme();
    ThemeMode themeMode;
    if (theme == Themes.system) {
      themeMode = ThemeMode.system;
    } else if (theme == Themes.dark) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    emit(ThemeState(themeMode: themeMode));
  }
}
