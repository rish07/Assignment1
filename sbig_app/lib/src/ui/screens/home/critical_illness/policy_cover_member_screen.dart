import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/cover_member/cover_member_bloc.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/cover_member_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_member_bottom_sheet_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/critical_illness/age_limit_exceded_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../home_screen.dart';
import 'gross_income_screen.dart';

class PolicyCoverMemberScreen extends StatelessWidget{
  static const ROUTE_NAME = "/policy_cover_member_screen";
  final PolicyCoverMemberArguments arguments;

  PolicyCoverMemberScreen(this.arguments);

  @override
  Widget build(BuildContext context) {

    return SbiBlocProvider(
      bloc: CoverMemberBloc(),
      child:PolicyCoverMemberScreenWidget(arguments) ,
    );
  }

}

class PolicyCoverMemberScreenWidget extends StatefulWidget {

  final PolicyCoverMemberArguments arguments;

  PolicyCoverMemberScreenWidget(this.arguments);

  @override
  _PolicyCoverMemberScreenWidgetState createState() =>
      _PolicyCoverMemberScreenWidgetState();
}

class _PolicyCoverMemberScreenWidgetState extends State<PolicyCoverMemberScreenWidget> with CommonWidget {
  bool isNextButtonEnable = false;
  List<PolicyCoverMemberModel> policyCoverMemberModelList = [];
  Set<int> selectedMembers = SplayTreeSet<int>();
  int _selectedIndex, _previousSelectedIndex = -1;
  CoverMemberResModel coverMemberResModel;
  CoverMemberBloc _coverMemberBloc;
  int isFrom ;
  int policyType=-1;
  PolicyType policyTypeObj;
  bool _isFamilyFloaterOrIndividual = false, isAlertVisible = false;

