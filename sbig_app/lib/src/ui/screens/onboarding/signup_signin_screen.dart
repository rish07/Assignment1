import 'dart:async';

import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/singup_signin/signup_signin_bloc.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/get_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_type_list_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_types_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/register_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/validate_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/verify_otp_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/enter_policy_details_widget.dart';
import 'package:sbig_app/src/ui/screens/onboarding/link_register_policy_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/singup_signin/mobile_number_widget.dart';
import 'package:sbig_app/src/ui/widgets/singup_signin/user_name_widget.dart';
import 'package:sbig_app/src/ui/widgets/singup_signin/verify_otp_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/page_indicator_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
import 'choose_policy_type_screen.dart';

class SignupSigninScreen extends StatelessWidget {
  static const ROUTE_NAME = "/onboarding/signup_signin_screen";

  LinkRegisterPolicyScreenArguments linkRegisterPolicyScreenArguments;

  SignupSigninScreen(this.linkRegisterPolicyScreenArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: SignupSigninScreenWidget(linkRegisterPolicyScreenArguments),
      bloc: SingupSigninBloc(),
    );
  }
}

class SignupSigninScreenWidget extends StatefulWidget {
  LinkRegisterPolicyScreenArguments linkRegisterPolicyScreenArguments;

  SignupSigninScreenWidget(this.linkRegisterPolicyScreenArguments);

  @override
  _SignupSigninScreenWidgetState createState() =>
      _SignupSigninScreenWidgetState();
}

enum SignupSigninScreenStatus {
  signin,
  register,
  choose_policy_type_screen,
  enter_policy_details_screen,
  user_name_screen,
  user_mobile_no_screen,
  user_otp_screen
}

