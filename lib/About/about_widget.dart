import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:open_university_rsvpu/Tech/rsvpu_icon_class_icons.dart';
import 'package:open_university_rsvpu/Tech/ThemeProvider/model_theme.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';
import 'project_text/about_project.dart';
import 'contacts/contact_widget.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key});

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> with L10n {

  Widget buildPageButton({required Widget route, required IconData icon, required String text}){
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => route)),
      child: Column(
        children: [
          ListTile(
              title: Text(text),
              leading: Icon(icon),
              visualDensity:
              VisualDensity(vertical: -4, horizontal: -4),
              trailing: Icon(Icons.arrow_forward_ios, size: 15.0)),
        ],
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
          leadingWidth: 40,
          leading: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(RsvpuIconClass.universityLogo, color: Colors.white),
          ),
          foregroundColor: Colors.white,
          backgroundColor: !themeNotifier.isDark
            ? Color.fromRGBO(34, 76, 164, 1)
            : ThemeData.dark().primaryColor,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n('pages.about.title'),
              style: TextStyle(fontSize: 24)
            )
          ),
          elevation: 0,
        ),
        body: Center(
          child: ListView(
            children: [

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 10,
                      minWidth: 30.0,
                    ),
                    child: Wrap(
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Image(image: AssetImage('images/Front_page_screen_project_logo.png')),
                        )
                      ],
                    ),
                  ),
                )
              ),

              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    l10n('title'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  )
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  l10n('pages.about.description'),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16)
                ),
              ),

              Divider(),

              buildPageButton(
                route: AboutProjectWidget(),
                text: l10n('pages.about.showMoreButton'),
                icon: Icons.text_snippet
              ),

              Divider(),

              buildPageButton(
                route: ContactWidgetNew(),
                icon: Icons.people,
                text: l10n('pages.about.showTeachersButton')
              ),

              Divider()
            ],
          )
        ),
      );
    });
  }
}
