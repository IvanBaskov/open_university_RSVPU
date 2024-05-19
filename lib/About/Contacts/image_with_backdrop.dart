import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/helpers/dto/persons.dart';

class ImageWithBackdrop extends StatelessWidget{

  PersonDto person;
  Size size;

  ImageWithBackdrop({super.key, required this.person, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
          alignment: Alignment.center,
          children: [

            Opacity(
                opacity: 0.5,
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image(image: AssetImage('images/Loading_icon.gif')),
                  imageUrl: "https://ouimg.koralex.fun/${person.imgId}.png",
                  fit: BoxFit.contain,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  alignment: Alignment.topCenter,
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                )
            ),

            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Image(image: AssetImage('images/Loading_icon.gif')),
                  imageUrl: "https://ouimg.koralex.fun/${person.imgId}.png",
                  fit: BoxFit.contain,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  alignment: Alignment.topCenter,
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                ),
              ),
            )

          ]
      ),
    );
  }
}