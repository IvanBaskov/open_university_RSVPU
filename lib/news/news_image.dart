import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget{

  String link;

  NewsImage({required this.link});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 10.0,
      height: (MediaQuery.of(context).size.width - 10.0) / 16 * 9,
      child: CachedNetworkImage(
        placeholder: (context, url) => Image(image: AssetImage('images/Loading_icon.gif')),
        imageUrl: link,
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        fadeInDuration: Duration(milliseconds: 0),
        fadeOutDuration: Duration(milliseconds: 0),
      ),
    );
  }

}