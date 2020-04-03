import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/utilities/custom_drop_down.dart';

import '../../../statefulwidget_base.dart';

class DropDownWidget extends StatefulWidget {
  String title;
  List<String> list;
  Function(String, int) onSelection;
  String initialValue;

  DropDownWidget(this.title, this.list, this.onSelection, this.initialValue) {
    if(initialValue != null && !list.contains(initialValue)) {
      initialValue = null;
    }
  }

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {

  //String value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
            width: 1, color: Colors.grey[500]),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: CustomDropdownButton<String>(
          icon: Icon(
            Icons.expand_more,
            color: Colors.black,
          ),
          underline: Text(''),
          isExpanded: true,
          hint: Text(widget.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.grey[500]),),
          value: widget.initialValue,
          onChanged: (String newValue) {
            setState(() {
              widget.initialValue = newValue;
            });
            widget.onSelection(newValue, 1);
          },
          items: _dropDownMenuItems(widget.list),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownMenuItems(List<String> strItems) {
    List<DropdownMenuItem<String>> _ddl = [];
    strItems.forEach((String s) {
      _ddl.add(DropdownMenuItem(
        value: s,
        child: Text(s, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0, color: Colors.black),),
      ));
    });

    return _ddl;
  }

}
