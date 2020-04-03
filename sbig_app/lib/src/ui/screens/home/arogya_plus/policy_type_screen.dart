//import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
//import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
//import 'package:sbig_app/src/resources/string_description.dart';
//import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
//import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_covered_required_screen.dart';
//import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
//import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
//import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
//import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
//
//class PolicyTypeScreen extends StatefulWidgetBase {
//  static const INDIVIDUAL = 0;
//  static const FAMILY_FLOATER = 1;
//  static const FAMILY_INDIVIDUAL = 2;
//
//  static const ROUTE_NAME = "/arogya_plus/policy_type_screen";
//
//  PersonalDetails personalDetails;
//
//  PolicyTypeScreen(this.personalDetails);
//
//  @override
//  _State createState() => _State();
//}
//
//class _State extends State<PolicyTypeScreen> with CommonWidget {
//  List<GeneralListModel> _policyTypes;
//  int _selectedIndex = -1;
//
//  @override
//  void didChangeDependencies() {
//    _policyTypes = [
//      GeneralListModel(
//        title: S.of(context).individual_title,
//        subTitle: S.of(context).individual_subtitle,
//        moreInfo: S.of(context).individual_more_info,
//        icon: AssetConstants.ic_individual,
//        activeIcon: AssetConstants.ic_individual_white,
//      ),
//      GeneralListModel(
//          title: S.of(context).family_floater_title,
//          subTitle: S.of(context).family_floater_subtitle,
//          moreInfo: S.of(context).family_floater_more_info,
//          icon: AssetConstants.ic_family_floater,
//          activeIcon: AssetConstants.ic_family_floater_white),
//      GeneralListModel(
//          title: S.of(context).family_individual_title,
//          subTitle: S.of(context).family_individual_subtitle,
//          moreInfo: S.of(context).family_individual_more_info,
//          icon: AssetConstants.ic_family_individual,
//          activeIcon: AssetConstants.ic_family_individual_white),
//    ];
//    super.didChangeDependencies();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        backgroundColor: ColorConstants.arogya_plus_bg_color,
//        appBar: getAppBar(context, S.of(context).insured_details.toUpperCase()),
//        body: SafeArea(
//          child: Stack(
//            children: <Widget>[
//              Container(
//                  margin: EdgeInsets.all(20.0),
//                  child: Column(
//                    children: <Widget>[
//                      Expanded(
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text(
//                              S.of(context).policy_type_title,
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 28,
//                                  fontFamily: StringConstants.SWISS_LIGHT),
//                            ),
//                            SizedBox(
//                              height: 20,
//                            ),
//                            ListView.builder(
//                                physics: const NeverScrollableScrollPhysics(),
//                                shrinkWrap: true,
//                                itemCount: _policyTypes.length,
//                                itemBuilder: (BuildContext context, int index) {
//                                  return buildListItem(
//                                      _policyTypes[index], index);
//                                }),
//                            SizedBox(
//                              height: 8,
//                            ),
//                            //QuickFactWidget(StringDescription.quick_fact1),
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/cover_member/cover_member_api_provider.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/cover_member_model.dart';
////                      SizedBox(
////                        height: 100,
////                      ),
//                          ],
//                        ),
//                      ),
//                      QuickFactWidget(StringDescription.quick_fact1)
//                    ],
//                  )),
//
//              //if(_selectedIndex != -1) _showSubmitButton(),
//            ],
//          ),
//        ));
//  }
//
//  Widget buildListItem(GeneralListModel policyType, int index) {
//    bool isSelected = (_selectedIndex == index);
//
//    return Padding(
//      padding: const EdgeInsets.only(bottom: 8.0),
//      child: InkResponse(
//        onTap: () {
//          setState(() {
//            _selectedIndex = index;
//            _navigate(index);
//          });
//        },
//        child: Stack(
//          children: <Widget>[
//            Card(
//                elevation: 5.0,
//                shape: RoundedRectangleBorder(
//                  borderRadius: borderRadius(topRight: 40.0),
//                ),
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: borderRadius(topRight: 40.0),
//                    gradient: isSelected
//                        ? LinearGradient(
//                        begin: Alignment.topRight,
//                        end: Alignment.bottomLeft,
//                        colors: [
//                          ColorConstants.policy_type_gradient_color1,
//                          ColorConstants.policy_type_gradient_color2
//                        ])
//                        : null,
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: Row(
//                      children: <Widget>[
//                        SizedBox(
//                            height: 40,
//                            width: 40,
//                            child: isSelected
//                                ? Image.asset(policyType.activeIcon)
//                                : Image.asset(policyType.icon)),
//                        SizedBox(
//                          width: 15,
//                        ),
//                        Expanded(
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              SizedBox(
//                                height: 10,
//                              ),
//                              Text(
//                                policyType.title,
//                                style: TextStyle(
//                                    fontSize: 16,
//                                    fontWeight: FontWeight.w800,
//                                    color: isSelected
//                                        ? Colors.white
//                                        : policyType.titleColor),
//                              ),
//                              SizedBox(
//                                height: 10,
//                              ),
//                              Text(
//                                policyType.subTitle,
//                                softWrap: true,
//                                style: TextStyle(
//                                    fontSize: 14,
//                                    fontWeight: FontWeight.w500,
//                                    color: isSelected
//                                        ? Colors.white
//                                        : Colors.grey[800]),
//                              ),
//                              SizedBox(
//                                height: 5,
//                              ),
//                              Text(
//                                policyType.moreInfo,
//                                softWrap: true,
//                                style: TextStyle(
//                                    fontSize: 12,
//                                    fontWeight: FontWeight.w500,
//                                    color: isSelected
//                                        ? Colors.white
//                                        : ColorConstants.opd_amount_text_color),
//                              ),
//                              SizedBox(
//                                height: 10,
//                              ),
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                  ),
//                )),
//            if (index == 1)
//              Align(
//                alignment: Alignment.topRight,
//                child: Container(
//                  height: 30,
//                  width: 100,
//                  transform: Matrix4.translationValues(0, 16, 0),
//                  child: Align(
//                      alignment: Alignment.centerRight,
//                      child: Image.asset(AssetConstants.ic_preferred)),
//                ),
//              ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  _navigate(int selectedIndex) {
//    List<GeneralListModel> _policyMembers;
//    List<String> _adultAgeList = [for (var i = 18; i <= 65; i += 1) "$i years"];
//    List<String> _childAgeList;
//
//    GeneralListModel child1,
//        child2,
//        child3,
//        child4,
//        father,
//        mother,
//        motherInLaw,
//        fatherInLaw;
//
//    _childAgeList = [for (var i = 2; i <= 23; i += 1) "$i years"];
//    _childAgeList.insert(0, "1 year");
//    _childAgeList.insert(0, "3 months to 1 year");
//
//    _policyMembers = [
//      GeneralListModel(
//          title: S.of(context).self_title,
//          icon: AssetConstants.ic_self,
//          activeIcon: AssetConstants.ic_self_white,
//          memberDetailsModel: MemberDetailsModel(
//              relation: S.of(context).self_title,
//              icon: AssetConstants.ic_self,
//              ageGenderModel: AgeGenderModel(),
//              ageList: _adultAgeList,
//            maritalStatusIsFixed: null,)),
//      GeneralListModel(
//          title: S.of(context).spouse_title,
//          icon: AssetConstants.ic_spouse,
//          activeIcon: AssetConstants.ic_spouse_white,
//          memberDetailsModel: MemberDetailsModel(
//              relation: S.of(context).spouse_title,
//              icon: AssetConstants.ic_spouse,
//              ageGenderModel: AgeGenderModel(),
//              ageList: _adultAgeList,
//              maritalStatusIsFixed: true,
//              isMarried: true)),
//    ];
//
//    child1 = GeneralListModel(
//        title: S.of(context).child1_title,
//        icon: AssetConstants.ic_child,
//        activeIcon: AssetConstants.ic_child_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).child1_title,
//            icon: AssetConstants.ic_child,
//            ageGenderModel: AgeGenderModel(),
//            ageList: _childAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: false));
//    child2 = GeneralListModel(
//        title: S.of(context).child2_title,
//        icon: AssetConstants.ic_child,
//        activeIcon: AssetConstants.ic_child_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).child2_title,
//            icon: AssetConstants.ic_child,
//            ageGenderModel: AgeGenderModel(),
//            ageList: _childAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: false));
//    child3 = GeneralListModel(
//        title: S.of(context).child3_title,
//        icon: AssetConstants.ic_child,
//        activeIcon: AssetConstants.ic_child_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).child3_title,
//            icon: AssetConstants.ic_child,
//            ageGenderModel: AgeGenderModel(),
//            ageList: _childAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: false));
//    child4 = GeneralListModel(
//        title: S.of(context).child4_title,
//        icon: AssetConstants.ic_child,
//        activeIcon: AssetConstants.ic_child_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).child4_title,
//            icon: AssetConstants.ic_child,
//            ageGenderModel: AgeGenderModel(),
//            ageList: _childAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: false));
//
//    father = GeneralListModel(
//        title: S.of(context).father_title,
//        icon: AssetConstants.ic_father,
//        activeIcon: AssetConstants.ic_father_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).father_title,
//            icon: AssetConstants.ic_father,
//            ageGenderModel: AgeGenderModel(defaultGender: "M"),
//            ageList: _adultAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: true));
//    mother = GeneralListModel(
//        title: S.of(context).mother_titile,
//        icon: AssetConstants.ic_mother,
//        activeIcon: AssetConstants.ic_mother_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).mother_titile,
//            icon: AssetConstants.ic_mother,
//            ageGenderModel: AgeGenderModel(defaultGender: "F"),
//            ageList: _adultAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: true));
//    fatherInLaw = GeneralListModel(
//        title: S.of(context).father_in_law_title,
//        icon: AssetConstants.ic_father,
//        activeIcon: AssetConstants.ic_father_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).father_in_law_title,
//            icon: AssetConstants.ic_father,
//            ageGenderModel: AgeGenderModel(defaultGender: "M"),
//            ageList: _adultAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: true));
//    motherInLaw = GeneralListModel(
//        title: S.of(context).mother_in_law_title,
//        icon: AssetConstants.ic_mother,
//        activeIcon: AssetConstants.ic_mother_white,
//        memberDetailsModel: MemberDetailsModel(
//            relation: S.of(context).mother_in_law_title,
//            icon: AssetConstants.ic_mother,
//            ageGenderModel: AgeGenderModel(defaultGender: "F"),
//            ageList: _adultAgeList,
//            maritalStatusIsFixed: true,
//            isMarried: true));
//
//    switch (selectedIndex) {
//      case 0:
//        _policyMembers.add(father);
//        _policyMembers.add(mother);
//        _policyMembers.add(fatherInLaw);
//        _policyMembers.add(motherInLaw);
//        break;
//      case 1:
//        _policyMembers.add(child1);
//        _policyMembers.add(child2);
//        break;
//      case 2:
//        _policyMembers.add(child1);
//        _policyMembers.add(child2);
//        _policyMembers.add(child3);
//        _policyMembers.add(child4);
//        _policyMembers.add(father);
//        _policyMembers.add(mother);
//        _policyMembers.add(fatherInLaw);
//        _policyMembers.add(motherInLaw);
//    }
//
//    Navigator.of(context).pushNamed(PolicyCoveredRequiredScreen.ROUTE_NAME,
//        arguments: PolicyCoveredRequiredScreenArgs(
//            selectedIndex, _policyMembers, widget.personalDetails));
//  }
//
//  _showSubmitButton() {
//    onClick() {
//      _navigate(_selectedIndex);
//    }
//
//    return Container(
//      child: BlackButtonWidget(
//        onClick,
//        S.of(context).get_a_quote_title.toUpperCase(),
//        isNormal: false,
//        padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
//        bottomBgColor: ColorConstants.personal_details_bg_color,
//      ),
//    );
//  }
//}

import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_covered_required_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/policy_cover_member_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class PolicyTypeScreen extends StatefulWidgetBase {

  static const INDIVIDUAL = 0;
  static const FAMILY_FLOATER = 1;
  static const FAMILY_INDIVIDUAL = 2;

  static const ROUTE_NAME = "/arogya_plus/policy_type_screen";

  final PersonalDetails personalDetails;


  PolicyTypeScreen(this.personalDetails,);

  @override
  _State createState() => _State();
}

class _State extends State<PolicyTypeScreen> with CommonWidget {
  List<GeneralListModel> _policyTypes;
  int _selectedIndex = -1;
  int isFrom=-1;

  @override
  void initState() {
    isFrom = widget.personalDetails.isFrom;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    _policyTypes = [
      GeneralListModel(
        title: S.of(context).individual_title,
        subTitle: S.of(context).individual_subtitle,
        moreInfo: S.of(context).individual_more_info,
        icon: AssetConstants.ic_individual,
        activeIcon: AssetConstants.ic_individual_white,
      ),
      GeneralListModel(
          title: S.of(context).family_floater_title,
          subTitle: S.of(context).family_floater_subtitle,
          moreInfo: S.of(context).family_floater_more_info,
          icon: AssetConstants.ic_family_floater,
          activeIcon: AssetConstants.ic_family_floater_white),
      GeneralListModel(
          title: S.of(context).family_individual_title,
          subTitle: S.of(context).family_individual_subtitle,
          moreInfo: S.of(context).family_individual_more_info,
          icon: AssetConstants.ic_family_individual,
          activeIcon: AssetConstants.ic_family_individual_white),
    ];
    super.didChangeDependencies();
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
                        S.of(context).policy_type_title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: StringConstants.EFFRA_LIGHT),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _policyTypes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildListItem(_policyTypes[index], index);
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      QuickFactWidget(StringDescription.quick_fact1),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              //if(_selectedIndex != -1) _showSubmitButton(),
            ],
          ),
        ));
  }

  Widget buildListItem(GeneralListModel policyType, int index) {
    bool isSelected = (_selectedIndex == index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            _navigate(index);
          });
        },
        child: Stack(
          children: <Widget>[
            Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius(topRight: 40.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius(topRight: 40.0),
                    gradient: isSelected
                        ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.policy_type_gradient_color1,
                          ColorConstants.policy_type_gradient_color2
                        ])
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            height: 40,
                            width: 40,
                            child: isSelected
                                ? Image.asset(policyType.activeIcon)
                                : Image.asset(policyType.icon)),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                policyType.title,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : policyType.titleColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                policyType.subTitle,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[800]),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                policyType.moreInfo,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : ColorConstants.opd_amount_text_color),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            if (index == 1 && isFrom == StringConstants.FROM_AROGYA_PLUS)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 30,
                  width: 100,
                  transform: Matrix4.translationValues(0, 16, 0),
                  child: Align(alignment: Alignment.centerRight,child: Image.asset(AssetConstants.ic_preferred)),
                ),
              ),
            if (index == 1 && isFrom != StringConstants.FROM_AROGYA_PLUS)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 50,
                  width: 100,
                  transform: Matrix4.translationValues(10, 10, 0),
                  child: Align(alignment: Alignment.centerRight,child: isSelected ? Image.asset(AssetConstants.ic_recommended_white):Image.asset(AssetConstants.ic_recommended) ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _navigate(int selectedIndex) {
  if(isFrom == StringConstants.FROM_AROGYA_PLUS){
    List<GeneralListModel> _policyMembers;
    List<String> _adultAgeList = [for (var i = 18; i <= 65; i += 1) "$i years"];
    List<String> _childAgeList;

    GeneralListModel child1,
        child2,
        child3,
        child4,
        father,
        mother,
        motherInLaw,
        fatherInLaw;

    _childAgeList = [for (var i = 2; i <= 23; i += 1) "$i years"];
    _childAgeList.insert(0, "1 year");
    _childAgeList.insert(0, "3 months to 1 year");

    _policyMembers = [
      GeneralListModel(
          title: S.of(context).self_title,
          icon: AssetConstants.ic_self,
          activeIcon: AssetConstants.ic_self_white,
          memberDetailsModel: MemberDetailsModel(
              relation: S.of(context).self_title,
              icon: AssetConstants.ic_self,
              ageGenderModel: AgeGenderModel(),
              ageList: _adultAgeList)),
      GeneralListModel(
          title: S.of(context).spouse_title,
          icon: AssetConstants.ic_spouse,
          activeIcon: AssetConstants.ic_spouse_white,
          memberDetailsModel: MemberDetailsModel(
              relation: S.of(context).spouse_title,
              icon: AssetConstants.ic_spouse,
              ageGenderModel: AgeGenderModel(),
              ageList: _adultAgeList,
              maritalStatusIsFixed: true,
              isMarried: true)),
    ];

    child1 = GeneralListModel(
        title: S.of(context).child1_title,
        icon: AssetConstants.ic_child,
        activeIcon: AssetConstants.ic_child_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).child1_title,
            icon: AssetConstants.ic_child,
            ageGenderModel: AgeGenderModel(),
            ageList: _childAgeList,
            maritalStatusIsFixed: true,
            isMarried: false));
    child2 = GeneralListModel(
        title: S.of(context).child2_title,
        icon: AssetConstants.ic_child,
        activeIcon: AssetConstants.ic_child_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).child2_title,
            icon: AssetConstants.ic_child,
            ageGenderModel: AgeGenderModel(),
            ageList: _childAgeList,
            maritalStatusIsFixed: true,
            isMarried: false));
    child3 = GeneralListModel(
        title: S.of(context).child3_title,
        icon: AssetConstants.ic_child,
        activeIcon: AssetConstants.ic_child_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).child3_title,
            icon: AssetConstants.ic_child,
            ageGenderModel: AgeGenderModel(),
            ageList: _childAgeList,
            maritalStatusIsFixed: true,
            isMarried: false));
    child4 = GeneralListModel(
        title: S.of(context).child4_title,
        icon: AssetConstants.ic_child,
        activeIcon: AssetConstants.ic_child_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).child4_title,
            icon: AssetConstants.ic_child,
            ageGenderModel: AgeGenderModel(),
            ageList: _childAgeList,
            maritalStatusIsFixed: true,
            isMarried: false));

    father = GeneralListModel(
        title: S.of(context).father_title,
        icon: AssetConstants.ic_father,
        activeIcon: AssetConstants.ic_father_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).father_title,
            icon: AssetConstants.ic_father,
            ageGenderModel: AgeGenderModel(defaultGender: "M"),
            ageList: _adultAgeList,
            maritalStatusIsFixed: true,
            isMarried: true));
    mother = GeneralListModel(
        title: S.of(context).mother_titile,
        icon: AssetConstants.ic_mother,
        activeIcon: AssetConstants.ic_mother_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).mother_titile,
            icon: AssetConstants.ic_mother,
            ageGenderModel: AgeGenderModel(defaultGender: "F"),
            ageList: _adultAgeList,
            maritalStatusIsFixed: true,
            isMarried: true));
    fatherInLaw = GeneralListModel(
        title: S.of(context).father_in_law_title,
        icon: AssetConstants.ic_father,
        activeIcon: AssetConstants.ic_father_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).father_in_law_title,
            icon: AssetConstants.ic_father,
            ageGenderModel: AgeGenderModel(defaultGender: "M"),
            ageList: _adultAgeList,
            maritalStatusIsFixed: true,
            isMarried: true));
    motherInLaw = GeneralListModel(
        title: S.of(context).mother_in_law_title,
        icon: AssetConstants.ic_mother,
        activeIcon: AssetConstants.ic_mother_white,
        memberDetailsModel: MemberDetailsModel(
            relation: S.of(context).mother_in_law_title,
            icon: AssetConstants.ic_mother,
            ageGenderModel: AgeGenderModel(defaultGender: "F"),
            ageList: _adultAgeList,
            maritalStatusIsFixed: true,
            isMarried: true));

    switch (selectedIndex) {
      case 0:
        _policyMembers.add(father);
        _policyMembers.add(mother);
        _policyMembers.add(fatherInLaw);
        _policyMembers.add(motherInLaw);
        break;
      case 1:
        _policyMembers.add(child1);
        _policyMembers.add(child2);
        break;
      case 2:
        _policyMembers.add(child1);
        _policyMembers.add(child2);
        _policyMembers.add(child3);
        _policyMembers.add(child4);
        _policyMembers.add(father);
        _policyMembers.add(mother);
        _policyMembers.add(fatherInLaw);
        _policyMembers.add(motherInLaw);
    }

    Navigator.of(context).pushNamed(PolicyCoveredRequiredScreen.ROUTE_NAME,
        arguments: PolicyCoveredRequiredScreenArgs(
            selectedIndex, _policyMembers, widget.personalDetails));
  }
  else if(isFrom == StringConstants.FROM_AROGYA_PREMIER){
    _makeCoverMemberApiCall(StringConstants.FROM_AROGYA_PREMIER,policyType: selectedIndex);
  }else{
    _makeCoverMemberApiCall(StringConstants.FROM_AROGYA_TOP_UP,policyType: selectedIndex);
  }
  }

  _makeCoverMemberApiCall(int isFrom ,{int policyType}) async {
    retryIdentifier(int identifier) {
      _makeCoverMemberApiCall(isFrom,policyType: policyType);
    }
    showLoaderDialog(context);
    final response = await CoverMemberApiProvider.getInstance().getCoverMembers(isFrom,policyType: policyType);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      handleApiError(context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      CoverMemberResModel responseModel = response;
      if(isFrom == StringConstants.FROM_AROGYA_TOP_UP){
        Navigator.of(context).pushNamed(ArogyaTopUpCoverMemberScreen.ROUTE_NAME,
            arguments: ArogyaTopupPolicyCoverMemberArguments(widget.personalDetails,responseModel,policyType: policyType));
      }else{
        Navigator.of(context).pushNamed(ArogyaCoverMemberScreen.ROUTE_NAME,
            arguments: ArogyaPolicyCoverMemberArguments(widget.personalDetails,responseModel,policyType: policyType));
      }

    }

  }

  _showSubmitButton() {
    onClick() {
      _navigate(_selectedIndex);
    }

    return Container(
      child: BlackButtonWidget(
        onClick,
        S.of(context).get_a_quote_title.toUpperCase(),
        isNormal: false,
        padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
        bottomBgColor: ColorConstants.personal_details_bg_color,
      ),
    );
  }
}