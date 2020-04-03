

import 'package:sbig_app/src/controllers/blocs/home/arogya_premier/sum_insured/sum_insured_api_provider.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/arogya_family_individual_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_sum_insured.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
/*class MemberDetailsFamilyIndividualBottomSheetWidget {
  final MemberDetailsModel memberDetailsModel;
  final Function(int, String, int, bool) onUpdate;
  final int policyType;
  final int selectedMember;
  bool isUpdateVisible = false;

  static int age;
  static String gender;

  MemberDetailsFamilyIndividualBottomSheetWidget(this.memberDetailsModel, this.onUpdate,
      this.policyType, this.selectedMember);

  void showBottomSheet(context) {
    AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
    age = ageGenderModel.age;
    gender = ageGenderModel.gender;
    if (gender == null) {
      gender = ageGenderModel.defaultGender;
    }
    isUpdateVisible = (age!=null && gender !=null);

    onClickUpdateDetails() {
      onUpdate(
          MemberDetailsFamilyIndividualBottomSheetWidget.age,
          MemberDetailsFamilyIndividualBottomSheetWidget.gender,
          selectedMember,
          false);
      MemberDetailsFamilyIndividualBottomSheetWidget.age = null;
      MemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
      Navigator.of(context).pop();
    }
    double width = ScreenUtil.getInstance(context).screenWidthDp;

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              margin: EdgeInsets.only(left: 12.0, right: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                            height: 22,
                            width: 22,
                            child: Image.asset(memberDetailsModel.icon)),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            memberDetailsModel.relation,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        if (policyType != PolicyTypeScreen.INDIVIDUAL)
                          SizedBox(
                            height: 25.0,
                            child: OutlineButton(
                              onPressed: () {
                                onUpdate(null, null, selectedMember, true);
                                MemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                                MemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                                Navigator.of(context).pop();
                              },
                              borderSide: BorderSide(
                                  color: ColorConstants
                                      .policy_type_gradient_color2),
                              child: Text(
                                S.of(context).remove.toUpperCase(),
                                style: TextStyle(
                                    color: ColorConstants
                                        .policy_type_gradient_color2,
                                    fontSize: 12.0,
                                    letterSpacing: 1.0),
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      !TextUtils.isEmpty(
                          memberDetailsModel.ageGenderModel.defaultGender)
                          ? S.of(context).gender_title.toUpperCase()
                          : S.of(context).select_gender_title.toUpperCase(),
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GenderListWidget(
                        memberDetailsModel, onUpdate, selectedMember, isUpdateVisible),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).select_age_title.toUpperCase(),
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AgeWidget(memberDetailsModel, onUpdate, selectedMember, isUpdateVisible),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).select_sum_insured.toUpperCase(),
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SumInsuredWidget(memberDetailsModel, onUpdate, selectedMember, isUpdateVisible),
                    Text(
                      S.of(context).select_sum_insured.toUpperCase(),
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SumInsuredWidget(memberDetailsModel, onUpdate, selectedMember, isUpdateVisible),

                    SizedBox(height: width <= 320 ? 15.0 : 20.0,),
                    if(isUpdateVisible) Padding(
                      padding: EdgeInsets.only(bottom: width <= 320 ? 15.0: 20.0),
                      child: BlackButtonWidget(onClickUpdateDetails,
                        S.of(context).update_details_title.toUpperCase(), titleFontSize:12.0, width: 170, height: 40.0, padding: EdgeInsets.all(0.0),),
                    )
                  ],
                ),
              ));
        });
  }
}*/

class ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget extends StatefulWidget {

  final ArogyaFamilyIndividualModel arogyaFamilyIndividualModel;
  final MemberDetailsModel memberDetailsModel;
  final Function( int, bool, ArogyaFamilyIndividualModel) onUpdate;
  final int selectedMember;
  static int age;
  static String gender;
  static int sumInsured=-1;
  static dynamic deduction='-1';
  static dynamic premium='-1';
  static ArogyaTopUpSumInsuredResModel arogyaTopUpSumInsuredResModel;
  final int isFrom ;


  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget(
      this.onUpdate, this.memberDetailsModel,this.arogyaFamilyIndividualModel,this.selectedMember, this.isFrom);

  @override
  _ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidgetState createState() =>
      _ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidgetState();
}

