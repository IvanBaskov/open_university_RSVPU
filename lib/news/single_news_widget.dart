import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/News/single_news_content.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:open_university_rsvpu/helpers/dto/news.dart';

import 'news_image.dart';

class SingleNewsWidgetNew extends StatelessWidget with L10n {
  final NewsDto news;

  const SingleNewsWidgetNew({Key? key, required this.news}) : super(key: key);

  void _onShare({required BuildContext context, required String shareText, required String shareSubject}) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      shareText,
      subject: shareSubject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
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
          title: Text(
            l10n('pages.news.singleNews.title'),
            style: TextStyle(fontSize: 24),
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
            ? Color.fromRGBO(34, 76, 164, 1)
            : ThemeData.dark().primaryColor,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () => _onShare(
                  context: context,
                  shareText: "${l10n('pages.news.singleNews.shareLeading')}: ${news.link}",
                  shareSubject: "${l10n('pages.news.singleNews.shareLeading')}: ${news.link}"
                ),
                child: Icon(Icons.share),
              ),
            )
          ],
        ),
        body: ListView(
          children: [

            NewsImage(link: news.imgLink ?? ''),

            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              child: Row(
                children: [

                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "${l10n('pages.news.views')}: ${news.views}",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.left
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "${l10n('pages.news.publishDate')}: ${news.publishDate}",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.right
                      ),
                    ),
                  ),

                ],
              ),
            ),

            news.name != "" && news.name != null
              ? Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 10, right: 5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      news.name ?? '',
                      locale: Locale("ru", "RU"),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(),

            news.subtitle != "" && news.subtitle != null
              ? Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      news.subtitle ?? '',
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                      textAlign: TextAlign.center
                    ),
                  ),
                )
              : Container(),

            news.newsTags != "" && news.newsTags != null
              ? Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      news.newsTags ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      softWrap: true,
                      textAlign: TextAlign.left
                    ),
                  )
                )
              : Container(),

            Divider(),

            SingleNewsContent(content: news.content ?? [])
          ]
        )
      );
    });
  }
}
