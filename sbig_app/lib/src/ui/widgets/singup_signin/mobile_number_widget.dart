import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_validator.dart';
import 'package:sbig_app/src/controllers/blocs/singup_signin/signup_signin_bloc.dart';
import 'package:sbig_app/src/ui/widgets/application/policy_number_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_widget.dart';
import 'package:sbig_app/src/ui/widgets/singup_signin/policy_details_calender_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';

class MobileNumberWidget extends StatefulWidget {
  SingupSigninArguments singupSigninArguments;

  MobileNumberWidget(this.singupSigninArguments);

  @override
  _MobileNumberWidgetState createState() => _MobileNumberWidgetState();
}

class _MobileNumberWidgetState extends State<MobileNumberWidget>
    with CommonWidget {
  SingupSigninArguments singupSigninArguments;

  @override
  void initState() {
    singupSigninArguments = widget.singupSigninArguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              S.of(context).mobile_no_verification_message + ' ',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: StringConstants.EFFRA_LIGHT,
                  fontSize: 18.0),
            ),
            SizedBox(
              height: 25,
            ),
            StreamBuilder(
                stream: singupSigninArguments.singupSigninBloc.mobileStream,
                builder: (context, snapshot) {
                  Image image = Image.asset(AssetConstants.ic_correct);
                  bool isError = snapshot.hasError;
                  singupSigninArguments.errorText = null;
                  bool _onSubmit = (singupSigninArguments.onSubmit);
                  if (isError) {
                    switch (snapshot.error) {
                      case PersonalDetailsValidator.MOBILE_EMPTY_ERROR:
                        image =
                        _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                        singupSigninArguments.errorText = _onSubmit
                            ? S.of(context).mobile_number_empty_error
                            : null;
                        break;
                      case PersonalDetailsValidator.MOBILE_LENGTH_ERROR:
                        image =
                        _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                        singupSigninArguments.errorText = _onSubmit
                            ? S.of(context).invalid_mobile_number_error
                            : null;
                        break;
                      case PersonalDetailsValidator.MOBILE_INVALID_ERROR:
                        image = Image.asset(AssetConstants.ic_wrong);
                        singupSigninArguments.errorText =
                            S.of(context).invalid_mobile_number_error;
                        break;
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),
//                  Padding(
//                    padding: const EdgeInsets.only(top: 10.0),
//                    child: Text(
//                      S.of(context).mobile_number_title.toUpperCase(),
//                      style: TextStyle(
//                          fontSize: 12,
//                          color: Colors.grey[500],
//                          letterSpacing: 1),
//                    ),
//                  ),
                      Stack(
                        children: <Widget>[
                          Theme(
                              data: ThemeData(
                                  primaryColor: Colors.black,
                                  accentColor: Colors.black,
                                  hintColor: Colors.black),
                              child: Container(
                                width: getScreenWidth(context) - 40,
                                child: TextField(
                                  controller:
                                  singupSigninArguments.textEditingController,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2),
                                  autofocus: true,
                                  focusNode: singupSigninArguments.focusNode,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (value) {
                                    //onClick();
                                    widget.singupSigninArguments.onNextPressed();
                                  },
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  onChanged: (value) {
                                    singupSigninArguments.singupSigninBloc
                                        .changeMobile(value);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 5.0),
                                    border: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey[500]),
                                    ),
                                    labelText: S
                                        .of(context)
                                        .mobile_number_title
                                        .toUpperCase(),
                                    labelStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: 1.0),
                                    errorText: singupSigninArguments.errorText,
                                    errorStyle: TextStyle(color: Colors.red),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey[500]),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstants
                                              .policy_type_gradient_color2),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                              right: 0,
                              top: 15,
                              child: SizedBox(height: 25, width: 25, child: image))
                          //})
                        ],
                      )
                    ],
                  );
                })
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
        )
      ],
    );
  }

  Widget signInButton(String title) {
    return Center(
      child: FlatButton(
        onPressed: () {},
        child: Text(
          "$title",
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget linkPolicyButton(String title) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: Colors.black,
      onPressed: () {
        //widget.onStatusChange(ScreenStatus.welcome_screen);
        Navigator.of(context).pushNamed(SignupSigninScreen.ROUTE_NAME,
            arguments: SignupSigninScreenStatus.choose_policy_type_screen);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100 / 2),
      ),
      textColor: Colors.white,
      highlightColor: Colors.grey[800],
      highlightElevation: 5.0,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.0),
      ),
    );
  }
}
