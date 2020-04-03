import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/health_question/health_question_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_bloc.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_health_question_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_individual_member_details.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/insuree_details_dialog.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class ArogyaTopUpInsureDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_top_up/inusree_details_screen";

  final ArogyaTopUpModel arogyaTopUpModel;

  ArogyaTopUpInsureDetailsScreen(this.arogyaTopUpModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: InsureDetailsScreenWidget(arogyaTopUpModel),
      bloc: InsureeDetailsBloc(),
    );
  }
}

class InsureDetailsScreenWidget extends StatefulWidgetBase {
  final ArogyaTopUpModel arogyaTopUpModel;

  InsureDetailsScreenWidget(this.arogyaTopUpModel);

  @override
  _InsureDetailsScreenWidgetState createState() =>
      _InsureDetailsScreenWidgetState();
}

class _InsureDetailsScreenWidgetState extends State<InsureDetailsScreenWidget>
    with CommonWidget {
  int _selectedIndex, _previousSelectedIndex = -1;
  bool _isFamilyFloaterorIndividual = false, isAlertVisible = false;
  Set<int> selectedMembers = Set();
  InsureeDetailsBloc _bloc;
  List<PolicyCoverMemberModel> policyMembers;
  String errorMessage = '';
  bool isNextButtonEnable = false;
  ArogyaTopUpModel arogyaTopUpModel;

  @override
  void initState() {
    arogyaTopUpModel = widget.arogyaTopUpModel;
    _isFamilyFloaterorIndividual = (arogyaTopUpModel.policyType.id != 0);
    _bloc = SbiBlocProvider.of<InsureeDetailsBloc>(context);
    policyMembers = arogyaTopUpModel.policyMembers;
    if (widget.arogyaTopUpModel.policyType.id ==
        PolicyTypeScreen.INDIVIDUAL) {
      selectedMembers.add(0);
      isNextButtonEnable=true;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    int i = 0;
    bool isSpouseSelected = false;
    PolicyType policyType = arogyaTopUpModel.policyType;
    for (PolicyCoverMemberModel listModel in policyMembers) {
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
        for (PolicyCoverMemberModel listModel in policyMembers) {
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
                      child: QuickFactWidget(StringDescription.quick_fact22),
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
      arogyaTopUpModel.policyMembers = policyMembers;
      _makeHealthApiCall();
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
    bool isSelected = (selectedMembers.contains(index));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap: () {
          if (widget.arogyaTopUpModel.policyType.id ==
              PolicyTypeScreen.INDIVIDUAL) {
            Navigator.popUntil(
                context,
                ModalRoute.withName(
                    ArogyaTopUpIndividualMemberDetailsScreen.ROUTE_NAME));
          } else {
            _onSelected(index);
          }
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

  _makeHealthApiCall() async {
    retryIdentifier(int identifier) {
      _makeHealthApiCall();
    }
    showLoaderDialog(context);
    final response = await HealthQuestionApiProvider.getInstance()
        .getHealthQuestionContent(StringConstants.FROM_AROGYA_TOP_UP);
    hideLoaderDialog(context);

    if (null != response.apiErrorModel) {
      handleApiError(context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      HealthQuestionResModel healthQuestionResModel = response;
      arogyaTopUpModel.healthQuestionResModel = healthQuestionResModel;
      Navigator.of(context).pushNamed(ArogyaTopUpHealthQuestion.ROUTE_NAME,
          arguments:arogyaTopUpModel);
    }
  }

  @override
  void dispose() async {
    _bloc.dispose();
    super.dispose();
  }
}