class _ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidgetState
    extends State<ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget> {
  bool isUpdateVisible = false;
  double width;
  double height;
  MemberDetailsModel memberDetailsModel;
  int policyType;
  int selectedMember;
  int isFrom ;

  @override
  void initState() {
    memberDetailsModel = widget.memberDetailsModel;
    isFrom=widget.isFrom;

    selectedMember = widget.selectedMember;
    AgeGenderModel ageGenderModel = widget.memberDetailsModel.ageGenderModel;
    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = ageGenderModel.age;
    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = ageGenderModel.gender;
    if(widget.arogyaFamilyIndividualModel.arogyaTopUpSumInsuredResModel!=null){
      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=widget.arogyaFamilyIndividualModel.arogyaTopUpSumInsuredResModel??null;
    }
    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured= widget.arogyaFamilyIndividualModel.sumInsured??-1;
    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium= widget.arogyaFamilyIndividualModel.premium??'-1';
    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction=widget.arogyaFamilyIndividualModel.deduction??'-1';

    if (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender == null) {
      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = ageGenderModel.defaultGender;
    }
    isUpdateVisible = (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age != null
        && ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender != null
        && ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured!=-1);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    width = ScreenUtil.getInstance(context).screenWidthDp;
    height = ScreenUtil.getInstance(context).screenHeightDp;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: Image.asset(memberDetailsModel.icon)),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Text(
                                  memberDetailsModel.relation,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              ),

                              SizedBox(
                                height: 25.0,
                                child: OutlineButton(
                                  onPressed: () {
                                    widget.onUpdate(selectedMember, true,
                                        ArogyaFamilyIndividualModel());
                                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction='-1';
                                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                                    Navigator.of(context).pop();
                                  },
                                  borderSide: BorderSide(
                                      color: ColorConstants
                                          .policy_type_gradient_color2),
                                  child: Text(
                                    S.of(context).remove.toUpperCase(),
                                    style: TextStyle(
                                        color: ColorConstants
                                            .policy_type_gradient_color2,
                                        fontSize: 12.0,
                                        letterSpacing: 1.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            !TextUtils.isEmpty(memberDetailsModel
                                .ageGenderModel.defaultGender)
                                ? S.of(context).gender_title.toUpperCase()
                                : S
                                .of(context)
                                .select_gender_title
                                .toUpperCase(),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GenderListWidget(memberDetailsModel, widget.onUpdate,
                              selectedMember, isUpdateVisible,isFrom),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            S.of(context).select_age_title.toUpperCase(),
                            style: TextStyle(fontSize: 12, color: Colors.black,),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                            ArogyaTopUpAgeWidget(memberDetailsModel, widget.onUpdate, selectedMember, isUpdateVisible),
                          SizedBox(
                            height: width <= 320 ? 15.0 : 20.0,
                          ),
                          if (isUpdateVisible)
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: width <= 320 ? 15.0 : 20.0),
                              child: BlackButtonWidget((){
                                widget.onUpdate(
                                    widget.selectedMember,
                                    false,
                                    ArogyaFamilyIndividualModel(
                                        age:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age,
                                        gender:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender,
                                        arogyaTopUpSumInsuredResModel:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel,
                                        sumInsured: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                                        deduction: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction,
                                        premium: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium,
                                        memberDetails:  widget.memberDetailsModel,
                                        memberIndex: selectedMember
                                    )
                                );
                                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction='-1';
                                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                                Navigator.of(context).pop();
                              },
                                // child: BlackButtonWidget(null,
                                S.of(context).update_details_title.toUpperCase(),
                                titleFontSize: 12.0,
                                width: 170,
                                height: 40.0,
                                padding: EdgeInsets.all(0.0),
                              ),
                            )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));

  }
}

class GenderListWidget extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  final Function( int, bool,ArogyaFamilyIndividualModel)
  onUpdate;
  int selectedMember;
  bool isUpdateVisible;
  int isFrom;

  GenderListWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember,
      this.isUpdateVisible,this.isFrom);

  @override
  _GenderListWidgetState createState() => _GenderListWidgetState();
}

