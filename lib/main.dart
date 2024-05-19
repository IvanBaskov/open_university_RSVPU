import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:open_university_rsvpu/splash_screen/splash_screen.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:open_university_rsvpu/helpers/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // OneSignal.shared.setAppId("52934883-8034-4dea-a064-27bf09bfd328");
  // OneSignal.shared.getTags().then((tags) {
  //   if (!tags.containsKey("video")) {
  //     OneSignal.shared.sendTag("video", "True");
  //   }
  //   if (!tags.containsKey("news")) {
  //     OneSignal.shared.sendTag("news", "True");
  //   }
  // });

  await SharedPreference.init();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(MyApp()));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SharedPreferencesInstance {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              LocalJsonLocalization.delegate,
              MapLocalization.delegate,
            ],
            supportedLocales: const [ Locale('ru', 'RU') ],
            theme: themeNotifier.isDark
              ? ThemeData(colorScheme: ColorScheme.dark().copyWith(secondary: mainBlue[900]))
              : ThemeData(colorScheme: ColorScheme.light().copyWith(secondary: mainBlue[900], primary: mainBlue[900])),
            home: SplashScreen(),
          );
        }
      )
    );
  }

}
