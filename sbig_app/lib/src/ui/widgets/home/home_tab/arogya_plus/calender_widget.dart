import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_bloc.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';

class CalenderWidget extends StatelessWidget {
  InsureeDetailsBloc bloc;
  Function(DateTime, InsureeDetailsBloc) onDateSelection;
  int age;
  String dob;
  double height;
  Color outlineColor;
  bool isAdult;

  CalenderWidget(this.bloc, this.onDateSelection, {this.age, this.dob, this.height = 35.0, this.outlineColor, this.isAdult});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          border: Border.all(color: (outlineColor !=null) ? outlineColor : Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: InkWell(
        onTap: (){
          _showDatePicker(context, bloc);
        },
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

  _showDatePicker(BuildContext context, InsureeDetailsBloc bloc) {
    DateTime presentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    int currentYear = presentDate.year;
    int day = presentDate.day;
    //if age is 0 means user has selected 3months to 1 year options
    int month = age == 0 ? presentDate.month - 3 : presentDate.month;
    int firstYear = currentYear, lastYear = currentYear;
//    if(isAdult != null){
//      if(isAdult) {
//        firstYear = currentYear - 56;
//        lastYear = currentYear - 18;
//      }else{
//        firstYear = currentYear - 24;
//        lastYear = currentYear - 0;
//      }
//    }


    try {
      Future.delayed(Duration(milliseconds: 200), () async{
        int startYear = currentYear - age;
        firstYear = startYear-1;
        lastYear = startYear;
        DateTime initialDate;
        if (bloc.dob != null && bloc.dob.isNotEmpty) {
          dob = bloc.dob;
          List<String> split = dob.split('/');
          if (split.length > 2) {
            int day = int.parse(split[0]);
            int month = int.parse(split[1]);
            int year = int.parse(split[2]);
            initialDate = DateTime(year, month = month, day = day);
          }
        } else {
          initialDate = DateTime(startYear, month = month, day = day);
        }

        DateTime newDateTime = await showRoundedDatePicker(context: context,
            initialDate: initialDate,
            firstDate: DateTime(firstYear, age == 0 ? month+3 : month, day+1),
            lastDate: DateTime(lastYear, month, day),
            //lastDate: DateTime(lastYear, month = month, day = (isAdult!= null ? (isAdult ? day-1 : day -2) : day)),
            borderRadius: 16);
        onDateSelection(newDateTime, bloc);
      });
    } catch (e, s) {
      print(s);
    }

  }
}
