import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/Videos/single_video_widget.dart';
import 'package:open_university_rsvpu/Videos/video_image.dart';
import 'package:open_university_rsvpu/helpers/dto/videos.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/helpers/api_service.dart';

class VideoListWidget extends StatefulWidget {
  final String type;
  const VideoListWidget({super.key, required this.type});

  @override
  State<VideoListWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> with AutomaticKeepAliveClientMixin<VideoListWidget>, SharedPreferencesInstance, L10n {
  List<VideoDto> videos = [];

  final _savedPosition = List.filled(999, 0);
  var _isVideoStorySaved = true;

  bool isLoad = true;

  void fetchDataPersons() async {
    ApiService().getVideos(widget.type).listen((event) {
      videos = event;
    }, onError: (error) {
      isLoad = false;
    }).onDone(() {
      setState(() {
        isLoad = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDataPersons();
  }

  Future onRefresh() async {
    setState(() {
      fetchDataPersons();
    });
  }

  void getData(id) async {
    setState(() {
      if (prefs.getInt("${widget.type}_${id.toString()}") != null) {
        _savedPosition[id] = prefs.getInt("${widget.type}_${id.toString()}")!;
      } else {
        _savedPosition[id] = 0;
      }
      if (prefs.getBool("VideoWatchedSaving") != null) {
        _isVideoStorySaved = prefs.getBool("VideoWatchedSaving")!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        body: Center(
          child: RefreshIndicator(
            color: Color.fromRGBO(34, 76, 164, 1),
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Card(
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleVideoWidget(video: videos[index]))),
                    child: Column(
                      children: [
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VideoImage(
                                duration: videos[index].duration ?? '',
                                imgLink: videos[index].imgLink ?? '',
                                isVideoStorySaved: _isVideoStorySaved,
                                savedPosition: _savedPosition[index],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  videos[index].name != "" && videos[index].name != null
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8, top: 5, bottom: 5),
                                          child: Text(
                                            videos[index].name ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              overflow: TextOverflow.clip,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                  videos[index].desc != "" && videos[index].desc != null
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 8, bottom: 5),
                                          child: Text(
                                            videos[index].desc ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      )
                                    : Container()
                                ],
                              )
                            ]
                          )
                        ),
                      ],
                    ),
                  )
                );
              },
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
