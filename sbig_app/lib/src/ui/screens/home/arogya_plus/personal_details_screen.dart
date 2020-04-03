import 'dart:core';

import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/cover_member/cover_member_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/lead_creation_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_validator.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/cover_member_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/city_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/product_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_city_product_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/policy_cover_member_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/page_indicator_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class PersonalDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/personal_details_screen";

  final PersonalDetailsArguments arguments;

  PersonalDetailsScreen(this.arguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: PersonalDetailsScreenWidget(arguments),
      bloc: PersonalDetailsBloc(),
    );
  }
}

class PersonalDetailsScreenWidget extends StatefulWidget {
  final PersonalDetailsArguments arguments;

  PersonalDetailsScreenWidget(this.arguments);

  @override
  _PersonalDetailsScreenWidgetState createState() =>
      _PersonalDetailsScreenWidgetState();
}

class _PersonalDetailsScreenWidgetState
    extends State<PersonalDetailsScreenWidget> with CommonWidget {
  bool onMobileSubmitted = false, onEmailSubmitted = false;
  FocusNode _mobileFocusNode, _emailFocusNode;
  String emailErrorString, mobileErrorString;
  bool isAllPagesLoaded = false;
  TextEditingController _mobileController, _emailController;
  bool _apiCall = false, isLoading = false;

  List<CityList> cityList;
  List<ProductList> productList;

  PersonalDetailsBloc _personalDetailsBloc;
  double _screenWidth;

  static const isFromToolbarBack = 1;
  static const bottomNavigationBarBack = 2;

  bool isMobileView = true;

  int _currentIndex = 0;
  bool isInTransition = false;

  List<StreamBuilder> pages;
  bool isBackPressed = false;

  PageController _pageController;
  PageIndicatorController _pageIndicatorController = PageIndicatorController();

  List<PolicyCoverMemberModel> policyCoverMemberModelList = [];

  @override
  void initState() {
    _personalDetailsBloc = SbiBlocProvider.of<PersonalDetailsBloc>(context);
    pages = [_mobileWidget(), _emailWidget()];
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _mobileFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _screenWidth = ScreenUtil.getInstance(context).screenWidthDp;
    if (!isBackPressed) {
      autoRedirect();
    }
    super.didChangeDependencies();
  }

  Future<bool> _onBackPressed(int from) {
    setState(() {
      isBackPressed = true;
    });
    if (_currentIndex == 0) {
      if (from == isFromToolbarBack) {
        Navigator.pop(context);
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    } else {
      Future.delayed(Duration(milliseconds: 10), () {
        _pageController.previousPage(
            duration: Duration(milliseconds: 100), curve: Curves.decelerate);
        Future.delayed(Duration(milliseconds: 10), () {
          try {
            FocusScope.of(context).requestFocus(_mobileFocusNode);
          } catch (e) {}
        });
      });
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _onBackPressed(bottomNavigationBarBack);
      },
      child: Scaffold(
        backgroundColor: ColorConstants.personal_details_bg_color,
        appBar: getAppBar(
            context,
            _getTitle(),
            onBackPressed: _onBackPressed,
            isFrom: isFromToolbarBack),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[_mobileWidget(), _emailWidget()],
                  onPageChanged: (currPage) {
                    this._currentIndex = currPage;
                    _pageIndicatorController.notifyPageChange(_currentIndex);
                  },
                ),
              ),
              if (isAllPagesLoaded) _showSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  _getTitle() {
    switch (widget.arguments.isFrom) {
      case StringConstants.FROM_CLAIM_INTIMATION:
        return S.of(context).claim_intimation_title.toUpperCase();
      default:
        return S.of(context).personal_details_title.toUpperCase();
    }
  }

  _mobileWidget() {
    return StreamBuilder<Object>(
        stream: _personalDetailsBloc.mobileStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          mobileErrorString = null;
          bool _onSubmit = (onMobileSubmitted);
          if (isError) {
            switch (snapshot.error) {
              case PersonalDetailsValidator.MOBILE_EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                mobileErrorString =
                    _onSubmit ? S.of(context).mobile_number_empty_error : null;
                break;
              case PersonalDetailsValidator.MOBILE_LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                mobileErrorString = _onSubmit
                    ? S.of(context).invalid_mobile_number_error
                    : null;
                break;
              case PersonalDetailsValidator.MOBILE_INVALID_ERROR:
                image = Image.asset(AssetConstants.ic_wrong);
                mobileErrorString = S.of(context).invalid_mobile_number_error;
                break;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  S.of(context).mobile_number_title.toUpperCase(),
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[800], letterSpacing: 1),
                ),
              ),
              Stack(
                children: <Widget>[
                  Theme(
                      data: ThemeData(
                          primaryColor: Colors.black,
                          accentColor: Colors.black,
                          hintColor: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          width: _screenWidth - 40,
                          child: TextField(
                            focusNode: _mobileFocusNode,
                            controller: _mobileController,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2),
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {
                              onClick();
                            },
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (value) {
                              _personalDetailsBloc.changeMobile(value);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              errorText: mobileErrorString,
                              errorStyle: TextStyle(color: ColorConstants.shiraz),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ColorConstants.shiraz),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants
                                        .fuchsia_pink),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      right: 20,
                      top: 10,
                      child: SizedBox(height: 25, width: 25, child: image))
                  //})
                ],
              )
            ],
          );
        });
  }

  _emailWidget() {
    return StreamBuilder<Object>(
        stream: _personalDetailsBloc.emailStream,
        builder: (context, snapshot) {
          //Image image = Image.asset(AssetConstants.ic_correct);
          Image image;
          bool isError = snapshot.hasError;
          emailErrorString = null;
          bool _onSubmit = (onEmailSubmitted && _currentIndex == 1);
          if (isError) {
            switch (snapshot.error) {
              case PersonalDetailsValidator.EMAIL_EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                emailErrorString =
                    _onSubmit ? S.of(context).email_empty_error : null;
                break;
              case PersonalDetailsValidator.EMAIL_INVALID_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                emailErrorString =
                    _onSubmit ? S.of(context).invalid_email_error : null;
                break;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Text(
                  S.of(context).email_title.toUpperCase(),
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[800], letterSpacing: 1),
                ),
              ),
              Stack(
                children: <Widget>[
                  Theme(
                      data: ThemeData(
                          buttonTheme:ButtonThemeData(minWidth: 15),
                          primaryColor: Colors.black,
                          accentColor: Colors.black,
                          hintColor: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Container(
                          width: _screenWidth - 40,
                          child: TextField(
                            autocorrect: false,
                            enableInteractiveSelection: false,
                            focusNode: _emailFocusNode,
                            controller: _emailController,

                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5),
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {
                              onClick();
                            },
                            inputFormatters: [
                              emailTextFormatter,
                             // LengthLimitingTextInputFormatter(254),
                              LengthLimitingTextInputFormatter(100),
                            ],
                            onChanged: (value) {
                              _personalDetailsBloc.changeEmail(value);
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 5.0, right: 30.0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              errorText: emailErrorString,
                              errorStyle: TextStyle(color: ColorConstants.shiraz),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ColorConstants.shiraz),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants
                                        .fuchsia_pink),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      right: 0,
                      top: 10,
                      child: SizedBox(height: 25, width: 25, child: image))
                  //})
                ],
              )
            ],
          );
        });
  }

  autoRedirect() {
    _mobileController.addListener(() {
      if (_mobileController.text.length == 10 && !isAllPagesLoaded) {
        if (int.parse(_mobileController.text.substring(0, 1)) >= 6) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (!isInTransition) {
              isInTransition = true;
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
              setState(() {
                isAllPagesLoaded = true;
              });
              onMobileSubmitted = false;
              _emailController.text = _personalDetailsBloc.email;
              Future.delayed(Duration(milliseconds: 200), () {
                try {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                  isInTransition = false;
                } catch (e) {}
              });
            }
          });
        }
      }
    });
  }

  _retryIdentifier(int identifier) {
    onClick();
  }

  onClick() {
    String mobileNumber = _personalDetailsBloc.mobile;
    String emailAddress = _personalDetailsBloc.email;
    if (_currentIndex == 0) {
      onMobileSubmitted = true;
      _personalDetailsBloc.changeMobile(mobileNumber);
      Future.delayed(Duration(milliseconds: 100), () {
        if (mobileErrorString == null) {
          onEmailSubmitted = false;
          Future.delayed(Duration(milliseconds: 100), () {
            _pageController.nextPage(
                duration: Duration(milliseconds: 100),
                curve: Curves.decelerate);
            setState(() {
              isAllPagesLoaded = true;
              isBackPressed = false;
            });
            onMobileSubmitted = false;
            _emailController.text = emailAddress;
            Future.delayed(Duration(milliseconds: 300), () {
              try {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              } catch (e) {}
            });
          });
        }
      });
    } else {
      onEmailSubmitted = true;
      _personalDetailsBloc.changeEmail(emailAddress);
      Future.delayed(Duration(milliseconds: 100), () {
        if (emailErrorString == null) {
          onEmailSubmitted = false;
          try {
            FocusScope.of(context).unfocus();
          } catch (e) {}
          _navigate(emailAddress, mobileNumber, widget.arguments.isFrom);
        }
      });
    }
  }

  Widget _showSubmitButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.personal_details_bg_color,
    );
  }

  _makeCityApiCall() async {
    retryIdentifier(int identifier) {
      _makeCityApiCall();
    }

    showLoaderDialog(context);
    final response = await _personalDetailsBloc.getCity();
    if (null != response.apiErrorModel) {
      hideLoaderDialog(context);
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      //hide
      cityList = response.data?.cityList ?? List<CityList>();
      _makeProductApiCall();
    }
  }

  _makeProductApiCall() async {
    retryIdentifier(int identifier) {
      _makeProductApiCall();
    }

    final response = await _personalDetailsBloc.getProduct();
    hideLoaderDialog(context);

    if (null != response.apiErrorModel) {
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      productList = response.data?.productlist ?? List<ProductList>();
      ClaimIntimationRequestModel responseModel =
          widget.arguments.claimIntimationRequestModel;
      responseModel.phone = _mobileController.text;
      responseModel.email = _emailController.text;
      Navigator.of(context).pushNamed(ClaimCityProductScreen.ROUTE_NAME,
          arguments: ClaimIntimationCitiesArguments(
              responseModel, cityList, productList));
    }
  }

  _makeCoverMemberApiCall(int isFrom, {int policyType}) async {
    retryIdentifier(int identifier) {
      _makeCoverMemberApiCall(isFrom, policyType: policyType);
    }

    showLoaderDialog(context);
    final response = await CoverMemberApiProvider.getInstance()
        .getCoverMembers(isFrom, policyType: policyType);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      CoverMemberResModel responseModel = response;
      Navigator.of(context).pushNamed(PolicyCoverMemberScreen.ROUTE_NAME,
          arguments: PolicyCoverMemberArguments(
              PersonalDetails(_mobileController.text, _emailController.text,
                  widget.arguments.isFrom),
              coverMemberResModel: responseModel));
    }
  }

  @override
  void dispose() {
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();
    _personalDetailsBloc.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _navigate(String emailAddress, String mobileNumber, int isFrom) {
    switch (isFrom) {
      case StringConstants.FROM_AROGYA_PLUS:
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (!isConnected) {
            handleApiError(context, 0, _retryIdentifier,
                ApiResponseListenerDio.NO_INTERNET_CONNECTION);
          } else {
            LeadCreationApiProvider.getInstance()
                .callLeadCreationApi(emailAddress, mobileNumber, "Arogya Plus");
            Navigator.of(context).pushNamed(PolicyTypeScreen.ROUTE_NAME,
                arguments: PersonalDetails(mobileNumber, emailAddress,
                    StringConstants.FROM_AROGYA_PLUS));
          }
        });
        break;
      case StringConstants.FROM_CRITICAL_ILLNESS:
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (!isConnected) {
            handleApiError(context, 0, _retryIdentifier,
                ApiResponseListenerDio.NO_INTERNET_CONNECTION);
          } else {
            LeadCreationApiProvider.getInstance().callLeadCreationApi(
                emailAddress, mobileNumber, "Critical Illness");
            _makeCoverMemberApiCall(StringConstants.FROM_CRITICAL_ILLNESS);
          }
        });
        break;
      case StringConstants.FROM_CLAIM_INTIMATION:
        _makeCityApiCall();
        break;
      case StringConstants.FROM_AROGYA_PREMIER:
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (!isConnected) {
            handleApiError(context, 0, _retryIdentifier,
                ApiResponseListenerDio.NO_INTERNET_CONNECTION);
          } else {
            LeadCreationApiProvider.getInstance().callLeadCreationApi(emailAddress, mobileNumber, "Arogya Premier");
            Navigator.of(context).pushNamed(PolicyTypeScreen.ROUTE_NAME, arguments: PersonalDetails(mobileNumber, emailAddress, isFrom));
          }
        });
        break;
      case StringConstants.FROM_AROGYA_TOP_UP:
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (!isConnected) {
            handleApiError(context, 0, _retryIdentifier,
                ApiResponseListenerDio.NO_INTERNET_CONNECTION);
          } else {
            LeadCreationApiProvider.getInstance().callLeadCreationApi(emailAddress, mobileNumber, "Arogya Top Up");
            Navigator.of(context).pushNamed(PolicyTypeScreen.ROUTE_NAME, arguments: PersonalDetails(mobileNumber, emailAddress, isFrom));
          }
        });
        break;
    }
  }
}

class PersonalDetails {
  String mobile;
  String email;
  int isFrom;

  PersonalDetails(this.mobile, this.email, this.isFrom);
}

class PersonalDetailsArguments {
  int isFrom;
  ClaimIntimationRequestModel claimIntimationRequestModel;

  PersonalDetailsArguments(this.isFrom, this.claimIntimationRequestModel);
}