class _GenderListWidgetState extends State<GenderListWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildGenderItems();
  }

  _buildGenderItems() {
    bool isHavingDefaultGender = !TextUtils.isEmpty(
        widget.memberDetailsModel.ageGenderModel.defaultGender);

    if (isHavingDefaultGender) {
      return Container(
        child: SizedBox(
          width: 60,
          height: 60,
          child: (widget.memberDetailsModel.ageGenderModel.defaultGender
              .compareTo("M") ==
              0)
              ? Image.asset(AssetConstants.ic_male_selected)
              : Image.asset(AssetConstants.ic_female_selected),
        ),
      );
    } else {
      bool isGenderSelected = !TextUtils.isEmpty(
          ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender);
      bool isMale = !isGenderSelected
          ? false
          : (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender
          .compareTo("M") ==
          0);

      return Row(
        children: <Widget>[
          InkResponse(
            onTap: () {
              setState(() {
//                widget.memberDetailsModel.ageGenderModel.gender = "M";
                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = "M";
                if (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age != null && ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured !=-1 &&
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction !='-1'  &&
                      !widget.isUpdateVisible) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      widget.onUpdate(
                          widget.selectedMember,
                          false,
                          ArogyaFamilyIndividualModel(
                              age:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age,
                              gender:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender,
                              arogyaTopUpSumInsuredResModel:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel,
                              sumInsured: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                              deduction: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction,
                              memberDetails:  widget.memberDetailsModel,
                              memberIndex: widget.selectedMember
                          )
                      );
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                      Navigator.of(context).pop();
                    });
                  }
              });
            },
            child: SizedBox(
              width: 60,
              height: 60,
              child: (isGenderSelected && isMale)
                  ? Image.asset(AssetConstants.ic_male_selected)
                  : Image.asset(AssetConstants.ic_male),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          InkResponse(
            onTap: () {
              setState(() {
                ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = "F";
                  if (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age != null &&
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured !=-1 &&
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction !='-1'  &&
                      !widget.isUpdateVisible) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      widget.onUpdate(
                          widget.selectedMember,
                          false,
                          ArogyaFamilyIndividualModel(
                              age:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age,
                              gender:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender,
                              arogyaTopUpSumInsuredResModel:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel,
                              sumInsured: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                              deduction: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction,
                              memberDetails:  widget.memberDetailsModel,
                              memberIndex: widget.selectedMember
                          )
                      );
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                      Navigator.of(context).pop();
                    });
                  }
              });
            },
            child: SizedBox(
              width: 60,
              height: 60,
              child: (isGenderSelected && !isMale)
                  ? Image.asset(AssetConstants.ic_female_selected)
                  : Image.asset(AssetConstants.ic_female),
            ),
          ),
        ],
      );
    }
  }
}

class ArogyaTopUpAgeWidget extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  Function( int, bool, ArogyaFamilyIndividualModel) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  ArogyaTopUpAgeWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember,
      this.isUpdateVisible);

  @override
  _ArogyaTopUpAgeWidgetState createState() => _ArogyaTopUpAgeWidgetState();
}

class _ArogyaTopUpAgeWidgetState extends State<ArogyaTopUpAgeWidget> with CommonWidget {
  String dropdownValue;
  String sumInsuredValue;
  String deductionValue;
  List<Data> sumInsuredData;
  List<String> sumInsuredList;
  Data value;
  DeductionList deductionListData;
  List<DeductionList> list;