  @override
  void initState() {
    isFrom =widget.arguments.personalDetails.isFrom;
    policyType = widget.arguments.policyType;
    coverMemberResModel=widget.arguments.coverMemberResModel;
    _coverMemberBloc=SbiBlocProvider.of<CoverMemberBloc>(context);
  //  _makeCoverMemberApiCall(isFrom,policyType: policyType);
    _createCoverMemberList(coverMemberResModel);
     _listenForEvents();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isFamilyFloaterOrIndividual = (policyType != PolicyTypeScreen.INDIVIDUAL);
    switch (widget.arguments.policyType) {
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
    super.didChangeDependencies();

  }
  _listenForEvents() {
    _coverMemberBloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0, (int retryIdentifier) {
       _makeCoverMemberApiCall(isFrom,policyType: policyType);
      }, event.dialogType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.critical_illness_bg_color,
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
                                fontWeight: FontWeight.w500,),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (policyType == PolicyTypeScreen.FAMILY_FLOATER),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            S.of(context).arogya_premier_discount_description_for_family_floater,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (isFrom == StringConstants.FROM_CRITICAL_ILLNESS || policyType == PolicyTypeScreen.INDIVIDUAL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '*'+S.of(context).critical_illness_applicable_title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
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
                      children: List.generate(policyCoverMemberModelList.length,
                          (index) {
                        return buildListItem(
                            policyCoverMemberModelList[index], index);
                      }),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
              _showEnableDisableButton(),
             ///below loader will not cover app bar so not using it
             /* StreamBuilder<bool>(
                  stream: _coverMemberBloc.isLoadingStream,
                  builder: (context, snapshot) {
                    bool isVisible = false;
                    if (snapshot != null &&
                        (snapshot.hasData && snapshot.data)) {
                      isVisible = true;
                    }
                    return Visibility(
                      visible: isVisible,
                      child: LoadingScreen(),
                    );
                  }),*/
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _coverMemberBloc.dispose();
    super.dispose();
  }

  _showEnableDisableButton() {
   /* if(isFrom == StringConstants.FROM_CRITICAL_ILLNESS){
      return EnableDisableButtonWidget(
        (isNextButtonEnable) ? onClickCriticalIllness : null,
        S.of(context).next.toUpperCase(),
        bottomBgColor: ColorConstants.critical_illness_bg_color,
      );
    }else {
      return EnableDisableButtonWidget(
        (isNextButtonEnable) ? onClick : null,
        S.of(context).next.toUpperCase(),
        bottomBgColor: ColorConstants.critical_illness_bg_color,
      );
    }*/
    return EnableDisableButtonWidget(
      (isNextButtonEnable) ? onClickCriticalIllness : null,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.critical_illness_bg_color,
    );

  }

  Widget buildListItem(PolicyCoverMemberModel policyMember, int index) {
    bool isSelected = (selectedMembers.contains(index));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap: () {

         /* if(isFrom ==StringConstants.FROM_CRITICAL_ILLNESS){
            _onSelectedCriticalIllnessMember(index);
          }else{
            _onSelected(index);
          }
*/
          _onSelectedCriticalIllnessMember(index);
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
                            ?  (policyMember.activeIcon ==null || policyMember.activeIcon.length==0)?  Image.asset(AssetConstants.ic_self_white): Image(image: NetworkImage(UrlConstants.ICON +policyMember.activeIcon),)
                            : (policyMember.icon ==null || policyMember.icon.length==0)?Image.asset(AssetConstants.ic_self): Image(image: NetworkImage(  UrlConstants.ICON + policyMember.icon),)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      policyMember.title,
                      style: TextStyle(
                          fontSize: 18,
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
      if (policyCoverMemberModelList[index].memberDetailsModel != null) {
        AgeGenderModel ageGender =
            policyCoverMemberModelList[index].memberDetailsModel.ageGenderModel;
        if (!TextUtils.isEmpty(ageGender.gender)) {
          ageGenderString = "${ageGender.gender}";
        }
        if (ageGender.age != null) {
          String ageString = "${ageGender.age}";

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

  _onSelectedCriticalIllnessMember(int index) {
    setState(() {
      _selectedIndex = index;
      if (selectedMembers != null) {
        selectedMembers.clear();
      }
      selectedMembers.add(index);

      PolicyCoverMemberModel member = policyCoverMemberModelList[index];

      if (null != member.memberDetailsModel.ageGenderModel.defaultGender) {
        member.memberDetailsModel.ageGenderModel.gender =
            member.memberDetailsModel.ageGenderModel.defaultGender;
      }

      if (_previousSelectedIndex != -1 &&
          _previousSelectedIndex != _selectedIndex) {
        AgeGenderModel previousSelection =
            policyCoverMemberModelList[_previousSelectedIndex]
                .memberDetailsModel
                .ageGenderModel;
        print(previousSelection.defaultGender);
        previousSelection.age = null;
        previousSelection.gender = null;
        policyCoverMemberModelList[_previousSelectedIndex]
            .memberDetailsModel.isEmployed = null;
        policyCoverMemberModelList[_previousSelectedIndex]
            .memberDetailsModel
            .ageGenderModel = previousSelection;
      }

      CriticalIllnessMemberDetailsBottomSheetWidget(
              member.memberDetailsModel, _onUpdateCriticalIllness, _selectedIndex)
          .showBottomSheet(context);

      _previousSelectedIndex = _selectedIndex;
    });
  }

  /*_onSelected(int index) {
    setState(() {
      _selectedIndex = index;

      if (!_isFamilyFloaterOrIndividual) {
        selectedMembers.clear();
      }
      selectedMembers.add(index);

      PolicyCoverMemberModel member = policyCoverMemberModelList[index];

      if (null != member.memberDetailsModel.ageGenderModel.defaultGender) {
        member.memberDetailsModel.ageGenderModel.gender =
            member.memberDetailsModel.ageGenderModel.defaultGender;
      }

      if (_previousSelectedIndex != -1 &&
          policyType == PolicyTypeScreen.INDIVIDUAL &&
          _previousSelectedIndex != _selectedIndex) {
        AgeGenderModel previousSelection = policyCoverMemberModelList[_previousSelectedIndex]
            .memberDetailsModel
            .ageGenderModel;
        print(previousSelection.defaultGender);
        previousSelection.age = null;
        previousSelection.gender = null;
        policyCoverMemberModelList[_previousSelectedIndex]
            .memberDetailsModel
            .ageGenderModel = previousSelection;
      }

      //If spouse/self selected
      if ((_selectedIndex == 1 || _selectedIndex == 0) && policyType != PolicyTypeScreen.INDIVIDUAL && selectedMembers.length > 0) {
        switch (_selectedIndex) {
          case 0:
            if (selectedMembers.contains(1)) {
              AgeGenderModel ageGenderModel =
                  policyCoverMemberModelList[1].memberDetailsModel.ageGenderModel;
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
                  policyCoverMemberModelList[0].memberDetailsModel.ageGenderModel;
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
  }*/

  _onUpdateCriticalIllness(int age, String gender, int index, bool isEmployed) {
    AgeGenderModel ageGenderModel = policyCoverMemberModelList[_selectedIndex].memberDetailsModel.ageGenderModel;
    bool isAllAvailable = true;
    if (age == null ||
        TextUtils.isEmpty(gender.toString()) ||
        isEmployed == null) {
      isAllAvailable = false;
    }

    if (isAllAvailable) {
      isNextButtonEnable = true;
      ageGenderModel.age = age;
      ageGenderModel.gender = gender;
      policyCoverMemberModelList[_selectedIndex].memberDetailsModel.isEmployed =
          isEmployed;
    } else {
      isNextButtonEnable = false;
      if (age != null) {
        ageGenderModel.age = age;
      }
      if (!TextUtils.isEmpty(gender.toString())) {
        ageGenderModel.gender = gender;
      }
      if (isEmployed != null) {
        policyCoverMemberModelList[_selectedIndex]
            .memberDetailsModel
            .isEmployed = isEmployed;
      }
    }

    ageGenderModel.ageString = "${ageGenderModel.age} years";

    setState(() {
      policyCoverMemberModelList[_selectedIndex]
          .memberDetailsModel
          .ageGenderModel = ageGenderModel;
    });
  }

  /*_onUpdate(int age, String gender, int index, bool remove) {
    AgeGenderModel ageGenderModel = policyCoverMemberModelList[_selectedIndex].memberDetailsModel.ageGenderModel;

    if (remove == true && selectedMembers.contains(index)) {
      setState(() {
        var tempAgeGenderModel = AgeGenderModel();
        if(ageGenderModel.defaultGender != null) {
          tempAgeGenderModel.defaultGender = ageGenderModel.defaultGender;
        }
        policyCoverMemberModelList[_selectedIndex].memberDetailsModel.ageGenderModel = tempAgeGenderModel;
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
        /// The below code is to check for enable or disable button based in the policy type i
        isNextButtonEnable =false;
        if(policyType == PolicyTypeScreen.INDIVIDUAL){
          if(selectedMembers.length ==1 ){
            isNextButtonEnable =true;
          }
        }else if(policyType == PolicyTypeScreen.FAMILY_FLOATER || policyType == PolicyTypeScreen.FAMILY_INDIVIDUAL){
          if(selectedMembers.length >=2){
            isNextButtonEnable=true;
          }
        }

      } else {
        isNextButtonEnable=false;
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
        policyCoverMemberModelList[_selectedIndex].memberDetailsModel.ageGenderModel = ageGenderModel;
      });

      if (age > 55) {
        Future.delayed(Duration(milliseconds: 200), () {
          showCustomerRepresentativeWidget(context);
        });
      }
    }
  }*/

  onClickCriticalIllness() {
    try {
      setState(() {
        if (selectedMembers.length == 0) {
          isNextButtonEnable = false;
        } else {
          isNextButtonEnable = true;
          CriticalIllnessModel criticalIllnessModel = CriticalIllnessModel(
              personalDetails: widget.arguments.personalDetails);
          MemberDetailsModel member =
              policyCoverMemberModelList[selectedMembers.elementAt(0)]
                  .memberDetailsModel;

          if (member.relation.compareTo(S.of(context).self_title) == 0 &&
              !member.isEmployed) {
            showCustomerRepresentativeWidget(context);
            return;
          }

          if (null != member.ageGenderModel.age) {
            if (policyCoverMemberModelList[selectedMembers.elementAt(0)]
                    .memberDetailsModel
                    .ageGenderModel
                    .age >
                45) {
              showCustomerAgeLimitWidget(context);
              return;
            }
            if (member.relation.startsWith("Child")) {
              String gender = member.ageGenderModel.gender;
              if (gender.compareTo("M") == 0) {
                if (member.ageGenderModel.age >= 21) {
                  policyCoverMemberModelList[selectedMembers.elementAt(0)]
                      .memberDetailsModel
                      .maritalStatusIsFixed = null;
                  policyCoverMemberModelList[selectedMembers.elementAt(0)]
                      .memberDetailsModel
                      .isMarried = null;
                }
              } else {
                if (member.ageGenderModel.age >= 18) {
                  policyCoverMemberModelList[selectedMembers.elementAt(0)]
                      .memberDetailsModel
                      .maritalStatusIsFixed = null;
                  policyCoverMemberModelList[selectedMembers.elementAt(0)]
                      .memberDetailsModel
                      .isMarried = null;
                }
              }
            }
          }
          criticalIllnessModel.policyCoverMemberModel =
              policyCoverMemberModelList[selectedMembers.elementAt(0)];

          AgeGenderModel ageGenderModel = member.ageGenderModel;

          if (member.relation.compareTo(S.of(context).self_title) == 0 ||
              member.relation.compareTo(S.of(context).spouse_title) == 0) {
            if (null == ageGenderModel.gender && null == ageGenderModel.age) {
              isNextButtonEnable = false;
              return;
            }
            if (null == ageGenderModel.gender) {
              isNextButtonEnable = false;
              return;
            } else if (null == ageGenderModel.age) {
              isNextButtonEnable = false;
              return;
            } else if (null ==
                criticalIllnessModel
                    .policyCoverMemberModel.memberDetailsModel.isEmployed) {
              isNextButtonEnable = false;
              return;
            }
          }

          if (member.relation.compareTo(S.of(context).father_title) == 0 ||
              member.relation.compareTo(S.of(context).mother_titile) == 0 ||
              member.relation.compareTo(S.of(context).father_in_law_title) ==
                  0 ||
              member.relation.compareTo(S.of(context).mother_in_law_title) ==
                  0) {
            if (null == ageGenderModel.age) {
              isNextButtonEnable = false;
              return;
            } else if (null ==
                criticalIllnessModel
                    .policyCoverMemberModel.memberDetailsModel.isEmployed) {
              isNextButtonEnable = false;
              return;
            }
          }

          criticalIllnessModel.policyTpeString = "Individual Policy";
          if (member.relation.compareTo(S.of(context).self_title) == 0) {
            criticalIllnessModel.isProposerSelf = true;
          } else {
            criticalIllnessModel.isProposerSelf = false;
          }
          _navigate(criticalIllnessModel);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

/*  onClick() {
    try {
      setState(() {
        int defaultSumInsured = 300000;
        if (selectedMembers.length == 0) {
         isNextButtonEnable=false;
        } else {

          selectedMembers.toList().sort((a, b) => b.compareTo(a));

          ArogyaPremierModel arogyaPremierModel =ArogyaPremierModel();
          arogyaPremierModel.personalDetails=widget.arguments.personalDetails;
          arogyaPremierModel.isFrom=widget.arguments.personalDetails.isFrom;
          arogyaPremierModel.selectedMemberIds=selectedMembers;

          List<PolicyCoverMemberModel> pmList = List<PolicyCoverMemberModel>();
          for (int i in selectedMembers) {
            MemberDetailsModel memberDetailsModel = policyCoverMemberModelList[i].memberDetailsModel;

            if (null != memberDetailsModel.ageGenderModel.age) {
              if (policyCoverMemberModelList[i].memberDetailsModel.ageGenderModel.age > 55) {
                showCustomerRepresentativeWidget(context);
                return;
              }
              if (memberDetailsModel.relation.startsWith("Child")) {
                String gender = memberDetailsModel.ageGenderModel.gender;
                if (gender.compareTo("M") == 0) {
                  if (memberDetailsModel.ageGenderModel.age >= 21) {
                    policyCoverMemberModelList[i].memberDetailsModel.maritalStatusIsFixed =
                    null;
                    policyCoverMemberModelList[i].memberDetailsModel.isMarried = null;
                  }
                } else {
                  if (memberDetailsModel.ageGenderModel.age >= 18) {
                    policyCoverMemberModelList[i].memberDetailsModel.maritalStatusIsFixed =
                    null;
                    policyCoverMemberModelList[i].memberDetailsModel.isMarried = null;
                  }
                }
              }
            }
            pmList.add(policyCoverMemberModelList[i]);
          }
          arogyaPremierModel.policyMembers = pmList;

          switch (policyType) {
            case PolicyTypeScreen.INDIVIDUAL:
              MemberDetailsModel member = policyCoverMemberModelList[selectedMembers.elementAt(0)].memberDetailsModel;
              AgeGenderModel ageGenderModel = member.ageGenderModel;

              if (member.relation.compareTo(S.of(context).self_title) == 0 || member.relation.compareTo(S.of(context).spouse_title) == 0) {
                if (null == ageGenderModel.gender && null == ageGenderModel.age) {
                  isNextButtonEnable=false;
                  return;
                }
                if (null == ageGenderModel.gender) {
                  isNextButtonEnable=false;
                  return;
                } else if (null == ageGenderModel.age) {
                  isNextButtonEnable=false;
                  return;
                }
              }

              if (member.relation.compareTo(S.of(context).father_title) == 0 || member.relation.compareTo(S.of(context).mother_titile) == 0 || member.relation.compareTo(S.of(context).father_in_law_title) == 0 || member.relation.compareTo(S.of(context).mother_in_law_title) == 0) {
                if (null == ageGenderModel.age) {
                  isNextButtonEnable=false;
                  return;
                }
              }
              isNextButtonEnable=true;

              List<Members> membersList=[];
              membersList.add(Members(age: ageGenderModel.age));
              SumInsuredReqModel sumInsuredReqModel=SumInsuredReqModel(
                  members:membersList
              );

              arogyaPremierModel.sumInsuredReqModel = sumInsuredReqModel;
              _sumInsuredApiCall(sumInsuredReqModel,arogyaPremierModel: arogyaPremierModel);
              break;
            case PolicyTypeScreen.FAMILY_FLOATER:
            case PolicyTypeScreen.FAMILY_INDIVIDUAL:
              if (selectedMembers.length < 2) {
                isNextButtonEnable=false;
                return;
              } else {
                int adultCount = 0;
                int childCount = 0;
                int maxAge = 0;
                List<Members> membersList=[];

                for (int index in selectedMembers) {
                  MemberDetailsModel memberDetailsModel = policyCoverMemberModelList[index].memberDetailsModel;
                  AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;

                  if (ageGenderModel.gender == null &&
                      ageGenderModel.age == null) {
                    isNextButtonEnable=false;
                    return;
                  } else if (ageGenderModel.gender == null) {
                    isNextButtonEnable=false;
                    return;
                  } else if (ageGenderModel.age == null) {
                    isNextButtonEnable=false;
                    return;
                  }
                  if (!selectedMembers.contains(0)) {
                    isNextButtonEnable=false;
                    return;
                  }

                  isNextButtonEnable=true;

                  maxAge = maxAge < ageGenderModel.age ? ageGenderModel.age : maxAge;

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

                  membersList.add(Members(age: ageGenderModel.age));
                }


                SumInsuredReqModel sumInsuredReqModel=SumInsuredReqModel(
                    members:membersList
                );

                arogyaPremierModel.sumInsuredReqModel = sumInsuredReqModel;
                _sumInsuredApiCall(sumInsuredReqModel,arogyaPremierModel: arogyaPremierModel);

              }
              break;
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }*/

  void showCustomerRepresentativeWidget(BuildContext context) {
    onClick(int from) {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if(Platform.isIOS){
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }
  }

  void showCustomerAgeLimitWidget(BuildContext context) {
    onClick(int from) {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(false);
              },
              child: CustomerAgeLimitWidget(onClick)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(false);
              },
              child: CustomerAgeLimitWidget(onClick)));
    }
  }

  void _navigate(CriticalIllnessModel criticalIllnessModel) {
    Navigator.of(context).pushNamed(GrossIncomeScreen.ROUTE_NAME,
        arguments: GrossIncomeRequestArguments(criticalIllnessModel));
  }

  void _createCoverMemberList(CoverMemberResModel coverMemberResModel) {
   // _coverMemberBloc.changeLoadingStream(true);
    policyCoverMemberModelList = [];
    if (coverMemberResModel != null) {
      var data = coverMemberResModel.data?.body;
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          List<String> _ageList = [];
          if (data[i].slugType.contains('button')) {
            var tit = data[i].title;
            var gender = data[i]?.jsonCondition?.gender;
            var age = data[i]?.jsonCondition?.age ;
            if (data[i]?.jsonCondition?.age != null) {
              for(int j=0 ;j< age.length;j++){
                _ageList.add('${age[j]} years');
              }
            } else {
              _ageList = [for (var j = 1; j <= 65; j += 1) "$j years"];
            }

            policyCoverMemberModelList.add( PolicyCoverMemberModel(
                title: data[i]?.title ?? '',
                icon: data[i]?.imagePath1 ??null,
                activeIcon: data[i]?.imagePath2 ?? null,
                ageList:_ageList,
                color1: ColorConstants.policy_type_gradient_color1,
                color2: ColorConstants.policy_type_gradient_color2,
                gender: null,
                titleColor: Colors.black,
                memberDetailsModel: MemberDetailsModel(
                  relation: data[i]?.title ?? '',
                  icon: data[i]?.imagePath1 ??null,
                  ageGenderModel: (gender==null)?AgeGenderModel():AgeGenderModel(defaultGender: ((gender.startsWith('male') || gender.startsWith('Male'))?'M':'F')),
                  ageList: _ageList,
                  isMarried: (tit.startsWith('Father')||tit.startsWith('Mother'))?data[i].jsonCondition.isMarried :null,
                  maritalStatusIsFixed: (tit.startsWith('Father')||tit.startsWith('Mother'))?data[i].jsonCondition.isMarried :null,
                )));
          }
        }
      }
    }
 //   _coverMemberBloc.changeLoadingStream(false);
  }

  _makeCoverMemberApiCall(int isFrom ,{int policyType}) async {
    showLoaderDialog(context);
    final response = await _coverMemberBloc.getCoverMember(isFrom,policyType: policyType);
    hideLoaderDialog(context);
    if(response!=null){
      setState(() {
        coverMemberResModel = response;
        _createCoverMemberList(coverMemberResModel);
      });
    }

  }

/*  void _sumInsuredApiCall(SumInsuredReqModel sumInsuredReqModel,{ArogyaPremierModel arogyaPremierModel}) async {
    var response = await _coverMemberBloc.getSumInsured(isFrom, sumInsuredReqModel);
    if (response != null) {
      arogyaPremierModel.sumInsuredResModel = response;
      arogyaPremierModel.policyType = policyTypeObj;
      Navigator.of(context).pushNamed(ArogyaPremierSumInsuredScreen.ROUTE_NAME,
          arguments: arogyaPremierModel);
    }
  }*/
}

class PolicyCoverMemberArguments {
  final PersonalDetails personalDetails;
  final int policyType;
  final CoverMemberResModel coverMemberResModel;

  PolicyCoverMemberArguments(this.personalDetails,{this.policyType,this.coverMemberResModel});
}
