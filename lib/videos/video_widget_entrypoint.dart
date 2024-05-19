import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/Videos/video_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';

class VideoWidgetMain extends StatelessWidget with L10n {
  const VideoWidgetMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle().copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white
            ),
            leadingWidth: 40,
            leading: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(RsvpuIconClass.universityLogo, color: Colors.white),
            ),
            foregroundColor: Colors.white,
            backgroundColor: !themeNotifier.isDark
              ? Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n('pages.videos.title'), style: TextStyle(fontSize: 24))
            ),
            elevation: 0,
          ),
          body: VideoWidget());
    });
  }
}

class VideoWidget extends StatelessWidget with L10n {
  const VideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle().copyWith(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white),
            backgroundColor: !themeNotifier.isDark
              ? Color.fromRGBO(34, 76, 164, 1)
              : ThemeData.dark().primaryColor,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  tabs: [
                    Tab(text: l10n('pages.videos.lectionsTitle')),
                    Tab(text: l10n('pages.videos.storiesTitle')),
                  ],
                  indicatorColor: Colors.blueAccent,
                )
              ],
            ),
          ),
          body: TabBarView(
            children: const [
              VideoListWidget(type: "lections"),
              VideoListWidget(type: "stories")
            ],
          ),
        ),
      );
    });
  }
}
