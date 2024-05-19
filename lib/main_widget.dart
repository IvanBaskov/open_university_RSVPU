import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'News/news_widget.dart';
import 'Videos/video_widget_entrypoint.dart';
import 'About/about_widget.dart';
import 'Settings/settings_widget.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _WithMainWidgetState();
}

class _WithMainWidgetState extends State<MainWidget> with SharedPreferencesInstance, L10n{
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getSettings();
  }

  static final List<Widget> _pages = [
    AboutWidget(),
    NewsWidgetNew(),
    VideoWidgetMain(),
    SettingsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getSettings() async {
    setState(() {
      if (prefs.getInt("preffed_screen_for_open") != null) {
        _selectedIndex = prefs.getInt("preffed_screen_for_open")!;
      } else {
        prefs.setInt("preffed_screen_for_open", 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [

          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(RsvpuIconClass.universityLogo),
            ),
            label: l10n('bottomBar.about'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: l10n('bottomBar.news'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: l10n('bottomBar.video'),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: l10n('bottomBar.settings'),
          ),

        ]
      ),
    );
  }
}
