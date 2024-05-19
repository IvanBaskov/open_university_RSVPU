import 'package:flutter/material.dart';

class SettingsSwitch extends StatefulWidget {

  Function(bool) onChanged;
  IconData icon;
  String? text;
  bool value;

  SettingsSwitch({
    super.key,
    required this.value,
    required this.icon,
    required this.text,
    required this.onChanged
  });


  @override
  State<StatefulWidget> createState() => SettingsSwitchState();

}

class SettingsSwitchState extends State<SettingsSwitch> {

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      value: widget.value,
      onChanged: widget.onChanged,
      title: Row(
        children: [

          Padding(padding: EdgeInsets.only(right: 12), child: Icon(widget.icon)),

          Expanded(child: Text(widget.text ?? '', style: TextStyle(fontSize: 16))),

        ],
      ),
    );
  }
}