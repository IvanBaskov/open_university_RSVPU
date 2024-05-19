import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/About/Contacts/image_with_backdrop.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/helpers/dto/persons.dart';
import 'package:open_university_rsvpu/About/Contacts/interview_widget.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';

class SinglePersonWidget extends StatelessWidget with L10n {

  final PersonDto person;

  const SinglePersonWidget({Key? key, required this.person}) : super(key: key);

  Widget buildTextRow(String key, String text){
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text.rich(TextSpan(
          style: TextStyle(fontSize: 15),
          children: [
            TextSpan(
              text: "${l10n('pages.about.aboutPerson.$key')}:",
              style: TextStyle(fontWeight: FontWeight.bold)
            ),
            TextSpan(text: " $text"),
          ]
        )),
      )
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
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark ? Color.fromRGBO(34, 76, 164, 1) : ThemeData.dark().primaryColor,
          title: Text(""),
        ),
        body: ListView(
          children: [
            Container(
              height: 300,
              width: 150,
              margin: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)
                ),
              ),
              child: ImageWithBackdrop(person: person, size: Size(100, 150)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  person.firstName != "" && person.middleName != "" && person.lastName != ""
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${person.lastName} ${person.firstName} ${person.middleName}",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      )
                    : Container(),

                  person.jobTitle != "" && person.jobTitle != null
                    ? buildTextRow('post', person.jobTitle!)
                    : Container(),

                  person.academDegree != "" && person.academDegree != null
                    ? buildTextRow('academicDegree', person.academDegree!)
                    : Container(),

                  person.academTitle != "" && person.academTitle != null
                    ? buildTextRow('academicTitle', person.academTitle!)
                    : Container(),

                  person.awards != "" && person.awards != null
                    ? buildTextRow('awards', person.awards!)
                    : Container(),

                  person.interview != ""
                    ? Column(
                        children: [
                          Divider(),

                          ListTile(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => InterviewWidget(data: person.interview ?? ''))),
                            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
                            title: Row(
                              children: [
                                Icon(Icons.textsms, size: 15.0),
                                Expanded(
                                  child: Text(
                                    "    ${l10n('pages.about.aboutPerson.interviewButton')}",
                                    style: TextStyle(fontSize: 15)
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, size: 15.0),
                          ),

                          Divider()
                        ],
                      )
                    : Container(),

                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
