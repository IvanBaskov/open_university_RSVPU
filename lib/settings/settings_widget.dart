import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/Settings/settings_block_title.dart';
import 'package:open_university_rsvpu/Settings/settings_dropdown.dart';
import 'package:open_university_rsvpu/Settings/settings_switch.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> with SharedPreferencesInstance, L10n {
  var _isVideoWatchedSaving = true;
  var _newsSubscription = true;
  var _videoSubscription = true;
  var _preffedScreenForOpen = 0;

  Map<String, dynamic> preferredScreenNamesList = {
    "pages.about.title": 0,
    "pages.news.title": 1,
    "pages.videos.title": 2,
    "pages.settings.title": 3
  };

  String _versionNumber = "9.9.9";

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionNumber = packageInfo.version.toString();
      });
    });
  }

  void getUserTagsFromOneSignal() {
    OneSignal.shared.getTags().then((tags) {
      if (tags['video'] == "True") {
        setState(() {
          _videoSubscription = true;
        });
      } else {
        setState(() {
          _videoSubscription = false;
        });
      }
      if (tags['news'] == "True") {
        setState(() {
          _newsSubscription = true;
        });
      } else {
        setState(() {
          _newsSubscription = false;
        });
      }
      setSettings("videoSubscription", _videoSubscription);
      setSettings("newsSubscription", _newsSubscription);
    });
  }

  @override
  void initState() {
    super.initState();
    getSettings();
    getVersion();
    getUserTagsFromOneSignal();
  }

  void saveHistorySwitch(bool value) {

    if (_isVideoWatchedSaving != true){
      setSettings("VideoWatchedSaving", !_isVideoWatchedSaving);
      setState(() {
        _isVideoWatchedSaving = !_isVideoWatchedSaving;
      });
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n('pages.settings.warningLabel')),
          content: Text(l10n('pages.settings.warningDisableHistoryDescription')),
          actions: <Widget>[
            MaterialButton(
              child: Text(l10n('pages.settings.warningAgree')),
              onPressed: () {
                clearVideoCache();
                setSettings("VideoWatchedSaving", !_isVideoWatchedSaving);
                setState(() => _isVideoWatchedSaving = !_isVideoWatchedSaving );
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text(l10n('pages.settings.warningCancel')),
              onPressed: () => Navigator.of(context).pop()
            ),
          ],
        );
      },
    );
  }

  void clearHistory() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n('pages.settings.warningLabel')),
          content: Text(l10n('pages.settings.warningClearHistoryDescription')),
          actions: <Widget>[
            MaterialButton(
              child: Text(l10n('pages.settings.warningAgree')),
              onPressed: () {
                clearVideoCache();
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child:
              Text(l10n('pages.settings.warningCancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearCache() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n('pages.settings.warningLabel')),
          content: Text(l10n('pages.settings.warningClearCacheDescription')),
          actions: <Widget>[
            MaterialButton(
              child: Text(l10n('pages.settings.warningAgree')),
              onPressed: () {
                clearDataCache();
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child:
              Text(l10n('pages.settings.warningClearCacheCancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getSettings() async {
    setState(() {

      prefs.getInt("preffed_screen_for_open") != null
        ? _preffedScreenForOpen = prefs.getInt("preffed_screen_for_open")!
        : prefs.setInt("preffed_screen_for_open", 0);

      prefs.getBool("VideoWatchedSaving") != null
        ? _isVideoWatchedSaving = prefs.getBool("VideoWatchedSaving")!
        : prefs.setBool("VideoWatchedSaving", true);

      prefs.getBool("newsSubscription") != null
        ? _newsSubscription = prefs.getBool("newsSubscription")!
        : prefs.setBool("newsSubscription", true);

      prefs.getBool("videoSubscription") != null
        ? _videoSubscription = prefs.getBool("videoSubscription")!
        : prefs.setBool("videoSubscription", true);

    });
  }

  void clearVideoCache() async {
    final list = prefs.getKeys().where((String key) =>
      key.toString().toLowerCase().contains("lections_") ||
      key.toString().toLowerCase().contains("stories_")).toList();

    for (int i = 0; i < list.length; i++) {
      prefs.remove(list[i]);
    }

  }

  void clearDataCache() async {
    final Directory tempDir = await getTemporaryDirectory();
    final Directory libCacheDir = Directory("${tempDir.path}/libCachedImageData");

    await libCacheDir.delete(recursive: true);

    final list = prefs.getKeys().where((String key) =>
      key.toString().toLowerCase().contains("news_output") ||
      key.toString().toLowerCase().contains("stories_output") ||
      key.toString().toLowerCase().contains("lections_output") ||
      key.toString().toLowerCase().contains("persons_output")).toList();

    for (int i = 0; i < list.length; i++) {
      prefs.remove(list[i]);
    }

  }

  void setSettings(id, value) async {
    switch (value.runtimeType) {
      case bool:
        prefs.setBool(id, value);
        break;
      case int:
        prefs.setInt(id, value);
        break;
      case String:
        prefs.setString(id, value);
        break;
      case double:
        prefs.setDouble(id, value);
        break;
    }
  }

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
            child: Text(l10n('pages.settings.title'), style: TextStyle(fontSize: 24))
          ),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
                child: Image(
                  image: AssetImage('images/Logo.png'),
                  width: 250,
                  height: 141,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    l10n('pages.settings.title'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  )
                ),
              ),

              SettingsBlockTitle(text: l10n('pages.settings.visualSettings')),

              Divider(),

              SettingsSwitch(
                key: UniqueKey(),
                value: themeNotifier.isDark,
                onChanged: (value) => themeNotifier.isDark = !themeNotifier.isDark,
                icon: themeNotifier.isDark ? Icons.nightlight_round_sharp : Icons.sunny,
                text: l10n('pages.settings.themeTitle')
              ),

              Divider(),

              SettingsDropdown(
                icon: Icons.screenshot,
                text: l10n('pages.settings.preferredScreen'),
                hint: l10n('pages.settings.chooseButton'),
                value: _preffedScreenForOpen,
                valueList: preferredScreenNamesList,
                onChanged: (newVal) {
                  setState(() {
                    _preffedScreenForOpen = newVal!;
                    setSettings("preffed_screen_for_open", newVal);
                  });
                }
              ),

              Divider(),

              SettingsBlockTitle(text: l10n('pages.settings.videoSettingsTitle')),

              Divider(),

              SettingsSwitch(
                key: UniqueKey(),
                value: _isVideoWatchedSaving,
                onChanged: (bool value) => saveHistorySwitch(value),
                icon: _isVideoWatchedSaving ? Icons.videocam : Icons.videocam_off,
                text: l10n("pages.settings.saveVideoHistory")
              ),

              Divider(),

              InkWell(
                onTap: clearHistory,
                child: ListTile(
                  visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                  title: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.sd_storage),
                    ),
                    Expanded(
                        child: Text(l10n('pages.settings.clearHistoryButton'),
                            style: TextStyle(fontSize: 16))),
                  ]),
                ),
              ),

              Divider(),

              InkWell(
                onTap: clearCache,
                child: ListTile(
                  visualDensity:
                      VisualDensity(horizontal: -4, vertical: -4),
                  title: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.newspaper_sharp),
                    ),
                    Expanded(
                        child: Text(l10n('pages.settings.clearCacheButton'),
                      style: TextStyle(fontSize: 16),
                    )),
                  ]),
                ),
              ),

              Divider(),

              SettingsBlockTitle(text: l10n('pages.settings.notificationTitle')),

              Divider(),

              SettingsSwitch(
                key: UniqueKey(),
                value: _newsSubscription,
                onChanged: (bool value) {
                  if (_newsSubscription) {
                    setState(() {
                      _newsSubscription = false;
                      setSettings("newsSubscription", false);
                      OneSignal.shared.sendTag("news", "False");
                    });
                  } else {
                    setState(() {
                      _newsSubscription = true;
                      setSettings("newsSubscription", true);
                      OneSignal.shared.sendTag("news", "True");
                    });
                  }
                },
                icon: Icons.newspaper,
                text: l10n('pages.settings.newNews')
              ),

              Divider(),

              SettingsSwitch(
                key: UniqueKey(),
                value: _videoSubscription,
                onChanged: (bool value) {
                  if (_videoSubscription) {
                    setState(() {
                      _videoSubscription = false;
                      setSettings("videoSubscription", false);
                      OneSignal.shared.sendTag("video", "False");
                    });
                  } else {
                    setState(() {
                      _videoSubscription = true;
                      setSettings("videoSubscription", true);
                      OneSignal.shared.sendTag("video", "True");
                    });
                  }
                },
                icon: Icons.videocam,
                text: l10n('pages.settings.newVideos')
              ),

              Divider(),

              Padding(
                padding: EdgeInsets.only(bottom: 30.0, top: 15.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, left: 8.0, right: 8.0, bottom: 20.0),
                    child: Text(
                      "${l10n('pages.settings.techDataVersion')}: $_versionNumber - ${Platform.isIOS ? "IOS" : "Android"}\n${l10n('pages.settings.techDataUniversityTitle')}\n${DateTime.now().year} г.",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
