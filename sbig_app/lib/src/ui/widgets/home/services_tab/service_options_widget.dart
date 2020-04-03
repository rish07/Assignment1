import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/mics/arogya_plus_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/home_tabs/home_bloc.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_req_res_model.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/download_status_model.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/insured_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/policy_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/proposer_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/service_item.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/health_claim_intimation/health_claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_screen_phase1.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_policy_summery_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/contact_sbig_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/faqs_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/my_downloads_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/whats_covered_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/circle_button.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
import 'package:shimmer/shimmer.dart';

class ServiceOptionsWidget extends StatefulWidget {
  HomeBloc homeBloc;
  GlobalKey<ScaffoldState> homeKey;
  Function(DocType, String) downloadPdf;

  ServiceOptionsWidget(this.homeBloc, this.homeKey, this.downloadPdf);

  @override
  _ServiceOptionsWidgetState createState() => _ServiceOptionsWidgetState();
}

class _ServiceOptionsWidgetState extends State<ServiceOptionsWidget>
    with CommonWidget {
  int totalCount = 16;
  int thirdItem = 0;
  int gridCrossAxisCount = 3;

  final int isFromCoverage = 1;
  final int isFromFaqs = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.homeBloc.currentPolicyStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool isHavingData = snapshot.hasData;

          PolicyListItem policyListItem;
          List<ServicesListItem> servicesList = List();
          if (isHavingData && !isError) {
            policyListItem = snapshot.data;

            servicesList.addAll(widget.homeBloc.getServicesList);
            String productCode = policyListItem.productCode;

            int i = 0;
            List<String> removeServices = [];
            for (ServicesListItem s in servicesList) {
              List<IsApplicable> list = s.isApplicable;
              if (list != null && list.length > 0) {
                if (s.serviceCode.compareTo("RP") == 0) {
                  if (policyListItem.renewalDueDate != null) {
                    DateTime renewalDueDate = CommonUtil.instance
                        .parseDateYYYY_MM_DD_TIME(
                            policyListItem.renewalDueDate);
                    bool isBefore = DateTime.now().isBefore(renewalDueDate);

                    bool isRenewalApplicable = false;
                    if (isBefore) {
                      Duration duration =
                          DateTime.now().difference(renewalDueDate);
                      int difference = duration.inDays;
                      if (difference >= 0 && difference <= 60) {
                        isRenewalApplicable = true;
                      }
                    }
                    if (!isRenewalApplicable) {
                      removeServices.add(s.serviceCode);
                    }
                  } else {
                    removeServices.add(s.serviceCode);
                  }
                }
                for (IsApplicable isApplicable in list) {
                  if (isApplicable.productCode.compareTo(productCode) == 0) {
                    if (!isApplicable.isEnabled) {
                      print(isApplicable.productCode + " " + i.toString());
                      removeServices.add(s.serviceCode);
                      break;
                    }
                  }
                }
              }
              i++;
            }

            for (String serviceTag in removeServices) {
              servicesList.removeWhere(
                  (item) => item.serviceCode.compareTo(serviceTag) == 0);
            }
            totalCount = servicesList.length;
          }

          return GridView.count(
              crossAxisCount: gridCrossAxisCount,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(totalCount, (index) {
                bool isLastItem =
                    !(index > 1 && ((index + 1) % gridCrossAxisCount) == 0);
                bool isFirstItem = (index == 0) || (index % 3 == 0);
                bool isLastRow = (index >= totalCount - totalCount % 3);

                return GridTile(
                  child: InkResponse(
                    onTap: () {
                      if (servicesList != null) {
                        _onClickService(servicesList[index], policyListItem);
                      }
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          (isHavingData && !isError)
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: MaterialButton(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      onPressed: () {
                                                        if (servicesList !=
                                                            null) {
                                                          _onClickService(
                                                              servicesList[
                                                                  index],
                                                              policyListItem);
                                                        }
                                                      },
                                                      focusColor: ColorConstants
                                                          .critical_illness_quote_number_color,
                                                      splashColor: ColorConstants
                                                          .critical_illness_quote_number_color,
                                                      child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                            shape: BoxShape
                                                                .circle),
                                                        child: !TextUtils.isEmpty(
                                                                servicesList[
                                                                        index]
                                                                    .serviceImage)
                                                            ? Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            12.0),
                                                                child: Image
                                                                    .network(
                                                                        "${UrlConstants.URL}${servicesList[index].serviceImage}"),
                                                              )
                                                            : null,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : _getLoadingContainerImage(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: (isHavingData && !isError)
                                                ? Text(
                                                    _getSplittedString(
                                                        servicesList[index]
                                                            .serviceName),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade800,
                                                        fontSize: 12.0),
                                                  )
                                                : _getEmptyLoadingContainer(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isLastRow)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: isFirstItem ? 15 : 0.0,
                                        right: !isLastItem ? 15 : 0.0),
                                    child: Divider(
                                      color: Colors.grey.shade300,
                                      height: 1,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isLastItem)
                            Container(
                              color: Colors.grey.shade300,
                              height: double.infinity,
                              width: 0.5,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
        });
  }

  _getSplittedString(String toBeSplitted) {
    List<String> list = toBeSplitted.split(' ');
    StringBuffer stringBuffer = StringBuffer();
    int i = 0;
    for (String s in list) {
      stringBuffer.write(s);
      if (i == 0) {
        stringBuffer.write('\n');
      } else {
        stringBuffer.write(' ');
      }
      i++;
    }
    return stringBuffer.toString();
  }

  _getLoadingContainerImage() {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey.shade300),
            shape: BoxShape.circle),
      ),
    ));
  }

  _getEmptyLoadingContainer() {
    return Container(
        child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadiusAll(radius: 6.0),
          color: Colors.grey[100],
        ),
        width: 75,
        height: 12,
      ),
    ));
  }

  _onClickService(ServicesListItem service, PolicyListItem policyListItem) {
    switch (service.serviceCode) {
      case "RP":
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (isConnected) {
            _apiCallToGetPolicyDetails(policyListItem);
          } else {
            widget.homeKey.currentState.showSnackBar(SnackBar(
              content: Text(S.of(context).no_internet_dialog_message),
            ));
          }
        });
        break;
      case "CI":
        if (null != policyListItem.memberDetails) {
          ProposerListItem proposerListItem =
              policyListItem.memberDetails.proposer_details;
          List<InsuredListItem> insuredMembersList =
              policyListItem.memberDetails.insured_members_list;
          if(insuredMembersList != null && insuredMembersList.length > 0) {
            List<String> insuredMembersStringsList = List();
            for (InsuredListItem i in insuredMembersList) {
              insuredMembersStringsList.add(i.insuredName);
            }
            HealthClaimIntimationArguments healthClaimIntimationArguments =
            HealthClaimIntimationArguments(
                policyListItem.policyNo,
                proposerListItem.mobile ?? "",
                policyListItem.policyType,
                insuredMembersStringsList);
            Future.delayed(Duration(microseconds: 250), () {
              Navigator.of(context).pushNamed(
                  HealthClaimIntimationScreen.ROUTE_NAME,
                  arguments: healthClaimIntimationArguments);
            });
          }else{
            print("INSURED LIST IS ZERO "+policyListItem.policyNo.toString());
          }
        }else{
          print("MEMBER DETAILS NULL "+ policyListItem.policyNo.toString());
        }
        break;
      case "NH":
        Navigator.of(context).pushNamed(NetworkHospitalScreen.ROUTE_NAME);
        break;
      case "NG":
        break;
      case "HC":
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (isConnected) {
            widget.downloadPdf(DocType.HEALTH_CARD, policyListItem.policyNo);
          } else {
            widget.homeKey.currentState.showSnackBar(SnackBar(
              content: Text(S.of(context).no_internet_dialog_message),
            ));
          }
        });
        break;
      case "DPC":
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (isConnected) {
            widget.downloadPdf(
                DocType.POLICY_DOCUMENT, policyListItem.policyNo);
          } else {
            widget.homeKey.currentState.showSnackBar(SnackBar(
              content: Text(S.of(context).no_internet_dialog_message),
            ));
          }
        });
        break;
      case "FAQ":
      case "WC":
        BaseApiProvider.isInternetConnected().then((isConnected) {
          if (isConnected) {
            for (IsApplicable isApplicable in service.isApplicable) {
              if (isApplicable.productCode
                      .compareTo(policyListItem.productCode) ==
                  0) {
                if (!TextUtils.isEmpty(policyListItem.sub_product_code)) {
                  if (policyListItem.sub_product_code.toLowerCase().compareTo(
                          isApplicable.sub_product_code.toLowerCase()) ==
                      0) {
                    _getProductInfo(
                        isApplicable.product_tag_name ?? "",
                        service.serviceCode.compareTo("WC") == 0
                            ? isFromCoverage
                            : isFromFaqs);
                  } else {
                    print("NO MATCH FOUND");
                  }
                } else {
                  _getProductInfo(
                      isApplicable.product_tag_name ?? "",
                      service.serviceCode.compareTo("WC") == 0
                          ? isFromCoverage
                          : isFromFaqs);
                }
                break;
              }
            }
          } else {
            widget.homeKey.currentState.showSnackBar(SnackBar(
              content: Text(S.of(context).no_internet_dialog_message),
            ));
          }
        });
        break;
      case "ECD":
        break;
      case "CSBIG":
        Navigator.of(context).pushNamed(ContactSBIGScreen.ROUTE_NAME);
        break;
      case "MD":
