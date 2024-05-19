import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:open_university_rsvpu/About/Contacts/image_with_backdrop.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:open_university_rsvpu/helpers/dto/persons.dart';
import 'package:open_university_rsvpu/About/Contacts/single_person_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/api_service.dart';

class ContactWidgetNew extends StatefulWidget {
  const ContactWidgetNew({Key? key}) : super(key: key);

  @override
  State<ContactWidgetNew> createState() => _WithContactWidgetNewState();
}

class _WithContactWidgetNewState extends State<ContactWidgetNew> with AutomaticKeepAliveClientMixin<ContactWidgetNew>, SharedPreferencesInstance, L10n {

  List<PersonDto> persons = [];
  List<PersonDto> personsFiltered = [];

  String _searchValue = '';

  bool isLoad = true;

  void fetchDataPersons() async {
    ApiService().getPersons().listen((event) {
      persons = event;
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

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ModelTheme themeNotifier, child) {
      super.build(context);

      if (_searchValue != "") {
        personsFiltered.clear();
        for (int i = 0; i < persons.length; i++) {
          if (persons[i].lastName.toString().toLowerCase().contains(_searchValue.toLowerCase()) ||
            persons[i].middleName.toString().toLowerCase().contains(_searchValue.toLowerCase()) ||
            persons[i].firstName.toString().toLowerCase().contains(_searchValue.toLowerCase()) ||
            persons[i].jobTitle.toString().toLowerCase().contains(_searchValue.toLowerCase())
          ) {
            personsFiltered.add(persons[i]);
          }
        }
      } else {
        personsFiltered.clear();

        for (int i = 0; i < persons.length; i++) {
          personsFiltered.add(persons[i]);
        }

      }

      return Scaffold(
        appBar: EasySearchBar(
          systemOverlayStyle: SystemUiOverlayStyle().copyWith(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: themeNotifier.isDark ? Colors.black : Colors.white
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
            ? Color.fromRGBO(34, 76, 164, 1)
            : ThemeData.dark().primaryColor,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n('pages.about.personTitle'), style: TextStyle(fontSize: 24))),
          onSearch: (value) {
            setState(() {
              _searchValue = value;
            });
          },
        ),
        body: RefreshIndicator(
          color: Color.fromRGBO(34, 76, 164, 1),
          onRefresh: onRefresh,
          child: Center(
            child: ListView.builder(
              itemCount: personsFiltered.length,
              itemBuilder: (context, index) {
                return Card(
                  shadowColor: Colors.black,
                  elevation: 20,
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SinglePersonWidget(person: persons[index]))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)
                            ),
                          ),
                          child: ImageWithBackdrop(person: persons[index], size: Size(200, 200)),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${persons[index].lastName} ${persons[index].firstName} ${persons[index].middleName}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0, left: 10.0, right: 10.0),
                          child: Text(
                            persons[index].jobTitle ?? '',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        )

                      ],
                    ),
                  ),
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
