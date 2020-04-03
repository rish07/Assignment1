import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/premium_details/critical_illness_validator.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/premium_details/critical_premium_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_sum_insured_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'critical_sum_insured_new_screen.dart';

class GrossIncomeScreen extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness/gross_income_screen";

  final GrossIncomeRequestArguments _arguments;

  const GrossIncomeScreen(this._arguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: GrossIncomeScreenWidget(_arguments),
      bloc: CriticalPremiumBloc(),
    );
  }
}

class GrossIncomeScreenWidget extends StatefulWidget {
  final GrossIncomeRequestArguments arguments;

  GrossIncomeScreenWidget(this.arguments);

  @override
  _GrossIncomeScreenState createState() => _GrossIncomeScreenState();
}

class _GrossIncomeScreenState extends State<GrossIncomeScreenWidget>
    with CommonWidget {
  double screenWidth;
  double screenHeight;
  final incomeController = TextEditingController();
  CriticalPremiumBloc _criticalIllnessBloc;
  String errorText;
  bool onSubmit = false;
  CriticalIllnessModel criticalIllnessModel;

  @override
  void initState() {
    _criticalIllnessBloc = SbiBlocProvider.of<CriticalPremiumBloc>(context);
    criticalIllnessModel=widget.arguments.criticalIllnessModel;
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
      backgroundColor: ColorConstants.critical_illness_bg_color,
      appBar: getAppBar(
          context,
          (criticalIllnessModel.policyCoverMemberModel
                      .memberDetailsModel.relation
                      .compareTo(S.of(context).self_title) ==
                  0)
              ? S.of(context).proposer_details.toUpperCase()
              : S.of(context).insured_details.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  questionWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  incomeFieldWidget(),
                  SizedBox(height: 150,)  /// added for the small mobile scrolling
                ],
              ),
            ),
            showNextButton(),
          ],
        ),
      ),
    );
  }

  Widget questionWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
      child: Text(
        (criticalIllnessModel.policyCoverMemberModel
                    .memberDetailsModel.relation
                    .compareTo(S.of(context).self_title) ==
                0)
            ? S.of(context).gross_income_proposer_member
            : S.of(context).gross_income_insure_member,
        style: TextStyle(
          fontSize: 28,
          fontFamily: StringConstants.EFFRA_LIGHT,
        ),
      ),
    );
  }

  Widget incomeFieldWidget() {
    return StreamBuilder(
        stream: _criticalIllnessBloc.incomeStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          errorText = null;
          bool _onSubmit = (onSubmit);
          if (isError) {
            switch (snapshot.error) {
              case CriticalIllnessValidator.EMPTY_ERROR:
                errorText = _onSubmit ? S.of(context).gross_income_error : null;
                break;
              case CriticalIllnessValidator.LENGTH_ERROR:
                errorText =
                    _onSubmit ? S.of(context).gross_income_invalid_error : null;
                break;
              case CriticalIllnessValidator.INVALID_ERROR:
                errorText =
                _onSubmit ? S.of(context).gross_income_invalid_error : null;
                break;
              default:
                errorText = (_onSubmit)
                    ? S.of(context).gross_income_invalid_error
                    : null;
                break;
            }
          } else if (snapshot.hasData) {
            errorText = null;
            //incomeController.text = snapshot.data;
            incomeController.value = TextEditingValue(
                text: snapshot.data,
                selection: TextSelection.collapsed(offset: snapshot.data.length));
            //incomeController.selection = TextSelection.fromPosition(
               // TextPosition(offset: incomeController.text.length));
          } else {
            errorText =
                (_onSubmit) ? S.of(context).gross_income_invalid_error : null;
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Theme(
              data: new ThemeData(
                primaryColor: ColorConstants.fuchsia_pink,
                // changes the under line colour
                primaryColorDark: ColorConstants.fuchsia_pink,
                accentColor: ColorConstants.fuchsia_pink,
              ),
              child: TextField(
                autofocus: true,
                controller: incomeController,
                onChanged: (String value) {
                  _criticalIllnessBloc.changeIncome(value);
                },
                textInputAction: TextInputAction.next,
                onSubmitted: (value) {
                  onClick();
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(30),
                ],
                style: TextStyle(
                    letterSpacing: 2.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 23.0),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 10.0),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500]),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.shiraz),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstants.fuchsia_pink),
                  ),
                  labelText: S.of(context).monthly_income.toUpperCase(),
                  errorText: errorText,
                  errorStyle: TextStyle(color: ColorConstants.shiraz),
                  labelStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.0),
                ),
              ),
            ),
          );
        });
  }

  Widget showNextButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.critical_illness_bg_color,
    );
  }

  onClick() {
    onSubmit = true;
    int defaultSumInsured = 200000;
    String amount = _criticalIllnessBloc.incomeValue ?? '';
    _criticalIllnessBloc.changeIncome(amount);
    print('AMOUNT : $amount');
    if (amount != null && amount.length > 0 ) {
      var amt=amount.replaceAll(',', '');
      var gender =criticalIllnessModel.policyCoverMemberModel.memberDetailsModel.ageGenderModel.gender;
      var employed = criticalIllnessModel.policyCoverMemberModel.memberDetailsModel.isEmployed;
      CriticalPremiumReqModel premiumReqModel = CriticalPremiumReqModel(
          age: criticalIllnessModel.policyCoverMemberModel
              .memberDetailsModel.ageGenderModel.age,
          sumInsured: defaultSumInsured,
      gender:gender,
      employed: (employed != null && !employed)?'No':'Yes',
      grossIncome: int.parse(amt)?? 0);

      CriticalSumInsuredReqModel reqModel = CriticalSumInsuredReqModel(
          age: criticalIllnessModel.policyCoverMemberModel
              .memberDetailsModel.ageGenderModel.age,
          //sumInsured: defaultSumInsured,
          gender:gender,
          employed: (employed != null && !employed)?'No':'Yes',
          grossIncome: int.parse(amt)?? 0);
      widget.arguments.criticalIllnessModel.criticalSumInsuredReqModel = reqModel;
      widget.arguments.criticalIllnessModel.grossIncome = amount;
      _apiCall(reqModel);

    }
  }

  @override
  void dispose() {
    _criticalIllnessBloc.dispose();
    incomeController.dispose();
    super.dispose();
  }

  void _navigate() {
    Navigator.of(context).pushNamed(CriticalSumInsuredScreenNew.ROUTE_NAME,
        arguments: widget.arguments.criticalIllnessModel);
  }

  _listenForEvents() {
    _criticalIllnessBloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0, (int retryIdentifier) {
        onClick();
      }, event.dialogType);
    });
  }

/*  _apiCall(CriticalIllnessModel criticalIllnessModel) async {
    showLoaderDialog(context);
    var response = await _criticalIllnessBloc.calculateCriticalPremium(criticalIllnessModel.premiumReqModel);
    print('RESPONSE ${response}');
    if (response != null) {
      hideLoaderDialog(context);
      criticalIllnessModel.premiumResModel = response;
      Navigator.of(context).pushNamed(CriticalSumInsuredScreenNew.ROUTE_NAME,
          arguments: widget.arguments.criticalIllnessModel);
    }
  }
}*/

_apiCall(CriticalSumInsuredReqModel reqModel) async {
    showLoaderDialog(context);
    var response = await _criticalIllnessBloc.getSumInsured(reqModel);
    print('RESPONSE ${response}');
    if (response != null) {
      hideLoaderDialog(context);
      criticalIllnessModel.criticalSumInsuredResModel = response;
      Navigator.of(context).pushNamed(CriticalSumInsuredScreenNew.ROUTE_NAME,
          arguments: widget.arguments.criticalIllnessModel);
    }
  }
}

class GrossIncomeRequestArguments {
  final CriticalIllnessModel criticalIllnessModel;

  GrossIncomeRequestArguments(this.criticalIllnessModel);
}
