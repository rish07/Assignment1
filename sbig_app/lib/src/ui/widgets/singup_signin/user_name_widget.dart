import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/controllers/blocs/singup_signin/signup_signin_bloc.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class UserNameWidget extends StatefulWidget {

  SingupSigninArguments arguments;

  UserNameWidget(this.arguments);

  @override
  _UserNameWidgetState createState() => _UserNameWidgetState(arguments);
}

class _UserNameWidgetState extends State<UserNameWidget> {

  SingupSigninArguments arguments;

  _UserNameWidgetState(this.arguments);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: arguments.singupSigninBloc.firstNameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError && arguments.onSubmit == true) {
          if (snapshot.error == ClaimIntimationValidator.EMPTY_ERROR) {
            arguments.errorText = S
                .of(context)
                .name_empty;
          }else if (snapshot.error == ClaimIntimationValidator.LENGTH_ERROR) {
            arguments.errorText = S
                .of(context)
                .invalid_name;
          }
        } else {
          arguments.errorText = null;
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Theme(
            data: new ThemeData(
              primaryColor: ColorConstants.text_field_blue,
              primaryColorDark: ColorConstants.claim_remark_color,
              accentColor: ColorConstants.claim_remark_color,
            ),
            child: TextField(
              autofocus: true,
              focusNode: widget.arguments.focusNode,
              controller: widget.arguments.textEditingController,
              textInputAction: TextInputAction.next,
              onChanged: (String value) {
                arguments.singupSigninBloc.changeFirstName(value);
              },
              onSubmitted: (value) {
                arguments.onNextPressed();
              },
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                LengthLimitingTextInputFormatter(50),
              ],
              style: const TextStyle(
                  letterSpacing: 1.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: arguments.errorText != null
                            ? Colors.red
                            : ColorConstants.policy_type_gradient_color2),
                  ),
                  // errorText: error,
                  labelText: S
                      .of(context)
                      .name_title
                      .toUpperCase(),
                  errorText: arguments.errorText,
                  errorStyle: TextStyle(color: Colors.red),
                  labelStyle: TextStyle(
                      letterSpacing: 1.0,
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      color: Colors.black54)),
            ),
          ),
        );
      },
    );
  }
}