import 'package:sbig_app/src/controllers/blocs/singup_signin/singup_signin_api_provider.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_types_model.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart'
    as prefix0;
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';

class LinkRegisterPolicyScreen extends StatefulWidget {
  static const ROUTE_NAME = "/onboarding/link_register_policyScreen";

  Function(WelcomeScreenStatus) onStatusChange;

  LinkRegisterPolicyScreen({this.onStatusChange});

  @override
  _LinkRegisterPolicyScreenState createState() =>
      _LinkRegisterPolicyScreenState(this.onStatusChange);
}

enum Status {
  none,
  yes_selected,
  no_selected,
}

class _LinkRegisterPolicyScreenState extends State<LinkRegisterPolicyScreen>
    with CommonWidget {
  Function(WelcomeScreenStatus) onStatusChange;

  _LinkRegisterPolicyScreenState(this.onStatusChange);

  @override
  Widget build(BuildContext context) {
    double height = ScreenUtil.getInstance(context).screenHeightDp / 2;
    double width = ScreenUtil.getInstance(context).screenWidthDp / 2 - 50 - 20;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Text(
            S.of(context).please_title + ",",
            style: TextStyle(
                fontFamily: StringConstants.EFFRA_LIGHT,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            S.of(context).link_policy_request_message,
            style: TextStyle(
                fontFamily: StringConstants.EFFRA_LIGHT,
                fontSize: 16.0,
                color: Colors.grey.shade800),
          ),
          SizedBox(
            height: 20,
          ),
          linkPolicyButton(S.of(context).link_policy_title),
          signInButton(S.of(context).sign_in)
        ],
      ),
    );
  }

  Widget signInButton(String title) {
    return Center(
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SignupSigninScreen.ROUTE_NAME,
              arguments: LinkRegisterPolicyScreenArguments(SignupSigninScreenStatus.signin));
        },
        child: Text(
          "${title.toUpperCase()}",
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
        _getPolicyDetails();
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

  _getPolicyDetails() {

    onRetry(int from){
      _getPolicyDetails();
    }

    showLoaderDialog(context);
    SignupSigninApiProvider.getInstance().getPolicyTypes().then((response) {
      hideLoaderDialog(context);
      if (response.apiErrorModel == null) {
        //Error check in data
        bool isError = null == response.data || null == response.data.body;
        if(!isError){
          for(PolicyTypeBody item in response.data.body){
            isError = null == item.jsonCondition;
            break;
          }
        }
        if(isError){
          debugPrint("Invalid Policy Types response");
          handleApiError(
              context, 1, onRetry, 400);
        }else{
          Navigator.of(context).pushNamed(SignupSigninScreen.ROUTE_NAME,
              arguments: LinkRegisterPolicyScreenArguments(SignupSigninScreenStatus.choose_policy_type_screen, policyTypesResModel: response));
        }
      }else {
        handleApiError(
            context, 1, onRetry, response.apiErrorModel.statusCode);
      }
    });
  }
}

class LinkRegisterPolicyScreenArguments {
  SignupSigninScreenStatus screenStatus;
  PolicyTypesResModel policyTypesResModel;
  int from = -1;

  LinkRegisterPolicyScreenArguments(this.screenStatus,
  {this.policyTypesResModel, this.from});


}