class _SignupSigninScreenWidgetState extends State<SignupSigninScreenWidget>
    with CommonWidget {
  SignupSigninScreenStatus screenStatus, actualStatus;
  PageController _pageController;
  PageIndicatorController _pageIndicatorController = PageIndicatorController();
  int _currentIndex = 0;
  List<Widget> pages;
  List<SingupSigninArguments> argumentsList;

  TextEditingController policyTextController,
      mobileNoTextController,
      userNameTextController;

  Timer otpTimer;

  SingupSigninBloc _bloc;
  String screenImg = AssetConstants.ic_writing;
  String headerTitle;
  SingupSigninArguments choosePolicyTypeArguments,
      userNameArguments,
      policyNumberArguments,
      mobileNumberArguments,
      verifyOTPArguments;
  FocusNode policyNoFocusNode, mobileNoFocusNode, userNameFocusNode, otpFocusNode;

  bool isNextButtonEnable = false;
  PolicyTypesListModel selectedPolicyTypeModel;
  int from = -1;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  onChoosePolicyType(PolicyTypesListModel selectedPolicyTypeModel) {
    choosePolicyTypeArguments.selectedPolicyType = selectedPolicyTypeModel;
    policyNumberArguments.selectedPolicyType = selectedPolicyTypeModel;
    //RESET DOB
    if (this.selectedPolicyTypeModel != null) {
      if (this
              .selectedPolicyTypeModel
              .productCode
              .compareTo(selectedPolicyTypeModel.productCode) !=
          0) {
        _bloc.changeDob("");
        _bloc.changePolicyType(true);
      }
    }
    this.selectedPolicyTypeModel = selectedPolicyTypeModel;

    setState(() {
      isNextButtonEnable = true;
    });
  }

  onOTPCompleted(bool isCompleted) {
    setState(() {
      isNextButtonEnable = isCompleted;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      if(screenStatus == SignupSigninScreenStatus.user_otp_screen){
        //Enable Next button
        if(verifyOTPArguments.otpTimer != null) {
          verifyOTPArguments.otpTimer.cancel();
          _bloc.changeTimer("00:00");
        }
        setState(() {
          isNextButtonEnable = true;
        });
      }

      SignupSigninScreenStatus previousStatus = argumentsList[_currentIndex - 1].screenStatus;

      if(previousStatus == SignupSigninScreenStatus.choose_policy_type_screen){
        FocusScope.of(context).unfocus();
      }else if(previousStatus == SignupSigninScreenStatus.enter_policy_details_screen){
        policyNoFocusNode.requestFocus();
      }else if(previousStatus == SignupSigninScreenStatus.user_mobile_no_screen){
        mobileNoFocusNode.requestFocus();
      }else if(previousStatus == SignupSigninScreenStatus.user_name_screen){
        userNameFocusNode.requestFocus();
      }

      //Skip OTP screen
      if(screenStatus == SignupSigninScreenStatus.user_name_screen && previousStatus == SignupSigninScreenStatus.user_otp_screen){
        _currentIndex = _currentIndex - 1;
      }

      _pageController.animateToPage(_currentIndex = _currentIndex - 1,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      this.screenStatus = argumentsList[_currentIndex].screenStatus;
      return Future.value(false);
    }
    return Future.value(true);
  }

  _onBackPressed(int from) {
    _onWillPop().then((isPop) {
      if (isPop) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void initState() {
    _bloc = SbiBlocProvider.of<SingupSigninBloc>(context);
    policyTextController = TextEditingController();
    mobileNoTextController = TextEditingController();
    userNameTextController = TextEditingController();

    policyNoFocusNode = FocusNode();
    mobileNoFocusNode = FocusNode();
    userNameFocusNode = FocusNode();
    otpFocusNode = FocusNode();

    screenStatus = widget.linkRegisterPolicyScreenArguments.screenStatus;
    actualStatus = screenStatus;
    from = widget.linkRegisterPolicyScreenArguments.from;

    _pageController = PageController(initialPage: 0);
    choosePolicyTypeArguments = SingupSigninArguments(
        policyTypesResModel:
            widget.linkRegisterPolicyScreenArguments.policyTypesResModel,
        onChoosePolicyType: onChoosePolicyType,
        selectedPolicyType: selectedPolicyTypeModel,
        screenStatus: SignupSigninScreenStatus.choose_policy_type_screen,
        asset: AssetConstants.ic_writing);
    policyNumberArguments = SingupSigninArguments(
        errorText: null,
        onSubmit: false,
        singupSigninBloc: _bloc,
        textEditingController: policyTextController,
        screenStatus: SignupSigninScreenStatus.enter_policy_details_screen,
        asset: AssetConstants.ic_medicine_kit, focusNode: policyNoFocusNode);
    mobileNumberArguments = SingupSigninArguments(
        errorText: null,
        onSubmit: false,
        singupSigninBloc: _bloc,
        textEditingController: mobileNoTextController,
        screenStatus: SignupSigninScreenStatus.user_mobile_no_screen,
        asset: AssetConstants.ic_phone_white, focusNode: mobileNoFocusNode, onNextPressed: onClick);
    userNameArguments = SingupSigninArguments(
        errorText: null,
        onSubmit: false,
        singupSigninBloc: _bloc,
        textEditingController: userNameTextController,
        screenStatus: SignupSigninScreenStatus.user_name_screen,
        asset: AssetConstants.ic_user, focusNode: userNameFocusNode, onNextPressed: onClick);
    verifyOTPArguments = SingupSigninArguments(
        errorText: null,
        onSubmit: false,
        singupSigninBloc: _bloc,
        onResendOtp: _getOTP,
        onOTPCompleted: onOTPCompleted,
        screenStatus: SignupSigninScreenStatus.user_otp_screen,
        asset: AssetConstants.ic_check,
        onBackPressed: _onBackPressed, focusNode: otpFocusNode, otpTimer: otpTimer);

    if(from == StatefulWidgetBase.FROM_HOME_SCREEN){
      pages = [
        ChoosePolicyTypeScreen(choosePolicyTypeArguments),
        EnterPolicyDetailsWidget(policyNumberArguments),
      ];
    }else {
      pages = [
        ChoosePolicyTypeScreen(choosePolicyTypeArguments),
        EnterPolicyDetailsWidget(policyNumberArguments),
        UserNameWidget(userNameArguments),
        MobileNumberWidget(mobileNumberArguments),
        VerifyOTPWidget(verifyOTPArguments)
      ];
    }

    argumentsList = [
      choosePolicyTypeArguments,
      policyNumberArguments,
      userNameArguments,
      mobileNumberArguments,
      verifyOTPArguments
    ];

    switch (screenStatus) {
      case SignupSigninScreenStatus.signin:
      case SignupSigninScreenStatus.register:
        pages = [
          MobileNumberWidget(mobileNumberArguments),
          VerifyOTPWidget(verifyOTPArguments),
          UserNameWidget(userNameArguments)
        ];
        isNextButtonEnable = true;
        screenStatus = SignupSigninScreenStatus.user_mobile_no_screen;
        screenImg = AssetConstants.ic_phone_white;
        argumentsList = [
          mobileNumberArguments,
          verifyOTPArguments,
          userNameArguments
        ];
        break;
      case SignupSigninScreenStatus.choose_policy_type_screen:
      case SignupSigninScreenStatus.enter_policy_details_screen:
      case SignupSigninScreenStatus.user_name_screen:
      case SignupSigninScreenStatus.user_mobile_no_screen:
      case SignupSigninScreenStatus.user_otp_screen:
        break;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    choosePolicyTypeArguments.headerTitle = S.of(context).enter_policy_details;
    policyNumberArguments.headerTitle = S.of(context).enter_policy_details;
    mobileNumberArguments.headerTitle = S.of(context).enter_mobile_no;
    userNameArguments.headerTitle = S.of(context).singup;
    verifyOTPArguments.headerTitle = S.of(context).enter_otp;
    if (screenStatus == SignupSigninScreenStatus.user_mobile_no_screen) {
      headerTitle = S.of(context).enter_mobile_no;
    } else {
      headerTitle = S.of(context).enter_policy_details;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _key,
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(context, "",
            isActionRequired: actualStatus ==
                SignupSigninScreenStatus.choose_policy_type_screen,
            actionWidget: from != StatefulWidgetBase.FROM_HOME_SCREEN ? _dotIndicatorWidget() : null,
            backActionRequired: true,
            onBackPressed: _onBackPressed),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  //color: Colors.yellow,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 10, bottom: 25),
                    child: Text(
                      headerTitle,
                      style: TextStyle(
                          fontFamily: StringConstants.EFFRA_LIGHT,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),

                Expanded(
                    child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 15,
                            //offset: Offset(0, -5),
                            color: Colors.black26,
                            spreadRadius: 5)
                      ],
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(40.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 30.0),
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: pages,
                      onPageChanged: (currPage) {
                        this._currentIndex = currPage;
                        _pageIndicatorController
                            .notifyPageChange(_currentIndex);
                        setState(() {
                          screenImg = argumentsList[_currentIndex].asset;
                          headerTitle =
                              argumentsList[_currentIndex].headerTitle;
                        });
                        if(screenStatus == SignupSigninScreenStatus.enter_policy_details_screen){
                          policyNoFocusNode.requestFocus();
                        }else if(screenStatus == SignupSigninScreenStatus.user_mobile_no_screen){
                          mobileNoFocusNode.requestFocus();
                        }else if(screenStatus == SignupSigninScreenStatus.user_name_screen){
                          userNameFocusNode.requestFocus();
                        }else if(screenStatus == SignupSigninScreenStatus.user_otp_screen){
                          otpFocusNode.requestFocus();
                        }
                      },
                    ),
                  ),
                ))
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 40),
                child: getScreenImage(),
              ),
            ),
            SafeArea(child: _showNextButton())
          ],
        ),
      ),
    );
  }

  onClick() {
    switch (screenStatus) {
      case SignupSigninScreenStatus.signin:
      case SignupSigninScreenStatus.register:
      case SignupSigninScreenStatus.choose_policy_type_screen:
      //policyNumberArguments.selectedPolicyType =
      //    this.selectedPolicyTypeModel;
        _pageController.animateToPage(_currentIndex = 1,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        screenStatus = SignupSigninScreenStatus.enter_policy_details_screen;
        break;
      case SignupSigninScreenStatus.enter_policy_details_screen:
        String policyNumber = _bloc.policyNumber;
        //_bloc.changeOnSubmit(true);
        policyNumberArguments.onSubmit = true;
        _bloc.changePolicyNumber(policyNumber);

        Future.delayed(Duration(milliseconds: 200), () {
          if (policyNumberArguments.errorText == null) {
            String dob = _bloc.dob;
            _bloc.changeDob(dob);
            Future.delayed(Duration(milliseconds: 200), () {
              if (dob.isNotEmpty) {
                validatePolicyData();
              }
            });
          }
        });
        break;
      case SignupSigninScreenStatus.user_name_screen:
        String userName = _bloc.firstName;
        userNameArguments.onSubmit = true;
        _bloc.changeFirstName(userName);

        Future.delayed(Duration(milliseconds: 200), () {
          if (userNameArguments.errorText == null) {
            if (actualStatus == SignupSigninScreenStatus.signin ||
                actualStatus == SignupSigninScreenStatus.register) {
              _register();
            } else {
              _pageController.animateToPage(_currentIndex = 3,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
              screenStatus = SignupSigninScreenStatus.user_mobile_no_screen;
            }
          }
        });
        break;
      case SignupSigninScreenStatus.user_mobile_no_screen:
        String mobile = _bloc.mobile;
        mobileNumberArguments.onSubmit = true;
        _bloc.changeMobile(mobile);
        Future.delayed(Duration(milliseconds: 200), () {
          if (mobileNumberArguments.errorText == null) {
            _getOTP(false);
          }
        });
        break;
      case SignupSigninScreenStatus.user_otp_screen:
        _verifyOTP();
        break;
    }
  }

  Widget _showNextButton() {
    return EnableDisableButtonWidget(
      (isNextButtonEnable) ? onClick : null,
      S.of(context).next.toUpperCase(),
    );
  }

  _verifyOTP() {
    onRetry(int from) {
      _verifyOTP();
    }

    showLoaderDialog(context);
    _bloc
        .verifyOTP(VerifyOTPReqModel(_bloc.mobile, _bloc.otp).toJson())
        .then((response) async {
      hideLoaderDialog(context);
      if (response.apiErrorModel == null) {
        String toBeEncryptedString =
            "customerhash" + "${_bloc.mobile}${_bloc.otp}";
        String encryptedString =
            CommonUtil.instance.generateSha256Hexa(toBeEncryptedString);
        if (response.verifyHash.compareTo(encryptedString) == 0) {
          if (response.is_registered == true) {
            if (!TextUtils.isEmpty(response.token)) {
              await prefsHelper.setAlertShown(true);
              _redirectToHome(response.token, response.customer_name);
              return;
            } else {
              _key.currentState.showSnackBar(
                  SnackBar(content: Text("Invalid data. Please try again.")));
            }
          } else {
            if (actualStatus == SignupSigninScreenStatus.signin ||
                actualStatus == SignupSigninScreenStatus.register) {
              _pageController.animateToPage(_currentIndex = 2,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
              screenStatus = SignupSigninScreenStatus.user_name_screen;
            } else {
              _register();
            }
          }
        } else {
          _key.currentState.showSnackBar(SnackBar(
              content: Text("Something went wrong. Please try again.")));
        }
      } else {
        if (response.apiErrorModel.statusCode == 400) {
          _key.currentState.showSnackBar(
              SnackBar(content: Text(response.apiErrorModel.message ?? "")));
        } else {
          handleApiError(context, 1, onRetry, response.apiErrorModel.statusCode,
              message: response.apiErrorModel.message);
        }
      }
    });
  }

  _register() {
    onRetry(int from) {
      _register();
    }

    _bloc
        .register(
            RegisterReqModel(_bloc.firstName, _bloc.mobile, _bloc.otp).toJson())
        .then((response) async {
      if (response.apiErrorModel == null) {
        if (!TextUtils.isEmpty(response.token)) {
          _redirectToHome(response.token, response.customer_name);
          return;
        }
      } else {
        handleApiError(context, 1, onRetry, response.apiErrorModel.statusCode,
            message: response.apiErrorModel.message);
        return;
      }
    });
  }

  _redirectToHome(String token, String userName) async {
    FocusScope.of(context).unfocus();
    await prefsHelper.setToken(token);
    await prefsHelper.setUserName(userName);
    await prefsHelper.setUserIsLoggedIn(true);
    await prefsHelper.setMobileNo(_bloc.mobile);
    if(actualStatus == SignupSigninScreenStatus.choose_policy_type_screen){
      await prefsHelper.setAlertShown(true);
      await prefsHelper.setUserIsLinkedPolicy(true);
    }
    if(verifyOTPArguments.otpTimer != null) {
      verifyOTPArguments.otpTimer.cancel();
    }

    Navigator.pushReplacementNamed(
      context,
      HomeScreen.ROUTE_NAME,
    );
  }

  Future<bool> _getOTP(bool isFromResend) {
    onRetry(int from) {
      _getOTP(isFromResend);
    }

    _bloc.changeOtp("");
    showLoaderDialog(context);
    return _bloc
        .getLoginOTP(LoginRequestModel(_bloc.mobile).toJson())
        .then((response) {
      hideLoaderDialog(context);
      if (response.apiErrorModel == null) {
        setState(() {
          isNextButtonEnable = false;
        });
        if (actualStatus == SignupSigninScreenStatus.signin ||
            actualStatus == SignupSigninScreenStatus.register) {
          _currentIndex = 1;
        } else {
          _currentIndex = 4;
        }
        _pageController.animateToPage(_currentIndex,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        screenStatus = SignupSigninScreenStatus.user_otp_screen;
        if(!TextUtils.isEmpty(response.message)) {
          _key.currentState.showSnackBar(
              SnackBar(content: Text(response.message)));
        }
        return Future.value(true);
      } else {
        if (response.apiErrorModel.statusCode == 400) {
          _key.currentState.showSnackBar(
              SnackBar(content: Text(response.apiErrorModel.message ?? "")));
        } else {
          handleApiError(context, 1, onRetry, response.apiErrorModel.statusCode,
              message: response.apiErrorModel.message);
        }
      }
      return Future.value(false);
    });
  }

  validatePolicyData() {
    onRetry(int from) {
      validatePolicyData();
    }

    showLoaderDialog(context);
    ValidatePolicyDetailsReqModel validatePolicyDetailsReqModel =
        ValidatePolicyDetailsReqModel();
    validatePolicyDetailsReqModel.productCode =
        selectedPolicyTypeModel.productCode;
    validatePolicyDetailsReqModel.policyNumber = _bloc.policyNumber;
    if (selectedPolicyTypeModel.navigateId == 1) {
      validatePolicyDetailsReqModel.primaryInsuredDOB = _bloc.dob;
    } else {
      validatePolicyDetailsReqModel.startDate = _bloc.dob;
    }
    validatePolicyDetailsReqModel.policytype =
        selectedPolicyTypeModel.policyType;
    validatePolicyDetailsReqModel.policytypename =
        selectedPolicyTypeModel.policyTypeName;

    if(from == StatefulWidgetBase.FROM_HOME_SCREEN) {
      //DEVELOPMENT IS PENDING
      String data = 'customerrequesthash'+ prefsHelper.getMobileNo();
      validatePolicyDetailsReqModel.verifyHash = CommonUtil.instance.generateSha256Hexa(data);
    }

    _bloc
        .validatePolicyDetails(validatePolicyDetailsReqModel.toJson())
        .then((response) {
      hideLoaderDialog(context);
      if (response.apiErrorModel == null) {
        if(from == StatefulWidgetBase.FROM_HOME_SCREEN){
          prefsHelper.setAlertShown(true);
          prefsHelper.setIsReloadRequired(true);
//          _key.currentState.showSnackBar(
//              SnackBar(content: Text(response.message ?? "Congratulations! Your policy has been linked successfully")));
          Navigator.of(context).popUntil(ModalRoute.withName(
              HomeScreen.ROUTE_NAME),);
        }else {
          _pageController.animateToPage(_currentIndex = 2,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
          screenStatus = SignupSigninScreenStatus.user_name_screen;
        }
      } else {
        handleApiError(context, 1, onRetry, response.apiErrorModel.statusCode,
            message: response.apiErrorModel.statusCode == 400
                ? response.apiErrorModel.message
                : null, title: "Error");
      }
    });
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

  Widget registerButton(String title) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: Colors.black,
      onPressed: () {
        // widget.onStatusChange(ScreenStatus.welcome_screen);
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

  Widget getScreenImage() {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorConstants.policy_type_gradient_color1,
                  ColorConstants.policy_type_gradient_color2
                ])),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(width: 25, height: 25, child: Image.asset(screenImg)),
        ));
  }

  Widget _dotIndicatorWidget() {
    int length = pages.length;
    int index = 0;
    List<Widget> dotIndicatorWidgets = List();
    while (index < length) {
      Widget widget = Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (index == _currentIndex) ? ColorConstants.home_bg_gradient_color2 : Colors.grey.shade400
          ),
        ),
      );
      dotIndicatorWidgets.add(widget);
      index++;
    }

    Padding padding = Padding(
      padding: EdgeInsets.only(right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: dotIndicatorWidgets,
      ),
    );
    return padding;
  }

  @override
  void dispose() {
    policyTextController.dispose();
    mobileNoTextController.dispose();
    userNameTextController.dispose();
    policyNoFocusNode.dispose();
    mobileNoFocusNode.dispose();
    otpFocusNode.dispose();
    userNameFocusNode.dispose();
    super.dispose();
  }
}

class SingupSigninArguments {
  String errorText;
  bool onSubmit;
  SingupSigninBloc singupSigninBloc;
  bool isNextButtonEnable;
  PolicyTypesListModel selectedPolicyType;
  Future<bool> Function(bool) onResendOtp;
  Function(PolicyTypesListModel) onChoosePolicyType;
  PolicyTypesResModel policyTypesResModel;
  TextEditingController textEditingController;
  Function(bool) onOTPCompleted;
  SignupSigninScreenStatus screenStatus;
  String asset;
  String headerTitle;
  Function(int) onBackPressed;
  FocusNode focusNode;
  Function() onNextPressed;
  Timer otpTimer;

  SingupSigninArguments(
      {this.errorText,
      this.onSubmit,
      this.singupSigninBloc,
      this.isNextButtonEnable,
      this.selectedPolicyType,
      this.onResendOtp,
      this.onChoosePolicyType,
      this.policyTypesResModel,
      this.textEditingController,
      this.onOTPCompleted,
      this.screenStatus,
      this.asset,
      this.headerTitle,
      this.onBackPressed, this.focusNode, this.onNextPressed, this.otpTimer});
}