//        Navigator.of(context).pushNamed(MyDownloadsScreen.ROUTE_NAME,
//            arguments: policyListItem.policyNo);
    }
  }

  _apiCallToGetPolicyDetails(PolicyListItem policyListItem) {
    retry(int from) {
      _apiCallToGetPolicyDetails(policyListItem);
    }

    showLoaderDialog(context);
    RenewalPolicyDetailsReqModel renewalPolicyDetailsReqModel =
        RenewalPolicyDetailsReqModel();
    renewalPolicyDetailsReqModel.policyNumber = policyListItem.policyNo;
    renewalPolicyDetailsReqModel.policytype = "Renewal";
    renewalPolicyDetailsReqModel.productCode = policyListItem.productCode;

    if (null != policyListItem.memberDetails) {
      ProposerListItem proposerListItem =
          policyListItem.memberDetails.proposer_details;
      if (proposerListItem != null) {
        if (policyListItem.policyType.toLowerCase().compareTo("health") == 0) {
          DateTime birthday = CommonUtil.instance
              .parseDateYYYY_MM_DD_TIME(proposerListItem.birthday);
          String birthdayYYYY_MM_DD =
              CommonUtil.instance.convertTo_dd_MM_yyyy(birthday);
          print("birthdayYYYY_MM_DD " + birthdayYYYY_MM_DD);
          renewalPolicyDetailsReqModel.primaryInsuredDOB = birthdayYYYY_MM_DD;
        } else if (policyListItem.policyType.toLowerCase().compareTo("motor") ==
            0) {
          renewalPolicyDetailsReqModel.registrationNumber =
              proposerListItem.registerNumber;
        }
      } else {
        print("PROPOSER DETAILS NULL");
      }
    } else {
      print("MEMBER DETAILS NULL");
    }

    widget.homeBloc
        .getPolicyDetails(renewalPolicyDetailsReqModel.toJson())
        .then((response) {
      hideLoaderDialog(context);
      if (null != response.apiErrorModel) {
        handleApiError(context, 0, retry, response.apiErrorModel.statusCode,
            message: response.apiErrorModel.message);
      } else {
        RenewalReqResModel renewalReqResModel = RenewalReqResModel(
            renewalPolicyDetailsReqModel: renewalPolicyDetailsReqModel,
            renewalPolicyDetailsResModel: response.data);
        Navigator.of(context).pushNamed(RenewalPolicySummeryScreen.ROUTE_NAME,
            arguments: renewalReqResModel);
      }
    });
  }

  _getProductInfo(String tag, int from) async {
    retryIdentifier(int identifier) {
      _getProductInfo(tag, from);
    }

    showLoaderDialog(context);
    final response = await widget.homeBloc.getProductInfo(tag);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      List<Body> bodyList = response.data.body;
      for (Body b in bodyList) {
        if (from == isFromCoverage) {
          if (b.title.toLowerCase().trim().compareTo("coverage") == 0) {
            List<Points> points = b.points;
            List<PedQuestionsModel> questionAnswerList = List();
            for (Points p in points) {
              PedQuestionsModel pedQuestionsModel = PedQuestionsModel();
              pedQuestionsModel.question = p.title;
              questionAnswerList.add(pedQuestionsModel);
            }
            Navigator.of(context).pushNamed(WhatsCoveredScreen.ROUTE_NAME,
                arguments: questionAnswerList);
            return;
          }
        } else if (from == isFromFaqs) {
          if (b.title.toLowerCase().trim().compareTo("faqs") == 0) {
            List<Points> points = b.points;
            List<PedQuestionsModel> questionAnswerList = List();
            for (Points p in points) {
              PedQuestionsModel pedQuestionsModel = PedQuestionsModel();
              pedQuestionsModel.question = p.title;
              for (SubPoints s in p.subPoints) {
                pedQuestionsModel.answer = s.title;
                break;
              }
              questionAnswerList.add(pedQuestionsModel);
            }
            Navigator.of(context).pushNamed(FaqsScreen.ROUTE_NAME,
                arguments: questionAnswerList);
            return;
          }
        }
      }
    }
  }
}
