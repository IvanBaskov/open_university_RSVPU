import 'dart:developer';
class NewsDto {

  final int? id;
  final String? link;
  final String? name;
  final String? subtitle;
  final String? newsTags;
  final String? imgLink;
  final String? publishDate;
  final int? views;
  final List<dynamic>? content;

  NewsDto({
    this.id,
    this.link,
    this.name,
    this.subtitle,
    this.newsTags,
    this.imgLink,
    this.publishDate,
    this.views,
    this.content
  });

  NewsDto fromJson(Map<String,dynamic> json){
    return NewsDto(
      id: int.parse(json['id'].toString()),
      link: json['link'],
      name: json['name'],
      subtitle: json['subtitle'],
      newsTags: json['news_tags'],
      imgLink: json['img_link'],
      publishDate: json['publish_date'],
      views: int.parse(json['views'].toString()),
      content: json['content']
    );
  }

}