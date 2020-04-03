import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_period.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_individual_member_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_insure_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/calander_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import 'arogya_top_up_individual_member_details.dart';

class ArogyaTopUpPolicyPeriodScreen extends StatefulWidgetBase {

  static const ROUTE_NAME = "/arogya_top_up/policy_period_screen";

  final ArogyaTopUpModel arogyaTopUpModel;

  ArogyaTopUpPolicyPeriodScreen(this.arogyaTopUpModel);

  @override
  _PolicyPeriodScreenState createState() => _PolicyPeriodScreenState();
}


class _PolicyPeriodScreenState extends State<ArogyaTopUpPolicyPeriodScreen>
    with CommonWidget {
  String startDateString = '';
  String endDateString = '';
  int years = 0;
  DateTime currentDate, endDate, selectedStartDate;
  List<PolicyCoverMemberModel> policyMembers;

  _PolicyPeriodScreenState({this.policyMembers,});

  @override
  void initState() {
    years = widget.arogyaTopUpModel.selectedTimePeriodModel.year;
    currentDate = DateTime.now();
    selectedStartDate = DateTime.now();
    int month = currentDate.month;
    int day = currentDate.day-1;
    endDate = DateTime(DateTime.now().year + years, month = month, day = day);
    startDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(currentDate);
    endDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(endDate);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(context, S.of(context).insured_details.toUpperCase()),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.of(context).policy_time_period,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: StringConstants.EFFRA_LIGHT),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        S.of(context).start_date.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey[600],
                            letterSpacing: 1,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CalendarWidget(
                        onClick: () {
                          _showDatePicker(context);
                        },
                        titleDate: startDateString,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        S.of(context).end_date.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey[600],
                            letterSpacing: 1,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CalendarWidget(
                        onClick: null,
                        titleDate: endDateString,
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, bottom: 78.0, right: 20.0),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: QuickFactWidget(StringDescription.quick_fact21)),
              ),
              _showNextButton(),
            ],
          ),
        ));
  }

  _showNextButton() {
    onClick() {
      PolicyPeriod policyPeriod = PolicyPeriod(startDate: selectedStartDate, endDate: endDate);
      widget.arogyaTopUpModel.policyPeriod = policyPeriod;
      resetData();
      if(widget.arogyaTopUpModel.policyType.id == PolicyTypeScreen.INDIVIDUAL){
        Navigator.of(context).pushNamed(ArogyaTopUpIndividualMemberDetailsScreen.ROUTE_NAME,
            arguments: widget.arogyaTopUpModel);
      }else {
        Navigator.of(context).pushNamed(ArogyaTopUpInsureDetailsScreen.ROUTE_NAME,
            arguments: widget.arogyaTopUpModel);
      }

    }

    return Container(
      child: BlackButtonWidget(
        onClick,
        S.of(context).next.toUpperCase(),
        isNormal: false,
        padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
        bottomBgColor: ColorConstants.personal_details_bg_color,
      ),
    );
  }

  _showDatePicker(BuildContext context) async {

    FocusScope.of(context).unfocus();

    int day = currentDate.day + 29;
    int month = currentDate.month;

    DateTime newDateTime = await showRoundedDatePicker(context: context,
        initialDate: selectedStartDate,
        firstDate: currentDate,
        lastDate: DateTime(currentDate.year, month = month, day = day),
        borderRadius: 16);

    if (newDateTime != null) {
      selectedStartDate = newDateTime;
      int day = newDateTime.day - 1;
      int month = newDateTime.month;
      int year = selectedStartDate.year+years;
      endDate = DateTime(selectedStartDate.year+years, month =  month, day = day);
      setState(() {
        startDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
        endDateString = CommonUtil.instance.convertTo_dd_MM_yyyy(endDate);
      });
    }
  }

  resetData() async{
    List<PolicyCoverMemberModel> policyMembers = widget.arogyaTopUpModel.policyMembers;
    for(int i = 0; i < policyMembers.length; i++){
      MemberDetailsModel memberDetailsModel  = policyMembers[i].memberDetailsModel;
      memberDetailsModel.firstName = null;
      memberDetailsModel.lastName = null;
      if(memberDetailsModel.relation.compareTo("Self") == 0) {
        memberDetailsModel.isMarried = null;
      }
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
      ageGenderModel.dateTime = null;
      ageGenderModel.dob = null;
      ageGenderModel.dob_yyyy_mm_dd = null;

      memberDetailsModel.ageGenderModel = ageGenderModel;

      policyMembers[i].memberDetailsModel = memberDetailsModel;
    }

    widget.arogyaTopUpModel.policyMembers = policyMembers;
  }


}
