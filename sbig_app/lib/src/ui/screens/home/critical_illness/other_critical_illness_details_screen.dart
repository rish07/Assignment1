import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/other_insurance_company_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/other_critical_illness_details_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

typedef OnDelete();

class OtherCriticalIllnessDetailsScreen extends StatefulWidget {
  OtherCriticalIllnessDetailsModel otherCriticalIllnessDetailsModel;
 final state = new _OtherCriticalIllnessDetailsScreenState();
 final OtherInsuranceCompanyList otherInsuranceCompanyList;
  //final OnDelete onDelete;
  Function(OtherCriticalIllnessDetailsModel) onDelete;
  static const FROM_START_DATE = 1;
  static const FROM_END_DATE = 2;
  bool isRemoveButtonEnabled = false;
  int index=0;

  OtherCriticalIllnessDetailsScreen({Key key, this.otherCriticalIllnessDetailsModel, this.onDelete,this.isRemoveButtonEnabled,this.index, this.otherInsuranceCompanyList}) : super(key: key);

  @override
  _OtherCriticalIllnessDetailsScreenState createState() => state;

  bool isValid() => this.state.validate();
}

class _OtherCriticalIllnessDetailsScreenState
    extends State<OtherCriticalIllnessDetailsScreen> with CommonWidget {
  String startDateString = '',_startDate="";
  String endDateString = '',_endDate="";
  int years = 0;
  DateTime currentDate, endDate, selectedStartDate;
  int selectedRadio;
  String errorText = "";
  bool onSubmit;
  String dropDownValue;
  bool isStartDateError =false , isEndDateError=false;
  final form = GlobalKey<FormState>();
  OtherCriticalIllnessDetailsModel otherCriticalIllnessDetailsModel;
  OtherInsuranceCompanyList otherInsuranceCompanyList;

  @override
  void initState() {
    // years = widget.criticalIllnessModel.timePeriodModel.year;
    years = 1;
    currentDate = DateTime.now();
    selectedStartDate = currentDate;
    int month = currentDate.month;
    int day = currentDate.day - 1;
    endDate = DateTime(DateTime.now().year + years, month = month, day = day);
    // startDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(currentDate);
    //endDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(endDate);

    selectedRadio=1;
    otherCriticalIllnessDetailsModel=widget.otherCriticalIllnessDetailsModel;
    otherInsuranceCompanyList=widget.otherInsuranceCompanyList;
   // dropDownValue = (otherInsuranceCompanyList?.data!=null || otherInsuranceCompanyList.data.length>1)?otherInsuranceCompanyList.data[0]:null;
    dropDownValue = null;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('STATE INDEX  : ${widget.index}');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('widget.otherCriticalIllnessDetailsModel ${widget.otherCriticalIllnessDetailsModel}');
    print('widget.ondelete ${widget.onDelete}');
    return Form(
      key: form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(widget.isRemoveButtonEnabled)
            SizedBox(
              height: 40.0,
            ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Individual Policy'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    letterSpacing: 1.0,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              if(widget.isRemoveButtonEnabled)
                SizedBox(
                  height: 25.0,
                  child: OutlineButton(
                    onPressed:(){
                      setState(() {
                        widget.onDelete(otherCriticalIllnessDetailsModel);
                      });
                    },
                    borderSide: BorderSide(
                        color: ColorConstants
                            .greyish_77),
                    child: Text(
                      S.of(context).remove.toUpperCase(),
                      style: TextStyle(
                          color: ColorConstants
                              .disco,
                          fontSize: 12.0,
                          letterSpacing: 1.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: radioButton(),
          ),
          SizedBox(
            height: 5,
          ),
          insuranceDropDownWidget(),
          SizedBox(
            height: 5,
          ),
          policyNumber(),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              _showDatePicker(
                  context, OtherCriticalIllnessDetailsScreen.FROM_START_DATE);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              (startDateString == null || startDateString.isEmpty)
                                  ? S.of(context).policy_start_date
                                  : startDateString,
                              style: TextStyle(
                                  fontSize: 14,
                                  //fontWeight: FontWeight.w700,
                                  color: ColorConstants.slate_grey),
                            ),
                          ),
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
                  if(isStartDateError)
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text('start date please',style: TextStyle(color: Colors.red,fontSize: 11),),
                  )
                ],
              )
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {
              _showDatePicker(
                  context, OtherCriticalIllnessDetailsScreen.FROM_END_DATE);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              (endDateString == null || endDateString.isEmpty)
                                  ? S.of(context).policy_end_date
                                  : endDateString,
                              style: TextStyle(
                                  fontSize: 14,
                                  // fontWeight: FontWeight.w700,
                                  color: ColorConstants.slate_grey),
                            ),
                          ),
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
                  if(isEndDateError)
                  Padding(
                    padding: EdgeInsets.only(top: 1.0),
                    child: Text('end date please',style: TextStyle(color: Colors.red,fontSize: 11),),
                  )
                ],
              )
            ),
          ),
          SizedBox(
            height: 5,
          ),
          sumInsuredValue(),
          SizedBox(
            height: 5,
          ),
          specialConditions(),
        ],
      ),
    );
  }

  Widget insuranceDropDownWidget() {
    List<String> repolist = otherInsuranceCompanyList.data ?? [];
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(width: 1, color: Colors.black38),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: DropdownButton<String>(
                  icon: Icon(
                    Icons.expand_more,
                    color: Colors.grey[700],
                  ),
                  underline: Text(''),
                  isExpanded: true,
                  hint: Text(S.of(context).select_insurance_repo),
                  value: dropDownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropDownValue = newValue;
                      //widget.otherCriticalIllnessDetails.insuranceCompany=dropDownValue;
                    });
                  },
                  items: repolist.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14.0),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDatePicker(BuildContext context, int isFrom) async {
    FocusScope.of(context).unfocus();

    DateTime presentDate = DateTime.now();
    FocusScope.of(context).unfocus();
    int currentYear = presentDate.year;
    int day = presentDate.day;
    int month = presentDate.month;
    int firstYear = currentYear, lastYear = currentYear;

    if (isFrom == OtherCriticalIllnessDetailsScreen.FROM_START_DATE) {
      Future.delayed(Duration(milliseconds: 200), () async {
        int startYear = currentYear;
        firstYear = startYear - 100;
        lastYear = startYear;
        DateTime initialDate;
        initialDate = DateTime(startYear, month = month, day = day);
        DateTime newDateTime = await showRoundedDatePicker(
            theme: ThemeData(primarySwatch: Colors.purple),
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(firstYear, month, day + 1),
            lastDate: DateTime(lastYear, month, day),
            //lastDate: DateTime(lastYear, month = month, day = (isAdult!= null ? (isAdult ? day-1 : day -2) : day)),
            borderRadius: 16);

        if (newDateTime != null) {
          selectedStartDate = newDateTime;
          int day = newDateTime.day - 1;
          int month = newDateTime.month;
         // int year = selectedStartDate.year + years;
          endDate = DateTime(
              selectedStartDate.year + years, month = month, day = day);
          setState(() {
            isStartDateError=false;
            isEndDateError=false;
            startDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
            _startDate=CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
            endDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(endDate);
            _endDate = CommonUtil.instance.convertTo_yyyy_MM_dd(endDate);
          });
        }
      });
    } else {
      Future.delayed(Duration(milliseconds: 200), () async {
        int startYear = currentYear;
        firstYear = startYear - 1;
        lastYear = startYear + 50;
        DateTime initialDate;
        initialDate = DateTime(startYear, month = month, day = day);
        DateTime newDateTime = await showRoundedDatePicker(
            theme: ThemeData(primarySwatch: Colors.purple),
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(firstYear, month, day + 1),
            lastDate: DateTime(lastYear, month, day),
            //lastDate: DateTime(lastYear, month = month, day = (isAdult!= null ? (isAdult ? day-1 : day -2) : day)),
            borderRadius: 16);

        if (newDateTime != null) {
          selectedStartDate = newDateTime;
          int day = newDateTime.day;
          int month = newDateTime.month;
         // int year = selectedStartDate.year + years;
          endDate = DateTime(newDateTime.year, month = month, day = day);
          setState(() {
            //startDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
            isEndDateError=false;
            endDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(endDate);
          });
        }
      });
    }

    /*DateTime newDateTime = await showRoundedDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: currentDate,
        lastDate: DateTime(currentDate.year, month = month, day = day),
        borderRadius: 16);*/
  }

  Widget policyNumber() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 8.0),
      child: Stack(
        children: <Widget>[
          Theme(
            data: new ThemeData(
              primaryColor: ColorConstants.text_field_blue,
              // changes the under line colour
              primaryColorDark: ColorConstants.text_field_blue,
              accentColor: ColorConstants.text_field_blue,
            ),
            child: TextFormField(
              //onChanged: (value)=> form.currentState.validate(),
              onSaved: (value) =>
                  widget.otherCriticalIllnessDetailsModel.policyNumber=value,
              validator: (value)=>_validatePolicyNumber(value),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(50),
              ],
              style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 23.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 10.0),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.shiraz),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
                labelText: S.of(context).policy_no.toUpperCase(),
                // errorText: errorText,
                //errorStyle: TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sumInsuredValue() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 8.0),
      child: Stack(
        children: <Widget>[
          Theme(
            data: new ThemeData(
              primaryColor: ColorConstants.text_field_blue,
              primaryColorDark: ColorConstants.text_field_blue,
              accentColor: ColorConstants.text_field_blue,
            ),
            child: TextFormField(
             // onChanged: (value)=>form.currentState.validate(),
              onSaved: (value) => widget.otherCriticalIllnessDetailsModel.sumInsured=value,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) => _validateSumInsured(value),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(7),
              ],
              style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 23.0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 10.0),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.shiraz),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
                labelText: S.of(context).sum_insured_title.toUpperCase(),
                labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget specialConditions() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 20.0, top: 20.0, right: 20.0, bottom: 8.0),
      child: Stack(
        children: <Widget>[
          Theme(
            data: new ThemeData(
              primaryColor: ColorConstants.text_field_blue,
              primaryColorDark: ColorConstants.text_field_blue,
              accentColor: ColorConstants.text_field_blue,
            ),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onSaved: (value) => widget.otherCriticalIllnessDetailsModel.specialConditions=value,
              keyboardType: TextInputType.text,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[ A-Za-z0-9,./-]")),
                LengthLimitingTextInputFormatter(50),
              ],
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 10.0),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.fuchsia_pink),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
                labelText: S.of(context).special_conditions_title.toUpperCase(),
                // errorText: errorText,
                //errorStyle: TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget radioButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: selectedRadio,
              activeColor: ColorConstants.disco,
              onChanged: (value) {
                setSelectedRadioValue(value);
              },
            ),
            Text(S.of(context).previous_policy_title,softWrap: true,),
            Radio(
              value: 2,
              groupValue: selectedRadio,
              activeColor: ColorConstants.disco,
              onChanged: (value) {
                setSelectedRadioValue(value);
              },
            ),
            Text(S.of(context).concurrent_policy_title,softWrap: true,),
          ],
        ),
      ],
    );
  }

  /// changing the Radio button selection Value
  setSelectedRadioValue(int value) {
    setState(() {
      selectedRadio = value;

    });
  }

  ///Policy number Validation
  _validatePolicyNumber(String policyNumber) {
    if (!TextUtils.isEmpty(policyNumber)) {
      return null;
    } else {
      return S.of(context).invalid_policy_number;
    }
  }

  /// Sum insured Validation
  _validateSumInsured(String sumInsured) {
    if (!TextUtils.isEmpty(sumInsured)) {
      if (int.parse(sumInsured) > 5000000) {
        return S.of(context).invalid_sum_insured;
      }
      return null;
    } else {
      return S.of(context).invalid_sum_insured;
    }
  }

  /// form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    if(_startDate == null || _startDate.isEmpty){
     setState(() {
       valid=false;
       isStartDateError=true;
     });
    }else if(_endDate==null || _endDate.isEmpty){
      setState(() {
        valid=false;
        isEndDateError=true;
      });
    }
    widget.otherCriticalIllnessDetailsModel.startDate=_startDate;
    widget.otherCriticalIllnessDetailsModel.endDate=_endDate;
    if (selectedRadio == 1) {
      widget.otherCriticalIllnessDetailsModel.isPreviousPolicy = true;
     // widget.otherCriticalIllnessDetailsModel.policyType=S.of(context).previous_policy_title;
      widget.otherCriticalIllnessDetailsModel.policyType=S.of(context).previous_title;
    } else {
      widget.otherCriticalIllnessDetailsModel.isPreviousPolicy = false;
     // widget.otherCriticalIllnessDetailsModel.policyType=S.of(context).concurrent_policy_title;
      widget.otherCriticalIllnessDetailsModel.policyType=S.of(context).concurrent_title;
    }
    widget.otherCriticalIllnessDetailsModel.insuranceCompany=dropDownValue;
    return valid;
  }
}
