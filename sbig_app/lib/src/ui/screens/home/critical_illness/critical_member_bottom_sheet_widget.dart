import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class CriticalIllnessMemberDetailsBottomSheetWidget {
  final MemberDetailsModel memberDetailsModel;
  final Function(int, String, int, bool) onUpdate;
  final int selectedMember;
  static bool isEmployed ;
  bool isUpdateVisible = false;
  static int age;
  static String gender;

  static const int YES_BUTTON_VALUE=1;
  static const int NO_BUTTON_VALUE=2;

  CriticalIllnessMemberDetailsBottomSheetWidget(
      this.memberDetailsModel, this.onUpdate, this.selectedMember);

  void showBottomSheet(context) {
    AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
    age = ageGenderModel.age;
    gender = ageGenderModel.gender;
    isEmployed=memberDetailsModel.isEmployed;
    if (gender == null) {
      gender = ageGenderModel.defaultGender;
    }
    isUpdateVisible = (age != null && gender != null && isEmployed !=null);

    onClickUpdateDetails() {
      onUpdate(
          CriticalIllnessMemberDetailsBottomSheetWidget.age,
          CriticalIllnessMemberDetailsBottomSheetWidget.gender,
          selectedMember,
          CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed);
      CriticalIllnessMemberDetailsBottomSheetWidget.age = null;
      CriticalIllnessMemberDetailsBottomSheetWidget.gender = null;
      CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed = null;
      Navigator.of(context).pop();
    }

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            height: 22,
                            width: 22,
                            child: (memberDetailsModel.icon ==null || memberDetailsModel.icon.length==0)?Image.asset(AssetConstants.ic_self): Image(image: NetworkImage(  UrlConstants.ICON + memberDetailsModel.icon),),),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            memberDetailsModel.relation,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      !TextUtils.isEmpty(
                              memberDetailsModel.ageGenderModel.defaultGender)
                          ? S.of(context).gender_title.toUpperCase()
                          : S.of(context).select_gender_title.toUpperCase(),
                      style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: GenderListWidget(memberDetailsModel, onUpdate,
                        selectedMember, isUpdateVisible),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      S.of(context).select_age_title.toUpperCase(),
                      style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: AgeWidget(memberDetailsModel, onUpdate, selectedMember,
                        isUpdateVisible),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 20.0),
                    child: Employment(memberDetailsModel, onUpdate, selectedMember, isUpdateVisible),
                  ),
//                  SizedBox(
//                    height: 0.0,
//                  ),
                  if (isUpdateVisible)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: BlackButtonWidget(
                        onClickUpdateDetails,
                        S.of(context).update_details_title.toUpperCase(),
                        titleFontSize: 12.0,
                        width: 170,
                        height: 35.0,
                        padding: EdgeInsets.all(0.0),
                      ),
                    ),

                ],
              ));
        });
  }
}

class GenderListWidget extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  Function(int, String, int, bool) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  GenderListWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember,
      this.isUpdateVisible);

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
          width: 50,
          height: 50,
          child: (widget.memberDetailsModel.ageGenderModel.defaultGender
                      .compareTo("M") ==
                  0)
              ? Image.asset(AssetConstants.ic_male_selected)
              : Image.asset(AssetConstants.ic_female_selected),
        ),
      );
    } else {
      bool isGenderSelected = !TextUtils.isEmpty(
          CriticalIllnessMemberDetailsBottomSheetWidget.gender);
      bool isMale = !isGenderSelected
          ? false
          : (CriticalIllnessMemberDetailsBottomSheetWidget.gender
                  .compareTo("M") ==
              0);

      return Row(
        children: <Widget>[
          InkResponse(
            onTap: () {
              setState(() {
//                widget.memberDetailsModel.ageGenderModel.gender = "M";
                CriticalIllnessMemberDetailsBottomSheetWidget.gender = "M";
                if (CriticalIllnessMemberDetailsBottomSheetWidget.age != null &&
                    CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed!=null &&
                    !widget.isUpdateVisible) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    widget.onUpdate(
                        CriticalIllnessMemberDetailsBottomSheetWidget.age,
                        CriticalIllnessMemberDetailsBottomSheetWidget.gender,
                        widget.selectedMember,
                        CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed);
                    CriticalIllnessMemberDetailsBottomSheetWidget.age = null;
                    CriticalIllnessMemberDetailsBottomSheetWidget.gender = null;
                    CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed=null;
                    Navigator.of(context).pop();
                  });
                }
              });
            },
            child: SizedBox(
              width: 50,
              height: 50,
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
                CriticalIllnessMemberDetailsBottomSheetWidget.gender = "F";
//                widget.onUpdate(
//                    MemberDetailsBottomSheetWidget.age,
//                    MemberDetailsBottomSheetWidget.gender,
//                    widget.selectedMember,
//                    false);

                if (CriticalIllnessMemberDetailsBottomSheetWidget.age != null &&
                    CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed!=null &&
                    !widget.isUpdateVisible) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    widget.onUpdate(
                        CriticalIllnessMemberDetailsBottomSheetWidget.age,
                        CriticalIllnessMemberDetailsBottomSheetWidget.gender,
                        widget.selectedMember,
                        CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed);
                    CriticalIllnessMemberDetailsBottomSheetWidget.age = null;
                    CriticalIllnessMemberDetailsBottomSheetWidget.gender = null;
                    CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed=null;
                    Navigator.of(context).pop();
                  });
                }
              });
            },
            child: SizedBox(
              width: 50,
              height: 50,
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

  AgeWidget(this.memberDetailsModel, this.onUpdate, this.selectedMember,
      this.isUpdateVisible);

  @override
  _AgeWidgetState createState() => _AgeWidgetState();
}

