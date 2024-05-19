import 'package:flutter/material.dart';
import 'package:open_university_rsvpu/helpers/helpers.dart';

class SettingsDropdown extends StatelessWidget with L10n {

  IconData? icon;
  String? text;
  String? hint;
  dynamic value;
  Map<String, dynamic> valueList;
  Function(dynamic)? onChanged;


  SettingsDropdown({
    required this.icon,
    required this.text,
    required this.hint,
    required this.value,
    required this.valueList,
    required this.onChanged,
  });

  List<DropdownMenuItem> buildDropdownItem(Map<String, dynamic> data){
    List<DropdownMenuItem> items = [];

    data.forEach((key, value) {
      items.add(DropdownMenuItem(
        value: value,
        child: Text(l10n(key))
      ));
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity(vertical: -4, horizontal: -4),
      title: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.screenshot),
          ),

          Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text ?? '',
                  style: TextStyle(fontSize: 16)
                ),
              )
          )

        ],
      ),
      trailing: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.1),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: DropdownButton(
              hint: Text(hint ?? ''),
              value: value,
              underline: Container(),
              items: buildDropdownItem(valueList),
              onChanged: onChanged
          ),
        ),
      ),
    );
  }
}