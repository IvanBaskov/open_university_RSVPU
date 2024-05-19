import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_university_rsvpu/Videos/video_image.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helpers/dto/videos.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';

class SingleVideoWidget extends StatefulWidget {
  final VideoDto video;

  const SingleVideoWidget({
    Key? key, required this.video
  }) : super(key: key);

  @override
  State<SingleVideoWidget> createState() => _SingleVideoWidgetState();
}

class _SingleVideoWidgetState extends State<SingleVideoWidget> with AutomaticKeepAliveClientMixin<SingleVideoWidget>, SharedPreferencesInstance, L10n {
  final GlobalKey _betterPlayerKey = GlobalKey();

  late int? _currentPosition;
  late int _savedPosition = 0;

  final _savedAnotherPosition = List.filled(999, 0);

  late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;

  bool _isVideoStorySaving = true;

  @override
  void initState() {
    super.initState();
    getData();
    Map<String, String> resolutions = {};

    for (final item in widget.video.resolutions ?? []) {
      resolutions.addAll({ "${item.toString()}p": "${widget.video.videoLink}/${item.toString()}.mp4" });
    }

    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "${widget.video.videoLink}/${widget.video.resolutions?.last.toString()}.mp4",
      videoExtension: "mp4",
      resolutions: resolutions,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: widget.video.name,
        author: l10n('title'),
        imageUrl: widget.video.imgLink,
        activityName: "MainActivity",
      ),
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
        minBufferMs: 50000,
        maxBufferMs: 13107200,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
    );

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSubtitles: false,
          enableAudioTracks: false,
          enableQualities: true,
          enablePlaybackSpeed: true,
          showControlsOnInitialize: false,
          enableOverflowMenu: true),
      translations: [
        BetterPlayerTranslations(
          languageCode: l10n('pages.videos.betterPlayerTranslations.languageCode'),
          generalDefaultError: l10n('pages.videos.betterPlayerTranslations.generalDefaultError'),
          generalNone: l10n('pages.videos.betterPlayerTranslations.generalNone'),
          generalDefault: l10n('pages.videos.betterPlayerTranslations.generalDefault'),
          generalRetry: l10n('pages.videos.betterPlayerTranslations.generalRetry'),
          playlistLoadingNextVideo: l10n('pages.videos.betterPlayerTranslations.playlistLoadingNextVideo'),
          controlsLive: l10n('pages.videos.betterPlayerTranslations.controlsLive'),
          controlsNextVideoIn: l10n('pages.videos.betterPlayerTranslations.controlsNextVideoIn'),
          overflowMenuPlaybackSpeed: l10n('pages.videos.betterPlayerTranslations.overflowMenuPlaybackSpeed'),
          overflowMenuSubtitles: l10n('pages.videos.betterPlayerTranslations.overflowMenuSubtitles'),
          overflowMenuQuality: l10n('pages.videos.betterPlayerTranslations.overflowMenuQuality'),
        )
      ],
      autoPlay: true,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft
      ],
      allowedScreenSleep: false,
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration, betterPlayerDataSource: _betterPlayerDataSource);

    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType.name == "initialized") {
        _betterPlayerController.play().then((_) => _betterPlayerController
          .seekTo(Duration(seconds: _savedPosition))
          .then((_) => {
            _betterPlayerController.play().then((_) => {
              _betterPlayerController
                .pause()
                .then((_) => { _betterPlayerController.play() })
              })
          })
        );
      }

      if (event.betterPlayerEventType.name == "openFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fitHeight);
      }

      if (event.betterPlayerEventType.name == "hideFullscreen") {
        _betterPlayerController.setOverriddenFit(BoxFit.fill);
      }

      if (event.betterPlayerEventType.name == "progress") {
        if (_isVideoStorySaving == true) {
          setState(() {
            _currentPosition = _betterPlayerController.videoPlayerController?.value.position.inSeconds;
            saveData(_currentPosition);
          });
        }
      }
    });

    _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
  }

  void saveData(data) async {
    await prefs.setInt("${widget.video.typeOfVideo}_${widget.video.id.toString()}", data);
  }

  void getData() async {
    setState(() {
      if (prefs.getInt("${widget.video.typeOfVideo}_${widget.video.id.toString()}") != null) {
        _savedPosition = prefs.getInt("${widget.video.typeOfVideo}_${widget.video.id.toString()}")!;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaving = prefs.getBool("VideoWatchedSaving")!;
      }
    });
  }

  void getAnotherData(id) async {
    setState(() {
      if (prefs.getInt("${widget.video.typeOfVideo}_${id.toString()}") != null) {
        _savedAnotherPosition[id] = prefs.getInt("${widget.video.typeOfVideo}_${id.toString()}")!;
      } else {
        _savedAnotherPosition[id] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      _betterPlayerController.setBetterPlayerControlsConfiguration(
        BetterPlayerControlsConfiguration(
          enableSubtitles: false,
          enableAudioTracks: false,
          enableQualities: true,
          enablePlaybackSpeed: true,
          showControlsOnInitialize: false,
          enableOverflowMenu: true,
          overflowMenuIconsColor: !themeNotifier.isDark
            ? Colors.black
            : Colors.white,
          overflowModalColor: !themeNotifier.isDark
            ? Colors.white
            : ThemeData.dark().primaryColor,
          overflowModalTextColor: !themeNotifier.isDark
            ? Colors.black
            : Colors.white
        )
      );

      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle().copyWith(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white
          ),
          title: Text(l10n('pages.videos.title')),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
            ? Color.fromRGBO(34, 76, 164, 1)
            : ThemeData.dark().primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 16 * 9,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                    controller: _betterPlayerController,
                    key: _betterPlayerKey,
                  ),
                )
              ),
              Expanded(
                child: ListView(
                  children: [

                    widget.video.name != "" && widget.video.name != null
                      ? Padding(
                        padding: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                        child: Text(
                          widget.video.name ?? '',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                      : Container(),

                    widget.video.desc != "" && widget.video.desc != null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
                              child: Text(
                                widget.video.desc ?? '',
                                style: TextStyle(fontSize: 16,),
                              ),
                            ),
                        )
                        : Container(),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0, right: 10.0, left: 10.0, bottom: 10.0),
                        child: Text(
                          widget.video.typeOfVideo == "lections"
                            ? '${l10n('pages.videos.moreFromLections')}: '
                            : '${l10n('pages.videos.moreFromStories')}: ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                    ListView.builder(
                      itemCount: widget.video.dataOfVideo?.length ?? 0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['id'] == widget.video.id) {
                          return Container();
                        }

                        var id = 0;

                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['id'] != "" &&
                          widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['id'] != null
                        ) {
                          id = widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['id'];
                        }

                        getAnotherData(id);

                        var name = "";
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['title'] != "" &&
                          widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['title'] != null
                        ) {
                          name = widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['title'];
                        }

                        var desc = "";
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['description'] != null) {
                          desc = widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['description'];
                        }

                        var imgLink = "";
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['img_id'] != "" &&
                          widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['img_id'] != null
                        ) {
                          imgLink = "https://ouimg.koralex.fun/${widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['img_id']}.png";
                        }
                        var duration = "";
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['duration'] != "" &&
                          widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['duration'] != null
                        ) {
                          duration = widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['duration'];
                        }

                        var videoLink = "";
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['path'] != "" &&
                          widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['path'] != null
                        ) {
                          videoLink = widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['path'];
                        }

                        var resolutions = [];
                        if (widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['resolutions'] != null &&
                          widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['resolutions'] != ""
                        ) {
                          resolutions = widget.video.dataOfVideo?[(widget.video.dataOfVideo ?? []).length - index - 1]['resolutions'];
                        }

                        return InkWell(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => SingleVideoWidget(video: widget.video))
                          ),
                          child: Card(
                            shadowColor: Colors.black,
                            elevation: 20,
                            child: Column(
                              children: [
                                VideoImage(
                                  duration: duration,
                                  imgLink: imgLink,
                                  isVideoStorySaved: _isVideoStorySaving,
                                  savedPosition: _savedAnotherPosition[index],
                                ),
                              ]
                            )
                          )
                        );
                      }
                    )
                  ]
                )
              )
            ]
          )
        )
      );
    }
  );
}

  @override
  bool get wantKeepAlive => true;
}
