import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewals_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_req_res_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_policy_summery_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/quick_fact_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class RenewalPolicyDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/renewals/policy_details_screen";

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: RenewalPolicyDetailsWidget(),
      bloc: RenewalsBloc(),
    );
  }
}

class RenewalPolicyDetailsWidget extends StatefulWidget {
  @override
  _RenewalPolicyDetailsWidgetState createState() =>
      _RenewalPolicyDetailsWidgetState();
}

class _RenewalPolicyDetailsWidgetState extends State<RenewalPolicyDetailsWidget>
    with CommonWidget {
  final policyNumberController = TextEditingController();
  RenewalsBloc _renewalsBloc;
  String errorText;
  bool onSubmit = false;
  String policyNumber;
//  String policyType = "HealthRenewal";
//  String productCode = "HEIV001";
  String policyType = "Renewal";
  String productCode = "PMCAR01";

  @override
  void initState() {
    _renewalsBloc =
        SbiBlocProvider.of<RenewalsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    policyNumberController.dispose();
    _renewalsBloc.dispose();
    super.dispose();
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
                  margin: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
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
                            policyNumberWidget(),
                          ],
                        ),
                      ),
                      QuickFactWidget(StringDescription.quick_fact1),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
              _showSubmitButton(),
            ],
          ),
        ));
  }

  Widget policyNumberWidget() {
    return StreamBuilder(
        stream: _renewalsBloc.policyNumberStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          errorText = null;
          bool _onSubmit = (onSubmit);
          if (isError) {
            switch (snapshot.error) {
              case ClaimIntimationValidator.EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText =
                    _onSubmit ? S.of(context).policy_number_error : null;
                break;
              case ClaimIntimationValidator.LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText =
                    _onSubmit ? S.of(context).invalid_policy_number : null;
                break;
              default:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText =
                    (_onSubmit) ? S.of(context).invalid_policy_number : null;
                break;
            }
          } else if (snapshot.hasData) {
            errorText = null;
            image = Image.asset(AssetConstants.ic_correct);
          } else {
            image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
            errorText =
                (_onSubmit) ? S.of(context).invalid_policy_number : null;
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
            child: Stack(
              children: <Widget>[
                Theme(
                  data: new ThemeData(
                    primaryColor: ColorConstants.text_field_blue,
                    // changes the under line colour
                    primaryColorDark: ColorConstants.text_field_blue,
                    accentColor: ColorConstants.text_field_blue,
                  ),
                  child: TextField(
                    controller: policyNumberController,
                    onChanged: (String value) {
                      _renewalsBloc.changePolicyNumber(value);
                    },
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      // _claimIntimationBloc.changePolicyNumber(value);
                      //onClick();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 23.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right: 10.0, bottom: 5.0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.policy_type_gradient_color2),
                      ),
                      labelText:
                          S.of(context).policy_number_title.toUpperCase(),
                      errorText: errorText,
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 15,
                    child: SizedBox(height: 25, width: 25, child: image))
              ],
            ),
          );
        });
  }

  _apiCallToGetPolicyDetails() {

//    retry(int from){
//      _apiCallToGetPolicyDetails();
//    }
//
//    showLoaderDialog(context);
//    RenewalPolicyDetailsReqModel renewalPolicyDetailsReqModel =
//        RenewalPolicyDetailsReqModel();
//    renewalPolicyDetailsReqModel.policyNumber = policyNumber;
//    renewalPolicyDetailsReqModel.policytype = policyType;
//    renewalPolicyDetailsReqModel.productCode = productCode;
//    _renewalsBloc
//        .getPolicyDetails(renewalPolicyDetailsReqModel.toJson())
//        .then((response) {
//      hideLoaderDialog(context);
//      if (null != response.apiErrorModel) {
//        handleApiError(context, 0, retry, response.apiErrorModel.statusCode, message: response.apiErrorModel.message);
//      } else {
//          RenewalReqResModel renewalReqResModel = RenewalReqResModel(
//              renewalPolicyDetailsReqModel: renewalPolicyDetailsReqModel,
//              renewalPolicyDetailsResModel: response.data);
//          Navigator.of(context).pushNamed(RenewalPolicySummeryScreen.ROUTE_NAME,
//              arguments: renewalReqResModel);
//      }
//    });
  }

  _showSubmitButton() {
    onClick() {
      policyNumber = _renewalsBloc.policyNumber ?? '';
      if (policyNumber.length != 16) {
        onSubmit = true;
        _renewalsBloc.changePolicyNumber(policyNumber);
      } else {
        _apiCallToGetPolicyDetails();
      }
    }

    return Container(
      child: BlackButtonWidget(
        onClick,
        S.of(context).submit.toUpperCase(),
        isNormal: false,
        padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
        bottomBgColor: ColorConstants.personal_details_bg_color,
      ),
    );
  }
}
