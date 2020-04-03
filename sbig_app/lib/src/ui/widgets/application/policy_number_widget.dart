import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/controllers/blocs/singup_signin/signup_signin_bloc.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class PolicyNumberWidget extends StatefulWidget {

  SingupSigninArguments arguments;

  PolicyNumberWidget(this.arguments);

  @override
  _PolicyNumberWidgetState createState() => _PolicyNumberWidgetState(arguments);
}

class _PolicyNumberWidgetState extends State<PolicyNumberWidget> {

  SingupSigninArguments arguments;

  _PolicyNumberWidgetState(this.arguments);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: arguments.singupSigninBloc.policyNumberStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          arguments.errorText = null;
          bool _onSubmit = arguments.onSubmit;
          if (isError) {
            switch (snapshot.error) {
              case ClaimIntimationValidator.EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                arguments.errorText =
                _onSubmit ? S.of(context).policy_number_error : null;
                break;
              case ClaimIntimationValidator.LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                arguments.errorText =
                _onSubmit ? S.of(context).invalid_policy_number : null;
                break;
              default:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                arguments.errorText =
                (_onSubmit) ? S.of(context).invalid_policy_number : null;
                break;
            }
          } else if (snapshot.hasData) {
            arguments.errorText = null;
            image = Image.asset(AssetConstants.ic_correct);
          } else {
            image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
            arguments.errorText =
            (_onSubmit) ? S.of(context).invalid_policy_number : null;
          }

          return Stack(
              children: <Widget>[
                Theme(
                  data: new ThemeData(
                    primaryColor: ColorConstants.text_field_blue,
                    // changes the under line colour
                    primaryColorDark: ColorConstants.text_field_blue,
                    accentColor: ColorConstants.text_field_blue,
                  ),
                  child: TextField(
                    autofocus: true,
                    focusNode: arguments.focusNode,
                    onChanged: (String value) {
                      arguments.singupSigninBloc.changePolicyNumber(value);
                    },
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      // _claimIntimationBloc.changePolicyNumber(value);
                      //onClick();
                    },
                    controller: arguments.textEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 22.0),
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
                      S.of(context).policy_no.toUpperCase(),
                      errorText: arguments.errorText,
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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
          );
        });
  }
}

class PolicyNumberArguments{
  String errorText;
  bool onSubmit;
  SingupSigninBloc singupSigninBloc;

  PolicyNumberArguments({this.errorText, this.onSubmit, this.singupSigninBloc});


}