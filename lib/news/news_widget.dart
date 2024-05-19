import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/News/news_item.dart';
import 'package:open_university_rsvpu/News/single_news_widget.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/helpers/api_service.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_university_rsvpu/helpers/dto/news.dart';

class NewsWidgetNew extends StatefulWidget {
  const NewsWidgetNew({Key? key}) : super(key: key);

  @override
  State<NewsWidgetNew> createState() => _WithNewsWidgetNewState();
}

class _WithNewsWidgetNewState extends State<NewsWidgetNew> with AutomaticKeepAliveClientMixin<NewsWidgetNew>, SharedPreferencesInstance, L10n{

  List<NewsDto> news = [];
  List<NewsDto> newsFiltered = [];

  String _searchValue = '';

  bool isLoad = true;

  @override
  void initState() {
    super.initState();
    fetchDataNews();
  }

  void fetchDataNews() {
    ApiService().getNews().listen((event) {
      news = event;
    }, onError: (error) {
      isLoad = false;
    }).onDone(() {
      setState(() {
        isLoad = false;
      });
    });
  }

  Future refresh() async {
    setState(() {
      fetchDataNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_searchValue != "") {
      newsFiltered.clear();
      for (int i = 0; i < news.length; i++) {
        if (news[i].name.toString().toLowerCase().contains(_searchValue.toLowerCase()) ||
          news[i].subtitle.toString().toLowerCase().contains(_searchValue.toLowerCase()) ||
          news[i].newsTags.toString().toLowerCase().contains(_searchValue.toLowerCase())
        ) {
          newsFiltered.add(news[i]);
        }
      }
    } else {
      newsFiltered.clear();

      for (int i = 0; i < news.length; i++) {
        newsFiltered.add(news[i]);
      }

    }

    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: EasySearchBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Icon(RsvpuIconClass.universityLogo, color: Colors.white),
          ),
          systemOverlayStyle: SystemUiOverlayStyle().copyWith(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n('pages.news.title'), style: TextStyle(fontSize: 24))
          ),
          onSearch: (value) => setState(() => _searchValue = value),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
            ? Color.fromRGBO(34, 76, 164, 1)
            : ThemeData.dark().primaryColor,
        ),
        body: Center(
          child: RefreshIndicator(
            onRefresh: refresh,
            color: Color.fromRGBO(34, 76, 164, 1),
            child: ListView.builder(
              itemCount: newsFiltered.length,
              itemBuilder: (context, index) {
                return NewsItem(news: newsFiltered[index]);
              }
            )
          )
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
