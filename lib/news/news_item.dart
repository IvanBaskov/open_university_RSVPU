import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/News/news_image.dart';
import 'package:open_university_rsvpu/News/single_news_widget.dart';
import 'package:open_university_rsvpu/helpers/dto/news.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';

class NewsItem extends StatefulWidget{

  NewsDto news;

  NewsItem({super.key, required this.news});

  @override
  State<StatefulWidget> createState() => NewsItemState();
}

class NewsItemState extends State<NewsItem> with L10n{

  late NewsDto news;

  @override
  void initState() {
    news = widget.news;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleNewsWidgetNew(news: news))),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                NewsImage(link: news.imgLink ?? ''),

                news.newsTags != "" && news.newsTags != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                      child: Text(
                        news.newsTags!,
                        style: TextStyle(fontSize: 14, overflow: TextOverflow.clip, color: Colors.grey),
                      ),
                    )
                  : Container(),

                news.name != "" && news.name != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                      child: Text(
                        news.name!,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, overflow: TextOverflow.ellipsis),
                      ),
                    )
                  : Container(),

                news.subtitle != "" && news.subtitle != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                      child: Text(
                        news.subtitle!,
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : Container(),

                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "${l10n('pages.news.views')}: ${news.views}",
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "${l10n('pages.news.publishDate')}: ${news.publishDate}",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
        )
      ),
    );
  }

}