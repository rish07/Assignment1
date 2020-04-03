
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/nominee_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_bloc.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';

class CalenderBlocBasedWidget extends StatelessWidget {
  NomineeDetailsBloc bloc;
  Function(DateTime, NomineeDetailsBloc) onDateSelection;
  int age;
  String dob;
  double height;
  Color outlineColor;
  bool isEditable;
  bool isFromProposer;

  CalenderBlocBasedWidget(this.bloc, this.onDateSelection, {this.age, this.dob, this.height = 35.0, this.outlineColor, this.isEditable = true, this.isFromProposer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          border: Border.all(color: (outlineColor !=null) ? outlineColor : Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: InkWell(
        onTap: isEditable ? (){
          _showDatePicker(context, bloc);
        } : null,
        child: Row(
          children: <Widget>[
            Container(
              height: height,
              decoration: BoxDecoration(
                  color: ColorConstants.arogya_plus_quote_number_color,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    S.of(context).dob_title,
                    style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: StreamBuilder<String>(
                  stream: bloc.dobStream,
                  builder: (context, snapshot) {
                    String dob = 'DD/MM/YYYY';
                    if (snapshot.hasData && !TextUtils.isEmpty(snapshot.data)) {
                      dob = snapshot.data;
                    }
                    return Text(
                      dob,
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    );
                  }),
            ),
            SizedBox(
                width: 30,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Image.asset(AssetConstants.ic_calender),
                ))
          ],
        ),
      ),
    );
  }

  _showDatePicker(BuildContext context, NomineeDetailsBloc bloc) async {
    FocusScope.of(context).unfocus();
    DateTime currentDateTime = DateTime.now();
    int startYear = currentDateTime.year;
    if(isFromProposer){
      startYear = startYear - 18;
    }
    int day = currentDateTime.day;
    int month = currentDateTime.month;
    DateTime lastDate = getDateTime(startYear, month-3, day-1);

    DateTime initialDate;
    if (bloc.dob != null && bloc.dob.isNotEmpty) {
      dob = bloc.dob;
      List<String> split = dob.split('/');
      if (split.length > 2) {
        int day = int.parse(split[0]);
        int month = int.parse(split[1]);
        int year = int.parse(split[2]);
        initialDate = getDateTime(year, month, day);
        if(isFromProposer){
          lastDate = getDateTime(startYear, currentDateTime.month, currentDateTime.day);
        }
      }
    } else {
      if(isFromProposer){
        initialDate = getDateTime(startYear, month, day);
        lastDate = getDateTime(startYear, month, day);
      }else {
        initialDate = getDateTime(startYear, month - 3, day - 1);
      }
    }

    DateTime newDateTime = await showRoundedDatePicker(context: context, theme: ThemeData(primarySwatch: Colors.purple),
        initialDate: initialDate,
       // firstDate: getDateTime(startYear - 99, month, day),
        firstDate: getDateTime(startYear - 100, month, day), /// Archanna (24-03-2020)- As per BRD we should allow till 100 years from current date
        lastDate: lastDate,
        borderRadius: 16);
    if(newDateTime != null){
      onDateSelection(newDateTime, bloc);
    }
  }

  getDateTime(int year, int month, int day){
    return DateTime(year, month = month, day = day);
  }
}
