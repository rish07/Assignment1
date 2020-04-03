import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class MemberDetailsBottomSheetWidget {
  final MemberDetailsModel memberDetailsModel;
  final Function(int, String, int, bool) onUpdate;
  final int policyType;
  final int selectedMember;
  bool isUpdateVisible = false;

  static int age;
  static String gender;

  MemberDetailsBottomSheetWidget(this.memberDetailsModel, this.onUpdate,
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
          MemberDetailsBottomSheetWidget.age,
          MemberDetailsBottomSheetWidget.gender,
          selectedMember,
          false);
      MemberDetailsBottomSheetWidget.age = null;
      MemberDetailsBottomSheetWidget.gender = null;
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
                                MemberDetailsBottomSheetWidget.age = null;
                                MemberDetailsBottomSheetWidget.gender = null;
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
}

class GenderListWidget extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  Function(int, String, int, bool) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  GenderListWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember, this.isUpdateVisible);

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
      bool isGenderSelected =
          !TextUtils.isEmpty(MemberDetailsBottomSheetWidget.gender);
      bool isMale = !isGenderSelected
          ? false
          : (MemberDetailsBottomSheetWidget.gender.compareTo("M") ==
              0);

      return Row(
        children: <Widget>[
          InkResponse(
            onTap: () {
              setState(() {
//                widget.memberDetailsModel.ageGenderModel.gender = "M";
                MemberDetailsBottomSheetWidget.gender = "M";
                if (MemberDetailsBottomSheetWidget.age != null && !widget.isUpdateVisible) {
                  Future.delayed(Duration(milliseconds: 500), ()
                  {
                    widget.onUpdate(
                        MemberDetailsBottomSheetWidget.age,
                        MemberDetailsBottomSheetWidget.gender,
                        widget.selectedMember,
                        false);
                    MemberDetailsBottomSheetWidget.age = null;
                    MemberDetailsBottomSheetWidget.gender = null;
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
//                widget.memberDetailsModel.ageGenderModel.gender = "F";
                MemberDetailsBottomSheetWidget.gender = "F";
//                widget.onUpdate(
//                    MemberDetailsBottomSheetWidget.age,
//                    MemberDetailsBottomSheetWidget.gender,
//                    widget.selectedMember,
//                    false);

                if (MemberDetailsBottomSheetWidget.age != null && !widget.isUpdateVisible) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    widget.onUpdate(
                        MemberDetailsBottomSheetWidget.age,
                        MemberDetailsBottomSheetWidget.gender,
                        widget.selectedMember,
                        false);
                    MemberDetailsBottomSheetWidget.age = null;
                    MemberDetailsBottomSheetWidget.gender = null;
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

class AgeWidget extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  Function(int, String, int, bool) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  AgeWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember, this.isUpdateVisible);

  @override
  _AgeWidgetState createState() => _AgeWidgetState();
}

class _AgeWidgetState extends State<AgeWidget> {
  String dropdownValue;

  @override
  void initState() {
    int age = MemberDetailsBottomSheetWidget.age ;
    String year = "years";
    if (age == 1) {
      year = "year";
    }
    dropdownValue =
        (age != null) ? (age == 0) ? "3 months to 1 year" : "$age $year" : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          hint: Text(S.of(context).select_age_hint_title),
          value: dropdownValue,
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
              int age = int.parse(newValue.split(' ').first);
              print(newValue);
              if (newValue.compareTo("3 months to 1 year") == 0) {
                age = 0;
              }
              //widget.memberDetailsModel.ageGenderModel.age = age;
              MemberDetailsBottomSheetWidget.age = age;

              if (MemberDetailsBottomSheetWidget.gender != null && !widget.isUpdateVisible) {
                Future.delayed(Duration(milliseconds: 500), () {
                  widget.onUpdate(
                      MemberDetailsBottomSheetWidget.age,
                      MemberDetailsBottomSheetWidget.gender,
                      widget.selectedMember,
                      false);
                  MemberDetailsBottomSheetWidget.age = null;
                  MemberDetailsBottomSheetWidget.gender = null;
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
    );
  }
}
