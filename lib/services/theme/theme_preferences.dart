import 'dart:developer';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students_guide/utils/constants.dart' as constants;
import 'package:students_guide/utils/enums.dart';

class ThemePreferences {
  setTheme(int index) async {
    final theme =
        index == 0 ? Themes.system : (index == 1 ? Themes.light : Themes.dark);
    final sharedPreferences = await SharedPreferences.getInstance();
    log(theme.toString());
    sharedPreferences.setString(
        constants.THEME_PREF_KEY, EnumToString.convertToString(theme));
  }

  Future<Themes?> getTheme() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return EnumToString.fromString(Themes.values,
        sharedPreferences.getString(constants.THEME_PREF_KEY) ?? "system");
  }
}
