import 'package:open_university_rsvpu/helpers/helpers.dart';

class MyThemePreferences with SharedPreferencesInstance{

  setTheme(bool value) async {
    prefs.setBool("theme_key", value);
  }

  getTheme() async {
    return prefs.getBool("theme_key") ?? false;
  }
}
