import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/controllers/blocs/singup_signin/signup_signin_bloc.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_type_list_model.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../statefulwidget_base.dart';


class PolicyDetailsCalenderWidget extends StatelessWidget {
  SingupSigninBloc bloc;
  Function(DateTime) onDateSelection;
  String dob;
  double height;
  Color outlineColor;
  PolicyTypesListModel selectedPolicyModel;

  PolicyDetailsCalenderWidget(this.bloc, this.onDateSelection, {this.dob, this.height = 35.0, this.outlineColor, this.selectedPolicyModel});
  int navigationId;

  @override
  Widget build(BuildContext context) {

    //navigationId == 1 means DOB option, 2 means start date

    navigationId = selectedPolicyModel != null ? selectedPolicyModel.navigateId : 1;

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
            Visibility(
              visible: (navigationId == 1),
              child: Container(
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
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: StreamBuilder<String>(
                  stream: bloc.dobStream,
                  builder: (context, snapshot) {
                    String dob = (navigationId == 1) ? 'DD/MM/YYYY': 'POLICY START DATE';
                    if (snapshot.hasData && !TextUtils.isEmpty(snapshot.data)) {
                      dob = snapshot.data;
                    }
                    return Text(
                      dob,
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[500]),
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

  _showDatePicker(BuildContext context, SingupSigninBloc bloc) {
    DateTime presentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    int currentYear = presentDate.year;
    int day = presentDate.day;
    int month = presentDate.month;
    int firstYear = currentYear, lastYear = currentYear;

    try {
      Future.delayed(Duration(milliseconds: 200), () async{
        int startYear = currentYear-18;
        firstYear = currentYear - 100;
        lastYear = startYear;

        DateTime initialDate;
        if(navigationId == 1){
          initialDate = DateTime(startYear, month, day);
        }else{
          initialDate = presentDate;
        }
        if (bloc.dob != null && bloc.dob.isNotEmpty) {
          dob = bloc.dob;
          List<String> split = dob.split('/');
          if (split.length > 2) {
            int day = int.parse(split[0]);
            int month = int.parse(split[1]);
            int year = int.parse(split[2]);
            initialDate = DateTime(year, month = month, day = day);
          }
        }

        print(initialDate.toString());
        print(DateTime(firstYear, month, day-365));
        print(DateTime(lastYear, month, day+65));

        DateTime newDateTime;
        if(navigationId == 1) {
          newDateTime = await showRoundedDatePicker(context: context,
              initialDate: initialDate,
              firstDate: DateTime(firstYear, month = month, day = day),
              lastDate: DateTime(lastYear, month, day),
              borderRadius: 16);
        }else{
          newDateTime = await showRoundedDatePicker(context: context,
              initialDate: initialDate,
              firstDate: DateTime(presentDate.year, month, day-365),
              lastDate: DateTime(presentDate.year, month, day+60),
              borderRadius: 16);
        }
        onDateSelection(newDateTime);
      });
    } catch (e, s) {
      print(s);
    }
  }
}