  @override
  void initState() {
    sumInsuredData=[];
    sumInsuredList=[];
    list=[];
    int age = ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age;
    String year = "years";
    if (age == 1) {
      year = "year";
    }
    dropdownValue = (age != null) ? (age == 0) ? "3 months to 1 year" : "$age $year" : null;

    if(ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel !=null){
      sumInsuredData=ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel.data;
      Set<String> sumInsured={} ;
      sumInsuredData.where((data) => sumInsured.add(data.suminsured)).toList();
      sumInsuredList=sumInsured.toList();
      sumInsuredList.sort((a,b)=>a.compareTo(b));
      sumInsuredValue=(ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured ==-1)
          ?null:
          ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured.toString();
      if(sumInsuredValue != null){
        for(var i=0;i<sumInsuredData.length;i++){
          if(sumInsuredData[i].suminsured == sumInsuredValue){
            list=sumInsuredData[i].deductionList;
            for(var k=0;k<list.length;k++){
              if(list[k].deduction==ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction){
                deductionListData=list[k];
              }
            }
          }
        }
      }
      deductionValue=(ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction == '-1')?null:ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction;
    }else{
      sumInsuredValue  = null;
      deductionValue=null;
      deductionListData=null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                  width: 1, color: ColorConstants.policy_type_gradient_color1),
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
                hint: Text(S.of(context).select_age_hint_title,style: TextStyle(fontSize: 14),),
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    int age = int.parse(newValue.split(' ').first);
                    print(newValue);
                    if (newValue.compareTo("3 months to 1 year") == 0) {
                      age = 0;
                    }
                    _sumInsuredApiCall(age);
                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = age;

                    if (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender != null
                        && ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured !=-1
                        &&  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction !='-1'
                        && !widget.isUpdateVisible) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        widget.onUpdate(
                            widget.selectedMember,
                            false,
                            ArogyaFamilyIndividualModel(
                                age:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age,
                                gender:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender,
                                arogyaTopUpSumInsuredResModel:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel,
                                sumInsured: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                                deduction: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction,
                                premium: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium,
                                memberDetails:  widget.memberDetailsModel,
                                memberIndex: widget.selectedMember
                            ));
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction='-1';
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
                items: widget.memberDetailsModel.ageList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(S.of(context).select_sum_insured.toUpperCase(), style: TextStyle(fontSize: 12, color: Colors.black),),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                  width: 1, color: ColorConstants.policy_type_gradient_color1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child:  DropdownButton<String>(
                icon: Icon(Icons.expand_more, color: Colors.grey[700],),
                underline: Text(''),
                isExpanded: true,
                hint: Text(S.of(context).select_sum_insured,style: TextStyle(fontSize: 14),),
                items: sumInsuredList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String newValue) {
                  setState(() {
                    sumInsuredValue = newValue;
                    deductionValue=null;
                    deductionListData=null;
                    try{
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=int.parse(newValue);
                    }catch(e){
                      ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                    }
                    for(var i=0;i<sumInsuredData.length;i++){
                      if(sumInsuredData[i].suminsured == newValue){
                        list=sumInsuredData[i].deductionList;
                        widget.memberDetailsModel.sumInsuredString=CommonUtil.instance.convertSumInsured(newValue);
                      }
                    }
                    if (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender != null
                        &&  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age!=-1
                        && ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction!='-1'
                        && !widget.isUpdateVisible ) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        widget.onUpdate(
                            widget.selectedMember,
                            false,
                            ArogyaFamilyIndividualModel(
                                age:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age,
                                gender:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender,
                                arogyaTopUpSumInsuredResModel:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel,
                                sumInsured: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                                deduction:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction,
                                premium: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium,
                                memberDetails:  widget.memberDetailsModel,
                                memberIndex: widget.selectedMember
                            )
                        );
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction='-1';
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
                value: sumInsuredValue,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(S.of(context).select_deductible_title.toUpperCase(),style: TextStyle(fontSize: 12, color: Colors.black,)),
          SizedBox(height: 10.0,),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(
                  width: 1, color: ColorConstants.policy_type_gradient_color1),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child:  DropdownButton<DeductionList>(
                icon: Icon(
                  Icons.expand_more,
                  color: Colors.grey[700],
                ),
                underline: Text(''),
                isExpanded: true,
                hint: Text(S.of(context).select_deductible_title,style: TextStyle(fontSize: 14),),
                items: list.map((data) {
                  return new DropdownMenuItem<DeductionList>(
                    child: new Text(data.deduction),
                    value: data,
                  );
                }).toList(),
                onChanged: (DeductionList newValue) {
                  setState(() {
                    deductionValue = newValue.deduction;
                    deductionListData=newValue;
                    widget.memberDetailsModel.deduction=(newValue.deduction);
                    widget.memberDetailsModel.deductionString=CommonUtil.instance.convertSumInsured(newValue.deduction);
                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction=newValue.deduction;
                    ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium=newValue.premium;

                    if (ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender != null
                        &&  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured!=-1
                        &&  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age !=null
                        && !widget.isUpdateVisible ) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        widget.onUpdate(
                            widget.selectedMember,
                            false,
                            ArogyaFamilyIndividualModel(
                                age:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age,
                                gender:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender,
                                arogyaTopUpSumInsuredResModel:  ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel,
                                sumInsured: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                                premium: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium,
                                deduction: ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction,
                                memberDetails:  widget.memberDetailsModel,
                                memberIndex: widget.selectedMember
                            )
                        );
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=null;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.sumInsured=-1;
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.deduction='-1';
                        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.premium='-1';
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
                value: deductionListData??null,
              ),
            ),
          ),
        ],
      );
  }

  void _sumInsuredApiCall(int age) async {
    retryIdentifier(int identifier) {
      _sumInsuredApiCall(age);
    }
    showLoaderDialog(context);
    var response = await SumInuredApiProvider.getInstance().getArogyaTopUpSumInsured(age);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      handleApiError(context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      setState(() {
        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel=ArogyaTopUpSumInsuredResModel();
        ArogyaTopUpMemberDetailsFamilyIndividualBottomSheetWidget.arogyaTopUpSumInsuredResModel = response;
        if(sumInsuredData!=null)sumInsuredData.clear();
        value=null;
        sumInsuredData=response?.data??[];
        Set<String> sumInsured={} ;
        sumInsuredData.where((data) => sumInsured.add(data.suminsured)).toList();
        sumInsuredList=sumInsured.toList();
        sumInsuredList.sort((a,b)=>a.compareTo(b));
        print('sumInsuredList ${sumInsuredList.toString()}');
      });
    }
  }
}
/*
class SumInsuredWidget extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  Function(int, String, int, bool, SumInsuredResModel, int, dynamic) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  SumInsuredWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember,
      this.isUpdateVisible);

  @override
  _SumInsuredWidgetState createState() => _SumInsuredWidgetState();
}

class _SumInsuredWidgetState extends State<SumInsuredWidget> {
  String dropdownValue;
  String premium='0';

  @override
  void initState() {
    dropdownValue = (MemberDetailsFamilyIndividualBottomSheetWidget.data !=null && MemberDetailsFamilyIndividualBottomSheetWidget.data.length>=1)?
    MemberDetailsFamilyIndividualBottomSheetWidget.data[0].suminsured :"0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
                width: 1, color: ColorConstants.policy_type_gradient_color1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child:  DropdownButton(
              icon: Icon(
                Icons.expand_more,
                color: Colors.grey[700],
              ),
              underline: Text(''),
              isExpanded: true,
              hint: Text(S.of(context).select_sum_insured),
              items: MemberDetailsFamilyIndividualBottomSheetWidget.data.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item.suminsured),
                  value: item.suminsured.toString(),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  dropdownValue = newValue;
                  for(var i=0;i<MemberDetailsFamilyIndividualBottomSheetWidget.data.length;i++){
                    if(MemberDetailsFamilyIndividualBottomSheetWidget.data[i].suminsured == newValue){
                      premium=MemberDetailsFamilyIndividualBottomSheetWidget.data[i].premium;
                    }
                  }
                  if (MemberDetailsFamilyIndividualBottomSheetWidget.gender != null && !widget.isUpdateVisible ) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      widget.onUpdate(
                          MemberDetailsFamilyIndividualBottomSheetWidget.age,
                          MemberDetailsFamilyIndividualBottomSheetWidget.gender,
                          widget.selectedMember,
                          false,MemberDetailsFamilyIndividualBottomSheetWidget.sumInsuredResModel,
                          MemberDetailsFamilyIndividualBottomSheetWidget.sumInsured,
                          premium);
                      MemberDetailsFamilyIndividualBottomSheetWidget.age = null;
                      MemberDetailsFamilyIndividualBottomSheetWidget.gender = null;
                      Navigator.of(context).pop();
                    });
                  }
                });
              },
              value: dropdownValue,
            ),
          ),
        ),


        SizedBox(
          height: 20.0,
        ),
        Text("PREMIUM",style: TextStyle(fontSize: 12, color: Colors.black)),
        SizedBox(height: 10.0,),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
                width: 1, color: ColorConstants.policy_type_gradient_color1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0,top: 15.0,bottom: 15.0),
            child: Text(CommonUtil.instance
                .getCurrencyFormat()
                .format(int.parse(premium??'0'))),
          ),
        ),
      ],
    );
  }
}*/
