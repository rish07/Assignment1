import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/othetr_critical_illness_question_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';


class CriticalInsureDetailsScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/critical_illness/critical_inusree_details_screen";
  final CriticalIllnessModel criticalIllnessModel;

  CriticalInsureDetailsScreen(this.criticalIllnessModel);

  @override
  _CriticalInsureDetailsScreenWidgetState createState() => _CriticalInsureDetailsScreenWidgetState();
}

class _CriticalInsureDetailsScreenWidgetState
    extends State<CriticalInsureDetailsScreen> with CommonWidget {
  int _selectedIndex, _previousSelectedIndex = -1;
  bool isAlertVisible = false;
  Set<int> selectedMembers = Set();
  List<PolicyCoverMemberModel> policyMembers = [];
  PolicyCoverMemberModel policyCoverMemberModel;
  String errorMessage = '';
  bool isNextButtonEnable = true;


  @override
  void initState() {
    policyCoverMemberModel = widget.criticalIllnessModel.policyCoverMemberModel;
    policyMembers.add(widget.criticalIllnessModel.policyCoverMemberModel);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _onSelected(int index) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(
          context,
          S.of(context).insured_details.toUpperCase(),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      S.of(context).insured_details,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontFamily: StringConstants.EFFRA_LIGHT),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,

                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(policyMembers.length, (index) {
                        return buildListItem(policyMembers[index], index);
                      }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: policyMembers.length < 3
                              ? ScreenUtil.getInstance(context).screenHeightDp /
                                      2 -
                                  180
                              : 0.0),
                      child: QuickFactWidget(StringDescription.quick_fact16),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 25.0 + 8.0 - 20.0, left: 12.0, right: 12.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AlertWidget(errorMessage, isAlertVisible ? 168 : 0),
                ),
              ),
              Align(alignment: Alignment.bottomCenter, child: _showButton()),
            ],
          ),
        ));
  }

  Widget _showButton() {
    onClick() {
      setState(() {
        Navigator.of(context).pushNamed(
            OtherCriticalIllnessQuestionScreen.ROUTE_NAME,
            arguments: widget.criticalIllnessModel);
      });
    }

    return EnableDisableButtonWidget(
      (isNextButtonEnable) ? onClick : null,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.arogya_plus_bg_color,
    );
  }

  _onUpdate(MemberDetailsModel memberDetailsModel) {
    policyMembers[_selectedIndex].memberDetailsModel = memberDetailsModel;
    setState(() {
      selectedMembers.add(_selectedIndex);
      _updateButton();
    });
  }

  _updateButton() {
    if (selectedMembers.length != policyMembers.length) {
      isNextButtonEnable = false;
    } else {
      isNextButtonEnable = true;
    }
  }

  Widget buildListItem(PolicyCoverMemberModel policyMember, int index) {

    //bool isSelected = (selectedMembers.contains(index));
    bool isSelected = true;
    print('policyMember.activeIcon ${policyMember.activeIcon}');

    return InkResponse(
      onTap: () {
        _onSelected(index);
      },
      child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius(topRight: 40.0),
          ),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: borderRadius(topRight: 40.0),
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                          ColorConstants.east_bay,
                          ColorConstants.disco,
                          ColorConstants.disco
                        ])
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 5.0, bottom: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: isSelected
                          ? (policyMember.activeIcon.contains('assets')||policyMember.activeIcon.length==0)?Image.asset(AssetConstants.ic_self_white):Image(image: NetworkImage(UrlConstants.ICON + policyMember.activeIcon),)
                          : (policyMember.icon.contains('assets')||policyMember.icon.length==0)?Image.asset(AssetConstants.ic_self):Image(image: NetworkImage(UrlConstants.ICON + policyMember.icon),)),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    policyMember.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : policyMember.titleColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  memberDetailslWidget(index),

                ],
              ),
            ),
          )),
    );
  }

  Widget memberDetailslWidget(int index) {
    String ageGenderString = '';
    String tempData = "Name, DOB";
    String tempData2 = "Height, Weight";
   MemberDetailsModel memberDetailsModel =
        policyMembers[index].memberDetailsModel;

  //  bool isSelected = (selectedMembers.contains(index));
    bool isSelected = true;

    String martialStatus = '';
    String fullName = '';
    // making as per design
    String dob = 'Martial Status';
    String height_inch = '', height_feet = '';
    String weight = '';
    String heightWeight = '';

    if (memberDetailsModel != null) {
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;

      if (!TextUtils.isEmpty(ageGenderModel.gender) ||
          ageGenderModel.age != null) {
        ageGenderString = "${ageGenderModel.gender}, ${ageGenderModel.age}";
      }

      // print(memberDetailsModel.firstName);
      if (!TextUtils.isEmpty(memberDetailsModel.firstName) &&
          !TextUtils.isEmpty(memberDetailsModel.lastName)) {
        fullName =
            memberDetailsModel.firstName + " " + memberDetailsModel.lastName;
        martialStatus = "Unmarrried";
        if (null != memberDetailsModel.isMarried &&
            memberDetailsModel.isMarried) {
          martialStatus = "Married";
        }
        if (null != memberDetailsModel.heightInInch && memberDetailsModel.heightInInch != -1) {
          height_inch = (memberDetailsModel.heightInInch.toString().isEmpty)
              ? ''
              : '\'' + memberDetailsModel.heightInInch.toString();
          print('height_inch $height_inch');
        }
        if (null != memberDetailsModel.heightInFeet) {
          height_feet = memberDetailsModel.heightInFeet.toString();
        }
        if (null != memberDetailsModel.weight) {
          weight = memberDetailsModel.weight.toString() + ' kgs';
        }
        ageGenderString = ageGenderString + ", $martialStatus";
        dob = ageGenderModel.dob;
        heightWeight = "$height_feet $height_inch Feets, $weight";

        tempData = null;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(ageGenderString,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12)),
        Text(
          !TextUtils.isEmpty(fullName) ? fullName : tempData,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[500],
              fontSize: 12),
        ),
        Text(dob,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[500],
                fontSize: 12)),
        Text(!TextUtils.isEmpty(heightWeight) ? heightWeight : tempData2,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[500],
                fontSize: 12)),
      ],
    );
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
