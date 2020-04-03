import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/premium_details/premium_bloc.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/sum_insured_and_premium_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/member_details_bottom_sheet_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../home_screen.dart';

class PolicyCoveredRequiredScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_plus/policy_covered_required_screen";

  final PolicyCoveredRequiredScreenArgs args;

  PolicyCoveredRequiredScreen(this.args);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: PolicyCoveredRequiredWidget(args),
      bloc: PremiumBloc(),
    );
  }
}

class PolicyCoveredRequiredWidget extends StatefulWidgetBase {
  final PolicyCoveredRequiredScreenArgs args;

  PolicyCoveredRequiredWidget(this.args);

  @override
  _State createState() => _State();
}

class _State extends State<PolicyCoveredRequiredWidget> with CommonWidget {
  int _selectedIndex, _previousSelectedIndex = -1;
  bool _isFamilyFloaterOrIndividual = false, isAlertVisible = false;
  Set<int> selectedMembers = SplayTreeSet<int>();
  int policyType;
  List<GeneralListModel> policyMembers;
  PremiumBloc _bloc;
  String erroString = '';
  PersonalDetails personalDetails;
  PolicyType policyTypeObj;

  @override
  void initState() {
    _bloc = SbiBlocProvider.of<PremiumBloc>(context);
    _listenForEvents();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    policyType = widget.args.policyType;
    switch (widget.args.policyType) {
      case 0:
        policyTypeObj = PolicyType(0, S.of(context).individual_title);
        break;
      case 1:
        policyTypeObj = PolicyType(1, S.of(context).family_floater_title);
        break;
      case 2:
        policyTypeObj = PolicyType(2, S.of(context).family_individual_title);
        break;
    }
    policyMembers = widget.args.policyMembers;
    personalDetails = widget.args.personalDetails;
    _isFamilyFloaterOrIndividual = (policyType != PolicyTypeScreen.INDIVIDUAL);
    super.didChangeDependencies();
  }

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;

      if (!_isFamilyFloaterOrIndividual) {
        selectedMembers.clear();
      }
      selectedMembers.add(index);

      GeneralListModel member = policyMembers[index];

      if (null != member.memberDetailsModel.ageGenderModel.defaultGender) {
        member.memberDetailsModel.ageGenderModel.gender =
            member.memberDetailsModel.ageGenderModel.defaultGender;
      }

      if (_previousSelectedIndex != -1 &&
          policyType == PolicyTypeScreen.INDIVIDUAL &&
          _previousSelectedIndex != _selectedIndex) {
        AgeGenderModel previousSelection = policyMembers[_previousSelectedIndex]
            .memberDetailsModel
            .ageGenderModel;
        print(previousSelection.defaultGender);
        previousSelection.age = null;
        previousSelection.gender = null;
        policyMembers[_previousSelectedIndex]
            .memberDetailsModel
            .ageGenderModel = previousSelection;
      }

      //If spouse/self selected
      if ((_selectedIndex == 1 || _selectedIndex == 0) &&
          policyType != PolicyTypeScreen.INDIVIDUAL &&
          selectedMembers.length > 0) {
        switch (_selectedIndex) {
          case 0:
            if (selectedMembers.contains(1)) {
              AgeGenderModel ageGenderModel =
                  policyMembers[1].memberDetailsModel.ageGenderModel;
              if (ageGenderModel.gender != null) {
                if (ageGenderModel.gender.compareTo("M") == 0) {
                  member.memberDetailsModel.ageGenderModel.defaultGender = "F";
                } else {
                  member.memberDetailsModel.ageGenderModel.defaultGender = "M";
                }
              }
            } else {
              member.memberDetailsModel.ageGenderModel.defaultGender = null;
            }
            break;
          case 1:
            if (selectedMembers.contains(0)) {
              AgeGenderModel ageGenderModel =
                  policyMembers[0].memberDetailsModel.ageGenderModel;
              if (ageGenderModel.gender != null) {
                if (ageGenderModel.gender.compareTo("M") == 0) {
                  member.memberDetailsModel.ageGenderModel.defaultGender = "F";
                } else {
                  member.memberDetailsModel.ageGenderModel.defaultGender = "M";
                }
              }
            } else {
              member.memberDetailsModel.ageGenderModel.defaultGender = null;
            }
            break;
        }
      }

