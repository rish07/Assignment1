import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/mics/arogya_plus_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/home_tabs/home_bloc.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/policy_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/service_item.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/services_tab/add_policy_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/services_tab/policies_list_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/services_tab/service_options_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/services_tab/services_tab_error.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ServicesTabV1 extends StatelessWidget {
  HomeBloc homeBloc;
  GlobalKey<ScaffoldState> homeKey;
  Function(DocType, String) downloadPdf;

  ServicesTabV1(this.homeBloc, this.homeKey, this.downloadPdf);

  @override
  Widget build(BuildContext context) {
    return ServicesTabWidget(homeKey, downloadPdf, homeBloc);
  }
}

class ServicesTabWidget extends StatefulWidgetBase {
  GlobalKey<ScaffoldState> homeKey;
  Function(DocType, String) downloadPdf;
  HomeBloc homeBloc;

  ServicesTabWidget(this.homeKey, this.downloadPdf, this.homeBloc);

  @override
  _ServicesTabState createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTabWidget> with CommonWidget {
  ServiceModel networkHospitalServiceModel, claimIntimationServiceModel;

  bool isHavingPolicy = true;
  HomeBloc _bloc;
  bool isError = false;
  ErrorType errorType;

  @override
  void initState() {
    _bloc = widget.homeBloc;

    if (prefsHelper.isUserLoggedIn()) {
      if (_bloc.policiesData == null) {
        _getPolicyServicesData();
      }
    } else {
      isHavingPolicy = false;
    }
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(prefsHelper.isReloadRequired()){
      _bloc.policiesData = null;
      prefsHelper.setIsReloadRequired(false);
      print("IS RELOAD DATA CALLED");
      _getPolicyServicesData();
    }
    super.didChangeDependencies();
  }

  _getPolicyServicesData() {
      _bloc.getPolicyServiceDetails().then((response) {
        if (null != response.resultData) {
          if (response.apiErrorModel == null) {
            List<PolicyListItem> policiesList = response.resultData.policyList;
            if (policiesList.length > 0) {
              policiesList[0].apiHit = 1;
              _bloc.policiesData = policiesList;

              _bloc.changePolicies(policiesList);

              PolicyListItem policyListItem = policiesList[0];
              List<ServicesListItem> servicesList =
                  response.resultData.servicesList;
              _bloc.changeServices(servicesList);

              _bloc.changeCurrentPolicy(policyListItem);
            } else {
              _bloc.changePolicyListEmpty(true);
              setState(() {
                isHavingPolicy = false;
              });
            }
          }
        } else {
          if (response.apiErrorModel.statusCode ==
              ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
            errorType = ErrorType.INTERNET_ERROR;
          } else {
            errorType = ErrorType.SERVER_ERROR;
          }
          setState(() {
            isError = true;
          });
        }
      });
  }

  getErrorAlert() {
    onRetry(int from) {
      setState(() {
        isError = false;
      });
      _getPolicyServicesData();
    }

    bool isInternetError = errorType == ErrorType.INTERNET_ERROR;
    String title = isInternetError
        ? S.of(context).no_internet_dialog_title
        : S.of(context).oh_no_dialog_title;
    String message = isInternetError
        ? S.of(context).no_internet_dialog_message
        : S.of(context).oh_no_dialog_message;
    return ServicesTabError(
      imageAsset: isInternetError
          ? AssetConstants.ic_no_internet
          : AssetConstants.image_server_error_dialog,
      title: title,
      subTitle: message,
      retryIdentifier: 1,
      onRetryClick: onRetry,
      isInternerError: isInternetError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, child: isError ? _getErrorBody() : _getBody());
  }

  _getErrorBody() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: isError ? 40 : 50,
                decoration: BoxDecoration(
                  borderRadius: borderRadiusCustom(bottomLeft: 30.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset(0, 0),
                        color: Colors.grey.shade400,
                        spreadRadius: 5)
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadiusCustom(bottomLeft: 30.0),
              ),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: borderRadiusCustom(bottomLeft: 30.0),
                      color: ColorConstants.arogya_plus_gradient_color1),
                  child: _headerWidget()),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            child: getErrorAlert(),
          ),
        )
      ],
    );
  }

  _getBody() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: borderRadiusCustom(bottomLeft: 30.0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20,
                        offset: Offset(0, 0),
                        color: Colors.grey.shade400,
                        spreadRadius: 5)
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadiusCustom(bottomLeft: 30.0),
              ),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: borderRadiusCustom(bottomLeft: 30.0),
                      color: ColorConstants.arogya_plus_gradient_color1),
                  child:
                      isHavingPolicy ? _headerWidget() : _headerEmptyWidget()),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        isHavingPolicy
            ? ServiceOptionsWidget(_bloc, widget.homeKey, widget.downloadPdf)
            : Container(
                child: Column(
                  children: <Widget>[
                    Image.asset(AssetConstants.bg_policy_empty),
                  ],
                ),
              ),
        if (isHavingPolicy)
          SizedBox(
            height: 20,
          )
      ],
    );
  }

  _headerWidget() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: AddPolicyWidget(),
        ),
        SizedBox(
          height: 15,
        ),
        Visibility(
          visible: !isError,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: PoliciesListWidget(_bloc),
          ),
        ),
      ],
    );
  }

  _headerEmptyWidget() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 15, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              S.of(context).welcome_title.toUpperCase() + "!",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0),
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              S.of(context).policy_services_message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
            ),
            SizedBox(
              height: 15,
            ),
            AddPolicyWidget(),
          ],
        ),
      ),
    );
  }
}

enum ErrorType { INTERNET_ERROR, SERVER_ERROR }