class _AgeWidgetState extends State<AgeWidget> {
  String dropdownValue;

  @override
  void initState() {
    int age = CriticalIllnessMemberDetailsBottomSheetWidget.age;
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
            width: 1, color: Colors.black),
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
              CriticalIllnessMemberDetailsBottomSheetWidget.age = age;

              if (CriticalIllnessMemberDetailsBottomSheetWidget.gender != null &&
                  CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed!=null &&
                  !widget.isUpdateVisible) {
                Future.delayed(Duration(milliseconds: 500), () {
                  widget.onUpdate(
                      CriticalIllnessMemberDetailsBottomSheetWidget.age,
                      CriticalIllnessMemberDetailsBottomSheetWidget.gender,
                      widget.selectedMember,
                      CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed);
                  CriticalIllnessMemberDetailsBottomSheetWidget.age = null;
                  CriticalIllnessMemberDetailsBottomSheetWidget.gender = null;
                  CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed=true;
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

class Employment extends StatefulWidget {
  MemberDetailsModel memberDetailsModel;
  Function(int, String, int,bool) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  Employment(this.memberDetailsModel, this.onUpdate, this.selectedMember,
      this.isUpdateVisible);

  @override
  _EmploymentState createState() => _EmploymentState();
}

class _EmploymentState extends State<Employment> {

  int selectedRadio;

  @override
  void initState() {
    print('EMP : ${CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed.toString()}');
    if(CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed != null ){
      if(CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed){
        selectedRadio= CriticalIllnessMemberDetailsBottomSheetWidget.YES_BUTTON_VALUE;
      }else {
        selectedRadio= CriticalIllnessMemberDetailsBottomSheetWidget.NO_BUTTON_VALUE;
      }
    }
    super.initState();
  }

  setSelectedRadioValue(int value){
    setState(() {
      selectedRadio=value;
      CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed = (value== CriticalIllnessMemberDetailsBottomSheetWidget.YES_BUTTON_VALUE)?true:false;
      if (CriticalIllnessMemberDetailsBottomSheetWidget.age != null && CriticalIllnessMemberDetailsBottomSheetWidget.gender !=null && !widget.isUpdateVisible) {
        Future.delayed(Duration(milliseconds: 500), () {
          widget.onUpdate(
              CriticalIllnessMemberDetailsBottomSheetWidget.age,
              CriticalIllnessMemberDetailsBottomSheetWidget.gender,
              widget.selectedMember,
              CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed);

          CriticalIllnessMemberDetailsBottomSheetWidget.age = null;
          CriticalIllnessMemberDetailsBottomSheetWidget.gender = null;
          CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed=null;
          Navigator.of(context).pop();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 20.0),
          child: Text(
            S.of(context).employed.toUpperCase(),
            style: TextStyle(
              fontSize:10,
              color: Colors.black, fontWeight: FontWeight.w500
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Radio(
                value: CriticalIllnessMemberDetailsBottomSheetWidget.YES_BUTTON_VALUE,
                groupValue: selectedRadio ,
                activeColor: ColorConstants.disco,
                onChanged: (value){
                  print(value);
                  setSelectedRadioValue(value);
                },
              ),
            ),
            SizedBox(width: 5,),
            Text(S.of(context).yes),
            SizedBox(width: 20,),
            Radio(
              value: CriticalIllnessMemberDetailsBottomSheetWidget.NO_BUTTON_VALUE,
              groupValue: selectedRadio,
              activeColor: ColorConstants.disco,
              onChanged: (value){
                print(value);
                setSelectedRadioValue(value);
              },
            ),
            SizedBox(width: 5,),
            Text(S.of(context).no),
          ],
        ),
      ],
    );
  }
}