      MemberDetailsBottomSheetWidget(
              member.memberDetailsModel, _onUpdate, policyType, _selectedIndex)
          .showBottomSheet(context);

      _previousSelectedIndex = _selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(context, S.of(context).insured_details.toUpperCase()),
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
                      S.of(context).policy_cover_title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontFamily: StringConstants.EFFRA_LIGHT),
                    ),
                    Visibility(
                      visible: policyType == PolicyTypeScreen.FAMILY_INDIVIDUAL,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            S.of(context).discount_description_for_family_individual,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: StringConstants.EFFRA_LIGHT),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(policyMembers.length, (index) {
                        return buildListItem(policyMembers[index], index);
                      }),
                    ),
//                    SizedBox(
//                      height: 10,
//                    ),
//                    QuickFactWidget(StringDescription.quick_fact5),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 25.0 + 8.0 - 20.0, left: 12.0, right: 12.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AlertWidget(erroString, isAlertVisible ? 168 : 0),
                ),
              ),
              _showPremiumButton(),
            ],
          ),
        ));
  }

  _onUpdate(int age, String gender, int index, bool remove) {
    AgeGenderModel ageGenderModel =
        policyMembers[_selectedIndex].memberDetailsModel.ageGenderModel;

    if (remove == true && selectedMembers.contains(index)) {
//      ageGenderModel.age = null;
//      ageGenderModel.ageString = null;
//      ageGenderModel.gender = null;
//      ageGenderModel.defaultGender = null;
//
      setState(() {
        var tempAgeGenderModel = AgeGenderModel();
        if(ageGenderModel.defaultGender != null) {
          tempAgeGenderModel.defaultGender = ageGenderModel.defaultGender;
        }
        policyMembers[_selectedIndex].memberDetailsModel.ageGenderModel =
            tempAgeGenderModel;
        selectedMembers.remove(index);
      });
    } else {
      bool isBothAvailable = true;
      if (age == null || TextUtils.isEmpty(gender.toString())) {
        isBothAvailable = false;
      }

      if (isBothAvailable) {
        ageGenderModel.age = age;
        ageGenderModel.gender = gender;
      } else {
        if (age != null) {
          ageGenderModel.age = age;
        }
        if (!TextUtils.isEmpty(gender.toString())) {
          ageGenderModel.gender = gender;
        }
      }

      if (age == 0) {
        ageGenderModel.ageString = "3 months to 1 year";
      } else if (age == 1) {
        ageGenderModel.ageString = "1 year";
      } else {
        ageGenderModel.ageString = "${ageGenderModel.age} years";
      }

      setState(() {
        policyMembers[_selectedIndex].memberDetailsModel.ageGenderModel =
            ageGenderModel;
      });

      if (age > 55) {
        Future.delayed(Duration(milliseconds: 200), () {
          showCustomerRepresentativeWidget(context);
        });
      }
    }
  }

  void showCustomerRepresentativeWidget(BuildContext context) {
    onClick(int from) {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if(Platform.isIOS){
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(false);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(false);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }
  }

  Widget buildListItem(GeneralListModel policyMember, int index) {
    bool isSelected = (selectedMembers.contains(index));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap: () {
          if (isAlertVisible) {
            setState(() {
              isAlertVisible = false;
            });
          }
          _onSelected(index);
        },
        child: Card(
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
                            ? Image.asset(policyMember.activeIcon)
                            : Image.asset(policyMember.icon)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      (policyType != PolicyTypeScreen.INDIVIDUAL &&
                              policyMember.title.compareTo(S.of(context).self_title) == 0)
                          ? policyMember.title + "*"
                          : policyMember.title,
                      style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : policyMember.titleColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ageGenderWidget(isSelected, index),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget ageGenderWidget(bool isSelected, int index) {
    String ageGenderString = '';
    bool isVisible = (selectedMembers.contains(index) && isSelected);
    if (isVisible) {
      if (policyMembers[index].memberDetailsModel != null) {
        AgeGenderModel ageGenderModel =
            policyMembers[index].memberDetailsModel.ageGenderModel;
        if (!TextUtils.isEmpty(ageGenderModel.gender)) {
          ageGenderString = "${ageGenderModel.gender}";
        }
        if (ageGenderModel.age != null) {
          String ageString =
              "${ageGenderModel.age == 0 ? "3 months to 1 year" : ageGenderModel.age}";

          if (TextUtils.isEmpty(ageGenderString)) {
            ageGenderString = ageGenderString;
          } else {
            ageGenderString = ageGenderString + ", " + ageString;
          }
        }
      }
    }
    return Visibility(
        visible: isVisible,
        child: Text(ageGenderString,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 12)));
  }

  _apiCall(SelectedMemberDetails selectedMemberDetails) async {
    showLoaderDialog(context);
    var response = await _bloc.calculatePremium(selectedMemberDetails.calculatePremiumReqModel, policyType == PolicyTypeScreen.FAMILY_INDIVIDUAL);
    if (response != null) {
      hideLoaderDialog(context);
      selectedMemberDetails.calculatedPremiumResModel = response;
      selectedMemberDetails.policyType = policyTypeObj;
      Navigator.of(context).pushNamed(SumInsuredAndPremiumScreen.ROUTE_NAME,
          arguments: selectedMemberDetails);
    }
  }

  onClick() {
    try {
      setState(() {
        int defaultSumInsured = 300000;
        if (selectedMembers.length == 0) {
          erroString = S.of(context).select_member_error;
          isAlertVisible = true;
        } else {
          SelectedMemberDetails selectedMemberDetails = SelectedMemberDetails(
              selectedMemberIds: selectedMembers,
              personalDetails: personalDetails);
          selectedMembers.toList().sort((a, b) => b.compareTo(a));

          List<GeneralListModel> pmList = List<GeneralListModel>();
          for (int i in selectedMembers) {
            MemberDetailsModel memberDetailsModel =
                policyMembers[i].memberDetailsModel;
            if (null != memberDetailsModel.ageGenderModel.age) {
              if (policyMembers[i].memberDetailsModel.ageGenderModel.age > 55) {
                showCustomerRepresentativeWidget(context);
                return;
              }
              if (memberDetailsModel.relation.startsWith("Child")) {
                String gender = memberDetailsModel.ageGenderModel.gender;
                if (gender.compareTo("M") == 0) {
                  if (memberDetailsModel.ageGenderModel.age >= 21) {
                    policyMembers[i].memberDetailsModel.maritalStatusIsFixed =
                        null;
                    policyMembers[i].memberDetailsModel.isMarried = null;
                  }
                } else {
                  if (memberDetailsModel.ageGenderModel.age >= 18) {
                    policyMembers[i].memberDetailsModel.maritalStatusIsFixed =
                        null;
                    policyMembers[i].memberDetailsModel.isMarried = null;
                  }
                }
              }
            }
            pmList.add(policyMembers[i]);
          }
          selectedMemberDetails.policyMembers = pmList;

          switch (policyType) {
            case PolicyTypeScreen.INDIVIDUAL:
              MemberDetailsModel member =
                  policyMembers[selectedMembers.elementAt(0)]
                      .memberDetailsModel;

              AgeGenderModel ageGenderModel = member.ageGenderModel;

              if (member.relation.compareTo(S.of(context).self_title) == 0 ||
                  member.relation.compareTo(S.of(context).spouse_title) == 0) {
                if (null == ageGenderModel.gender &&
                    null == ageGenderModel.age) {
                  erroString = S.of(context).enter_age_gender_error;
                  isAlertVisible = true;
                  return;
                }
                if (null == ageGenderModel.gender) {
                  erroString = S.of(context).enter_gender_error;
                  isAlertVisible = true;
                  return;
                } else if (null == ageGenderModel.age) {
                  erroString = S.of(context).enter_age_error;
                  isAlertVisible = true;
                  return;
                }
              }

              if (member.relation.compareTo(S.of(context).father_title) == 0 ||
                  member.relation.compareTo(S.of(context).mother_titile) == 0 ||
                  member.relation
                          .compareTo(S.of(context).father_in_law_title) ==
                      0 ||
                  member.relation
                          .compareTo(S.of(context).mother_in_law_title) ==
                      0) {
                if (null == ageGenderModel.age) {
                  erroString = S.of(context).enter_age_error;
                  isAlertVisible = true;
                  return;
                }
              }

              CalculatePremiumReqModel calculatePremiumReqModel =
                  CalculatePremiumReqModel(
                      age: ageGenderModel.age,
                      adultCount: 1,
                      childCount: 0,
                      sumInsured: defaultSumInsured);
              selectedMemberDetails.calculatePremiumReqModel =
                  calculatePremiumReqModel;
              _apiCall(selectedMemberDetails);
              break;
            case PolicyTypeScreen.FAMILY_FLOATER:
            case PolicyTypeScreen.FAMILY_INDIVIDUAL:
              if (selectedMembers.length < 2) {
                print("selectedMembers.first " +
                    selectedMembers.first.toString());
                if (policyMembers[selectedMembers.first]
                        .title
                        .compareTo(S.of(context).self_title) !=
                    0) {
                  erroString = S.of(context).self_required;
                } else {
                  erroString = S.of(context).one_more_rquired;
                }
                isAlertVisible = true;
                return;
              } else {
                int adultCount = 0;
                int childCount = 0;
                int maxAge = 0;

                for (int index in selectedMembers) {
                  MemberDetailsModel memberDetailsModel =
                      policyMembers[index].memberDetailsModel;
                  AgeGenderModel ageGenderModel =
                      memberDetailsModel.ageGenderModel;

                  if (ageGenderModel.gender == null &&
                      ageGenderModel.age == null) {
                    erroString = S.of(context).enter_age_gender_error +
                        " of " +
                        "${memberDetailsModel.relation}";
                    isAlertVisible = true;
                    return;
                  } else if (ageGenderModel.gender == null) {
                    erroString = S.of(context).enter_gender_of +
                        " ${memberDetailsModel.relation} " +
                        S.of(context).gender_title;
                    isAlertVisible = true;
                    return;
                  } else if (ageGenderModel.age == null) {
                    erroString = S.of(context).enter_age_of +
                        " ${memberDetailsModel.relation}";
                    isAlertVisible = true;
                    return;
                  }

                  maxAge =
                      maxAge < ageGenderModel.age ? ageGenderModel.age : maxAge;

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).self_title) ==
                      0) {
                    adultCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).spouse_title) ==
                      0) {
                    adultCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).father_title) ==
                      0) {
                    adultCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).mother_titile) ==
                      0) {
                    adultCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).father_in_law_title) ==
                      0) {
                    adultCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).mother_in_law_title) ==
                      0) {
                    adultCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).child1_title) ==
                      0) {
                    childCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).child2_title) ==
                      0) {
                    childCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).child3_title) ==
                      0) {
                    childCount++;
                  }

                  if (memberDetailsModel.relation
                          .compareTo(S.of(context).child4_title) ==
                      0) {
                    childCount++;
                  }
                }

                if (!selectedMembers.contains(0)) {
                  erroString = S.of(context).self_required;
                  isAlertVisible = true;
                  return;
                }

//              if (policyType == PolicyTypeScreen.FAMILY_INDIVIDUAL) {
//                int totalMembers = adultCount + childCount;
//                defaultSumInsured = defaultSumInsured * totalMembers;
//              }

                CalculatePremiumReqModel calculatePremiumReqModel =
                    CalculatePremiumReqModel(
                        age: maxAge,
                        adultCount: adultCount,
                        childCount: childCount,
                        sumInsured: defaultSumInsured);
                selectedMemberDetails.calculatePremiumReqModel =
                    calculatePremiumReqModel;
                _apiCall(selectedMemberDetails);
              }
              break;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _showPremiumButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.arogya_plus_bg_color,
    );
  }

  _listenForEvents() {
    _bloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0,(int retryIdentifier) {
        onClick();
      }, event.dialogType);
    });
  }
}

// Settings args
class PolicyCoveredRequiredScreenArgs {
  final int policyType;
  final List<GeneralListModel> policyMembers;
  final PersonalDetails personalDetails;

  PolicyCoveredRequiredScreenArgs(
      this.policyType, this.policyMembers, this.personalDetails);
}
