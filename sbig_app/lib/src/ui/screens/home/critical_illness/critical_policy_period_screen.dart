import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insuree_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_insure_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_insure_member_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/calander_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class CriticalIllnessPolicyPeriodScreen extends StatefulWidgetBase {

  static const ROUTE_NAME = "/critical_illness/critical_policy_period_screen";

  final CriticalIllnessModel criticalIllnessModel;

  CriticalIllnessPolicyPeriodScreen(this.criticalIllnessModel);

  @override
  _State createState() => _State();
}

class _State extends State<CriticalIllnessPolicyPeriodScreen>
    with CommonWidget {
  String startDateString = '';
  String endDateString = '';
  int years = 0;
  DateTime currentDate, endDate, selectedStartDate;

  @override
  void initState() {
    years = widget.criticalIllnessModel.timePeriodModel.year;
    currentDate = DateTime.now();
    selectedStartDate = currentDate;
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
                        onClick: (){
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
                        onClick: (){},
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
                    child: QuickFactWidget(StringDescription.quick_fact15)),
              ),
              _showNextButton(),
            ],
          ),
        ));
  }

  _showNextButton() {
    onClick() {
      PolicyTimePeriod policyPeriod = PolicyTimePeriod(startDate: selectedStartDate, endDate: endDate);
      widget.criticalIllnessModel.policyTimePeriod = policyPeriod;
      resetData();

      Navigator.of(context).pushNamed(CriticalInsureMemberDetailsScreen.ROUTE_NAME, arguments: widget.criticalIllnessModel);
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

    int day = currentDate.day;
    int month = currentDate.month;
    int year =currentDate.year;

    DateTime newDateTime = await showRoundedDatePicker(context: context,
        initialDate: selectedStartDate,
        firstDate: currentDate,
        lastDate: DateTime(currentDate.year, month = 12, day = 31),
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
    PolicyCoverMemberModel policyMembers = widget.criticalIllnessModel.policyCoverMemberModel;
      MemberDetailsModel memberDetailsModel  = policyMembers.memberDetailsModel;
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

      policyMembers.memberDetailsModel = memberDetailsModel;

      widget.criticalIllnessModel.policyCoverMemberModel = policyMembers;
  }
}
