import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/health_question/health_question_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/other_critical_illness_details_model.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/other_critical_illness_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'critical_health_question_screen.dart';
import 'critical_illness_insurance_buyer_details.dart';

class MultiOtherCriticalInsuranceDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness/multi_other_critical_illness_question";
  final CriticalIllnessModel _arguments;
  MultiOtherCriticalInsuranceDetailsScreen(this._arguments);
  static const double EXTRA_SPACE = 200;

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: HealthQuestionBloc(),
      child: MultiOtherCriticalInsuranceDetailsScreenWidget(_arguments),
    );
  }
}


class MultiOtherCriticalInsuranceDetailsScreenWidget  extends StatefulWidget {


  final CriticalIllnessModel criticalIllnessModel;

  MultiOtherCriticalInsuranceDetailsScreenWidget  (this.criticalIllnessModel);

  @override
  _MultiOtherCriticalInsuranceDetailsScreenState createState() =>
      _MultiOtherCriticalInsuranceDetailsScreenState(criticalIllnessModel);
}

class _MultiOtherCriticalInsuranceDetailsScreenState extends State<MultiOtherCriticalInsuranceDetailsScreenWidget> with CommonWidget {
  List<OtherCriticalIllnessDetailsScreen> widgetList = [];
  //int count = 0;
  double screenWidth;
  double screenHeight;
  HealthQuestionBloc healthQuestionBloc;

  final CriticalIllnessModel criticalIllnessModel;
  final GlobalKey key =GlobalKey<State>();

  _MultiOtherCriticalInsuranceDetailsScreenState(this.criticalIllnessModel);


  @override
  void initState() {
    healthQuestionBloc=SbiBlocProvider.of<HealthQuestionBloc>(context);
   // count = 0;
    if (widgetList.isEmpty) {
      var _widgetData = OtherCriticalIllnessDetailsModel();
      widgetList.add(OtherCriticalIllnessDetailsScreen(
        key: UniqueKey(),
        otherCriticalIllnessDetailsModel: _widgetData,
        onDelete:onDelete,
        isRemoveButtonEnabled: false,
        otherInsuranceCompanyList: criticalIllnessModel.otherInsuranceCompanyList,
       // index: 0,

      ));
     // count = widgetList.length + 1;
    }
    _listenForEvents();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil.getInstance(context).screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.critical_illness_bg_color,
      appBar: getAppBar(context, S.of(context).insured_details.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: screenHeight - MultiOtherCriticalInsuranceDetailsScreen.EXTRA_SPACE,
              child: ListView(
                children: <Widget>[
                  for(var i=0;i<widgetList.length;i++)
                    widgetList[i],
                  addAnotherPolicy(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height:
                MultiOtherCriticalInsuranceDetailsScreen.EXTRA_SPACE - 20,
                child: Column(
                  children: <Widget>[
                    quickFact(),
                    // SizedBox(height: 200,)
                  ],
                ),
              ),
            ),
            showNextButton(),
          ],
        ),
      ),
    );
  }

  Widget quickFact() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.critical_illness_bg_color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "*" + S.of(context).note,
                    style: TextStyle(
                        color: ColorConstants.disco,
                        fontSize: 11,
                        fontStyle: FontStyle.normal),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        Container(
//                          child: Text(
//                            '* ',
//                            textAlign: TextAlign.start,
//                          ),
//                        ),
                        Flexible(
                          //newly added
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                              child: Text(S.of(context).sum_insured_note,
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 11,
                                  ),
                                  softWrap: true),
                            )),
                        /*Text(
                         S.of(context).critical_note_proposer,
                        style: TextStyle(
                          color: ColorConstants.critical_illness_note_text_color
                        ),
                      ),*/
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  /// ON remove the other critical illness data
  onDelete(OtherCriticalIllnessDetailsModel data) {
    var find = widgetList.firstWhere(
          (it) => (it.otherCriticalIllnessDetailsModel != null && it.otherCriticalIllnessDetailsModel == data),
      orElse: () => null,
    );
    print('find $find');
    if (find != null){
      setState(() {
        widgetList.removeAt(widgetList.indexOf(find));
       // count = count - 1;
      });
    }

  }

  /// on add new Widget
  void onAddForm() {
    setState(() {
      var _widgetData = OtherCriticalIllnessDetailsModel();
      widgetList.add(OtherCriticalIllnessDetailsScreen(
        key :UniqueKey(),
        otherCriticalIllnessDetailsModel: _widgetData,
        onDelete:onDelete,
        isRemoveButtonEnabled: true,
        otherInsuranceCompanyList: criticalIllnessModel.otherInsuranceCompanyList,
       // index:count-1,
      ));
     // count = count + 1;
    });
  }

  Widget addAnotherPolicy() {
    return InkWell(
      onTap: onAddForm,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: CircleAvatar(
                      backgroundColor: ColorConstants.critical_illness_bg_color,
                      radius: 20.0,
                      child: Icon(
                        Icons.add,
                        color: ColorConstants.disco,
                      ),
                    ),
                    width: 32.0,
                    height: 32.0,
                    padding: const EdgeInsets.all(2.0),
                    // borde width
                    decoration: new BoxDecoration(
                      color: ColorConstants.disco,
                      // border color
                      shape: BoxShape.circle,
                    )),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  S.of(context).add_another_title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black,
                      letterSpacing: 0.5),
                ),
              ],
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget showNextButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.critical_illness_bg_color,
    );
  }

  onClick() {
    if (widgetList.length > 0) {
      var allValid = true;
      widgetList.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        List<OtherCriticalIllnessDetailsModel> data = widgetList.map((it) => it.otherCriticalIllnessDetailsModel).toList();
        widget.criticalIllnessModel.otherCriticalIllnessDetails=data;
        _makeHealthQuestionApiCall();
        // Navigator.of(context).pushNamed(CriticalHealthQuestionsScreen.ROUTE_NAME,arguments: widget.criticalIllnessModel );
      }
    }
  }

  _makeHealthQuestionApiCall() async {
    showLoaderDialog(context);
    final response = await healthQuestionBloc.getHealthQuestionContent(StringConstants.FROM_CRITICAL_ILLNESS);
    if (null != response) {
      hideLoaderDialog(context);
      criticalIllnessModel.healthQuestionResModel=response;
      Navigator.of(context).pushNamed(CriticalHealthQuestionsScreen.ROUTE_NAME,
          arguments: criticalIllnessModel);
    }
  }

  _listenForEvents() {
    healthQuestionBloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0,(int retryIdentifier) {
        _makeHealthQuestionApiCall();
      }, event.dialogType);

    });
  }
}
