import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin SharedPreferencesInstance {
  SharedPreferences get prefs => SharedPreference.getPrefs();
}

class SharedPreference {
  static SharedPreferences? sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static getPrefs(){
    return sharedPreferences;
  }

  static void setOptionState(bool optionState) async {
    await sharedPreferences!.setBool('option', optionState);
  }

  static bool getOption() {
    return sharedPreferences!.getBool('option') ?? false;
  }
}

mixin L10n {
  String l10n(String key){
    return key.i18n();
  }
}

class TimeHelpers {

  static String doTimeFromString(duration) {
    String result = "";

    var intTime = int.parse(duration);
    var intTimeH = intTime ~/ 3600;
    var intTimeM = (intTime % 3600) ~/ 60;
    var intTimeS = ((intTime % 3600) % 60).toInt();

    if (intTimeS != 0) {
      if (intTimeM != 0) {
        if (intTimeS < 10) {
          result = "0$intTimeS";
        } else {
          result = intTimeS.toString();
        }
      } else {
        if (intTimeS < 10) {
          result = "0:0$intTimeS";
        } else {
          result = "0:$intTimeS";
        }
      }
    } else {
      if (intTimeM != 0 || intTimeH != 0) {
        result = "00";
      }
    }
    if (intTimeM != 0) {
      if (intTimeM < 10) {
        result = "0$intTimeM:$result";
      } else {
        result = "$intTimeM:$result";
      }
    } else {
      if (intTimeH != 0) {
        result = "00:$result";
      }
    }
    if (intTimeH != 0) {
      if (intTimeH < 10) {
        result = "0$intTimeH:$result";
      } else {
        result = "$intTimeH:$result";
      }
    }

    if (result == "") {
      return result;
    } else {
      return "$result/";
    }

  }

}