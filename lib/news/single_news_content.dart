import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/News/news_image.dart';

class SingleNewsContent extends StatelessWidget{

  List<dynamic> content;

  SingleNewsContent({required this.content});

  @override
  Widget build(BuildContext context) {
    if (content == []) {
      return Container();
    }
    
    return ListView.builder(
      itemCount: content.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        String tag = content[index]['tag'];
        dynamic value = content[index]['value'];

        switch(tag){
          case "p":
            return buildParagraph(text: value);
          case "quote":
            return buildQuote(name: value['name'], text: value['text']);
          case "image":
            return buildImage(context: context, link: value);
          default:
            return Container();
        }

      });
  }

  Widget buildParagraph({required String text}) {

    if (text == ''){
      return Container(padding: EdgeInsets.only(left: 10, right: 10),);
    }

    return Padding(
      padding: EdgeInsets.only(top: 5.0, left: 15.0, right: 15.0, bottom: 5.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        softWrap: true,
        textAlign: TextAlign.justify
      ),
    );

  }

  Widget buildQuote({required String name, required String text}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                text != ""
                  ? Text(
                    text,
                    style: TextStyle(fontSize: 16),
                    softWrap: true,
                    textAlign: TextAlign.justify
                  )
                  : Container(),

                name != ""
                  ? Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "— $name",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          softWrap: true,
                          textAlign: TextAlign.center
                        ),
                      ),
                  )
                  : Container()

              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildImage({required BuildContext context, required String link}) {

    if (link == ""){
      return Container();
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: NewsImage(link: link),
    );

  }
}