import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/helpers/dto/dto.dart';

import '../helpers/helpers.dart';

class VideoImage extends StatelessWidget {

  String duration;
  String imgLink;
  bool isVideoStorySaved;
  int savedPosition;

  VideoImage({
    required this.duration,
    required this.imgLink,
    required this.isVideoStorySaved,
    required this.savedPosition,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 10.0,
      height: (MediaQuery.of(context).size.width - 10.0) / 16 * 9,
      child: Stack(
        children: [
          CachedNetworkImage(
            placeholder: (context, url) =>
                Image(
                    image: AssetImage(
                        'images/Loading_icon.gif')),
            imageUrl: imgLink ?? '',
            fit: BoxFit.cover,
            width: double.maxFinite,
            height: double.maxFinite,
            alignment: Alignment.topCenter,
            fadeInDuration:
            Duration(milliseconds: 0),
            fadeOutDuration:
            Duration(milliseconds: 0),
          ),
          Padding(
              padding: EdgeInsets.only(
                  right: 12.0, bottom: 6.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.7),
                      borderRadius:
                      BorderRadius.circular(
                          10)),
                  constraints: BoxConstraints(
                    maxWidth: 300.0,
                    minWidth: 30.0,
                  ),
                  child: Wrap(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.all(
                            4.0),
                        child: Text(
                            isVideoStorySaved
                                ? TimeHelpers.doTimeFromString(savedPosition.toString()) + (duration ?? '')
                                : "",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            )
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

}