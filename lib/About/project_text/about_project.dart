import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';

import 'package:open_university_rsvpu/helpers/helpers.dart';

class AboutProjectWidget extends StatefulWidget {
  const AboutProjectWidget({super.key});

  @override
  State<AboutProjectWidget> createState() => _AboutProjectWidgetState();
}

class _AboutProjectWidgetState extends State<AboutProjectWidget> with L10n {

  Widget buildHeader(String text){
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget buildContent(String text){
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle().copyWith(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
            ? Color.fromRGBO(34, 76, 164, 1)
            : ThemeData.dark().primaryColor,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n('pages.about.title'),
              style: TextStyle(fontSize: 24)
            )
          ),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [

              buildContent(l10n("pages.about.moreAbout.start")),

              buildHeader(l10n('pages.about.moreAbout.ourMissionTitle')),
              buildContent(l10n("pages.about.moreAbout.ourMissionText")),

              buildHeader(l10n('pages.about.moreAbout.ourPrinciplesTitle')),
              buildContent(l10n('pages.about.moreAbout.ourPrinciplesText'))

            ],
          ),
        ),
      );
    });
  }
}
