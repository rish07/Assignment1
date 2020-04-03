import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import '../../../../../controllers/blocs/home/claim_intimation/health_claim_intimation/health_claim_bloc.dart';


class DateOfDischargeHealthClaimWidget extends StatelessWidget {

  HealthClaimBloc bloc = HealthClaimBloc();
  Function(DateTime, HealthClaimBloc) onDateSelection;
  int age;
  String dob;
  double height;
  Color outlineColor;
  bool isEditable;
  bool isFromProposer;


  DateOfDischargeHealthClaimWidget(this.bloc, this.onDateSelection,
      {this.age,
      this.dob,
      this.height = 35.0,
      this.outlineColor,
      this.isEditable = true,
      this.isFromProposer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          border: Border.all(
              color:Colors.grey[500]
                  /*(outlineColor != null) ? outlineColor : Colors.grey.shade300*/),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: InkWell(
        onTap: isEditable
            ? () {
                _showDatePicker(context, bloc);
              }
            : null,

        child: Row(
          children: <Widget>[
            Container(
              height: height,
              decoration: BoxDecoration(
                  color: ColorConstants.arogya_plus_quote_number_color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0))),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: StreamBuilder<String>(
                  stream: bloc.dateOfDischargeStream,
                  builder: (context, snapshot) {
                    String dob = 'DD/MM/YYYY';

                    if (snapshot.hasData && !TextUtils.isEmpty(snapshot.data)) {
                      dob = snapshot.data;
                    }
                    return Text(
                      dob,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
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

  _showDatePicker(BuildContext context, HealthClaimBloc bloc) async {
    print("discharge");
    print(dob);
    FocusScope.of(context).unfocus();
    DateTime currentDateTime = DateTime.now();
    int startYear = currentDateTime.year;
    if (isFromProposer) {
      startYear = startYear - 18;
    }
    int day = currentDateTime.day;
    int month = currentDateTime.month;
    DateTime lastDate = getDateTime(startYear , month+3 , day );

    DateTime initialDate;
    if (bloc.dateOfDischarge != null && bloc.dateOfDischarge.isNotEmpty) {
      dob = bloc.dateOfDischarge;
      List<String> split = dob.split('/');
      if (split.length > 2) {
        int day = int.parse(split[0]);
        int month = int.parse(split[1]);
        int year = int.parse(split[2]);
        initialDate = getDateTime(year, month, day);
      }
    } else {
      if (isFromProposer) {
        initialDate = getDateTime(startYear, month, day);
        lastDate = getDateTime(startYear, month, day);
      } else {
        initialDate = getDateTime(startYear, month , day );
      }
    }

    DateTime newDateTime = await showRoundedDatePicker(
        context: context,
        theme: ThemeData(primarySwatch: Colors.purple),
        initialDate: initialDate,
        firstDate: getDateTime(startYear , month-3, day),
        lastDate: lastDate,
        borderRadius: 16);
    if (newDateTime != null) {
      onDateSelection(newDateTime, bloc);
    }
  }

  getDateTime(int year, int month, int day) {
    return DateTime(year, month = month, day = day);
  }
}
