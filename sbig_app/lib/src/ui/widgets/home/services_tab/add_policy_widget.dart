import 'package:sbig_app/src/controllers/blocs/singup_signin/singup_signin_api_provider.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_types_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/onboarding/link_register_policy_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class AddPolicyWidget extends StatefulWidgetBase {

  @override
  _AddPolicyWidgetState createState() => _AddPolicyWidgetState();
}

class _AddPolicyWidgetState extends State<AddPolicyWidget> with CommonWidget{
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _addButton(),
        SizedBox(
          width: 10,
        ),
        _linkPoliciesText(S.of(context).add_more_policies),
      ],
    );
  }

  _addButton() {
    return InkResponse(
      onTap: (){
        _getPolicyDetails();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  _linkPoliciesText(String text) {
    return Text(
      S.of(context).add_more_policies,
      style: TextStyle(fontSize: 12),
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
              arguments: LinkRegisterPolicyScreenArguments(SignupSigninScreenStatus.choose_policy_type_screen, policyTypesResModel: response, from: StatefulWidgetBase.FROM_HOME_SCREEN));
        }
      }else {
        handleApiError(
            context, 1, onRetry, response.apiErrorModel.statusCode);
      }
    });
  }
}
