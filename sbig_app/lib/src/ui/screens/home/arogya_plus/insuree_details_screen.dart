import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/ped_questions_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/insuree_details_dialog.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class InsureeDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_plus/inusree_details_screen";

  final SelectedMemberDetails selectedMemberDetails;

  InsureeDetailsScreen(this.selectedMemberDetails);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: InsureeDetailsScreenWidget(selectedMemberDetails),
      bloc: InsureeDetailsBloc(),
    );
  }
}

class InsureeDetailsScreenWidget extends StatefulWidgetBase {
  final SelectedMemberDetails selectedMemberDetails;

  InsureeDetailsScreenWidget(this.selectedMemberDetails);

  @override
  _InsureeDetailsScreenWidgetState createState() =>
      _InsureeDetailsScreenWidgetState();
}

class _InsureeDetailsScreenWidgetState extends State<InsureeDetailsScreenWidget>
    with CommonWidget {
  int _selectedIndex, _previousSelectedIndex = -1;
  bool _isFamilyFloaterorIndividual = false, isAlertVisible = false;
  Set<int> selectedMembers = Set();
  InsureeDetailsBloc _bloc;
  List<GeneralListModel> policyMembers;
  String errorMessage = '';
  bool isNextButtonEnable = false;

  @override
  void initState() {
    _isFamilyFloaterorIndividual =
        (widget.selectedMemberDetails.policyType.id != 0);
    _bloc = SbiBlocProvider.of<InsureeDetailsBloc>(context);
    policyMembers = widget.selectedMemberDetails.policyMembers;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    int i = 0;
    bool isSpouseSelected = false;
    PolicyType policyType = widget.selectedMemberDetails.policyType;
    for (GeneralListModel listModel in policyMembers) {
      MemberDetailsModel memberDetailsModel = listModel.memberDetailsModel;
      if (memberDetailsModel.relation.compareTo(S.of(context).spouse_title) ==
          0) {
        isSpouseSelected = true;
        break;
      }
      i++;
    }
    switch (policyType.id) {
      case PolicyTypeScreen.INDIVIDUAL:
        break;
      case PolicyTypeScreen.FAMILY_FLOATER:
      case PolicyTypeScreen.FAMILY_INDIVIDUAL:
        int i = 0;
        for (GeneralListModel listModel in policyMembers) {
          MemberDetailsModel memberDetailsModel = listModel.memberDetailsModel;
          if (memberDetailsModel.relation.compareTo(S.of(context).self_title) ==
              0) {
            if (isSpouseSelected) {
              memberDetailsModel.isMarried = true;
              memberDetailsModel.maritalStatusIsFixed = true;
            } else {
              memberDetailsModel.isMarried =
                  (memberDetailsModel.isMarried != null)
                      ? memberDetailsModel.isMarried
                      : null;
              memberDetailsModel.maritalStatusIsFixed = null;
            }
            policyMembers[i].memberDetailsModel = memberDetailsModel;
            break;
          }
          i++;
        }
        break;
    }
    super.didChangeDependencies();
  }

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      MemberDetailsModel memberDetailsModel =
          policyMembers[_selectedIndex].memberDetailsModel;
      if (null != memberDetailsModel.ageGenderModel.dob) {
        _bloc.changeDob(memberDetailsModel.ageGenderModel.dob);
      } else {
        _bloc.changeDob('');
      }
      if (null != memberDetailsModel.firstName) {
        _bloc.changeFirstName(memberDetailsModel.firstName);
      } else {
        _bloc.changeFirstName('');
      }
      if (null != memberDetailsModel.lastName) {
        _bloc.changeLastName(memberDetailsModel.lastName);
      } else {
        _bloc.changeLastName('');
      }
      if (null != memberDetailsModel.isMarried) {
        _bloc.changeMartialStatus(memberDetailsModel.isMarried);
      } else {
        _bloc.changeMartialStatus(false);
      }
      InsureeDetailsDialog().showInsureeDetailsDialog(context, _bloc,
          policyMembers[_selectedIndex].memberDetailsModel, _onUpdate);
    });
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
                      crossAxisSpacing: 10.0,
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
                      child: QuickFactWidget(StringDescription.quick_fact11),
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
      widget.selectedMemberDetails.policyMembers = policyMembers;
      Navigator.of(context).pushNamed(PedQuestionsScreen.ROUTE_NAME,
          arguments: widget.selectedMemberDetails);
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

//  Widget _showButton() {
//    onClick() {
//      widget.selectedMemberDetails.policyMembers = policyMembers;
//      print(widget.selectedMemberDetails.toString());
//      Navigator.of(context).pushNamed(PedQuestionsScreen.ROUTE_NAME,
//          arguments: widget.selectedMemberDetails);
//      setState(() {
//        if (selectedMembers.length != policyMembers.length) {
//          int i = 0;
//          for (GeneralListModel item in policyMembers) {
//            if (!selectedMembers.contains(i)) {
//              errorMessage = S.of(context).please_fill_member_details +
//                  item.memberDetailsModel.relation;
//              break;
//            }
//            i++;
//          }
//          isAlertVisible = true;
//        } else {
//          widget.selectedMemberDetails.policyMembers = policyMembers;
//          print(widget.selectedMemberDetails.toString());
//          Navigator.of(context).pushNamed(PedQuestionsScreen.ROUTE_NAME,
//              arguments: widget.selectedMemberDetails);
//        }
//      });
//    }
//
//    return BlackButtonWidget(
//      onClick,
//      S.of(context).next.toUpperCase(),
//      bottomBgColor: ColorConstants.arogya_plus_bg_color,
//    );
//  }

//  _onUpdate(MemberDetailsModel memberDetailsModel) {
//    policyMembers[_selectedIndex].memberDetailsModel = memberDetailsModel;
//    setState(() {
//      selectedMembers.add(_selectedIndex);
//    });
//  }

  Widget buildListItem(GeneralListModel policyMember, int index) {
    bool isSelected = (selectedMembers.contains(index));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap: () {
//          if (isAlertVisible) {
//            setState(() {
//              isAlertVisible = false;
//            });
//          }
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
                    left: 10.0, right: 5.0, top: 0.0, bottom: 0.0),
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
      ),
    );
  }

  Widget memberDetailslWidget(int index) {
    String ageGenderString = '';
    String tempData = "Name, DOB";
    MemberDetailsModel memberDetailsModel =
        policyMembers[index].memberDetailsModel;

    bool isSelected = (selectedMembers.contains(index));

    String martialStatus = '';
    String fullName = '';
    // making as per design
    String dob = 'Martial Status';

    if (memberDetailsModel != null) {
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
      if (!TextUtils.isEmpty(ageGenderModel.gender) ||
          ageGenderModel.age != null) {
        ageGenderString =
            "${ageGenderModel.gender}, ${ageGenderModel.age == 0 ? "3 months to 1 year" : ageGenderModel.age}";
      }

      print(memberDetailsModel.firstName);
      if (!TextUtils.isEmpty(memberDetailsModel.firstName) &&
          !TextUtils.isEmpty(memberDetailsModel.lastName)) {
        fullName =
            memberDetailsModel.firstName + " " + memberDetailsModel.lastName;
        martialStatus = "Unmarrried";
        if (null != memberDetailsModel.isMarried &&
            memberDetailsModel.isMarried) {
          martialStatus = "Married";
        }
        ageGenderString = ageGenderString + ", $martialStatus";
        dob = ageGenderModel.dob;

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
      ],
    );
  }

  @override
  void dispose() async {
    _bloc.dispose();
    super.dispose();
  }
}
