import 'package:sbig_app/src/controllers/blocs/singup_signin/signup_signin_bloc.dart';
import 'package:sbig_app/src/ui/widgets/application/policy_number_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_widget.dart';
import 'package:sbig_app/src/ui/widgets/singup_signin/policy_details_calender_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';

class EnterPolicyDetailsWidget extends StatefulWidget {

  SingupSigninArguments policyNumberArguments;

  EnterPolicyDetailsWidget(this.policyNumberArguments);

  @override
  _EnterPolicyDetailsWidgetState createState() =>
      _EnterPolicyDetailsWidgetState();
}

class _EnterPolicyDetailsWidgetState extends State<EnterPolicyDetailsWidget>
    with CommonWidget {

  SingupSigninArguments policyNumberArguments;
  int navigationID;

  @override
  void initState() {
    policyNumberArguments = widget.policyNumberArguments;
    navigationID = policyNumberArguments.selectedPolicyType.navigateId ?? 1;
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
              height: 25,
            ),
            PolicyNumberWidget(policyNumberArguments),
            SizedBox(
              height: 30,
            ),
            StreamBuilder(
                stream: policyNumberArguments.singupSigninBloc.policyTypeStream,
                builder: (context, snapshot) {
                  return PolicyDetailsCalenderWidget(policyNumberArguments.singupSigninBloc, (date){
                    String dob = CommonUtil.instance.convertTo_dd_MM_yyyy(date);
                    policyNumberArguments.singupSigninBloc.changeDob(dob);
                  }, dob: policyNumberArguments.singupSigninBloc.dob, selectedPolicyModel: policyNumberArguments.selectedPolicyType,);
                }
            ),
            StreamBuilder<String>(
                stream: policyNumberArguments.singupSigninBloc.dobStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && policyNumberArguments.onSubmit) {
                    String data = snapshot.data.toString();
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        (data == null || data.isEmpty) ? (navigationID == 1 ? S.of(context).enter_dob : S.of(context).enter_policy_start_date) : "",
                        textAlign: TextAlign.center,
                        style: (TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: StringConstants.EFFRA_LIGHT)),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                    );
                  }
                }),
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
        )
      ],
    );
  }

  Widget signInButton(String title){
    return Center(
      child: FlatButton(
        onPressed: () {

        },
        child: Text(
          "$title", style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
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

