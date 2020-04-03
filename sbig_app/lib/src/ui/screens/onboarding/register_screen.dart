import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'link_register_policy_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const ROUTE_NAME = "/onboarding/register_screen";

  Function(WelcomeScreenStatus) onStatusChange;

  RegisterScreen({this.onStatusChange});

  @override
  _RegisterScreenState createState() =>
      _RegisterScreenState(this.onStatusChange);
}

enum Status {
  none,
  yes_selected,
  no_selected,
}

class _RegisterScreenState extends State<RegisterScreen>
    with CommonWidget {
  Function(WelcomeScreenStatus) onStatusChange;

  _RegisterScreenState(this.onStatusChange);

  @override
  Widget build(BuildContext context) {
    double height = ScreenUtil.getInstance(context).screenHeightDp / 2;
    double width = ScreenUtil.getInstance(context).screenWidthDp / 2 - 50 - 20;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Text(
            S.of(context).register_welcome_message,
            style: TextStyle(
                fontFamily: StringConstants.EFFRA_LIGHT,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(
            height: 5,
          ),
          //TO MATCH WELCOME SCREEN CONTENT
          SizedBox(
            height: 16,
          ),
//        Text(
//          S.of(context).link_policy_request_message,
//          style: TextStyle(
//              fontFamily: StringConstants.SWISS_LIGHT,
//              fontSize: 16.0,
//              color: Colors.grey.shade800),
//        ),
          SizedBox(
            height: 20,
          ),
          registerButton(S.of(context).register_title),
          SizedBox(
            width: 20,
          ),
          signInButton(S.of(context).sign_in)
        ],
      ),
    );
  }

  Widget signInButton(String title){
    return Center(
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SignupSigninScreen.ROUTE_NAME,
              arguments: LinkRegisterPolicyScreenArguments(SignupSigninScreenStatus.signin));
        },
        child: Text(
          "$title", style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget registerButton(String title) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: Colors.black,
      onPressed: () {
        //widget.onStatusChange(WelcomeScreenStatus.welcome_screen);
        Navigator.of(context).pushNamed(SignupSigninScreen.ROUTE_NAME,
            arguments: LinkRegisterPolicyScreenArguments(SignupSigninScreenStatus.register));
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