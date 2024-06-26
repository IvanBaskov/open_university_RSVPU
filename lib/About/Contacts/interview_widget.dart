import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';

class InterviewWidget extends StatefulWidget {
  final String data;
  const InterviewWidget({super.key, required this.data});

  @override
  State<InterviewWidget> createState() => _InterviewWidgetState();
}

class _InterviewWidgetState extends State<InterviewWidget> with L10n{
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle().copyWith(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark ? Color.fromRGBO(34, 76, 164, 1) : ThemeData.dark().primaryColor,
          elevation: 0,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n('pages.about.interviewTitle'), style: TextStyle(fontSize: 24))),
        ),
        body: Center(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: HtmlWidget(widget.data)
              )
            ],
          ),
        ),
      );
    });
  }
}
