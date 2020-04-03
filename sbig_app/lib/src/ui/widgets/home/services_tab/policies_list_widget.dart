import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sbig_app/src/controllers/blocs/home/home_tabs/home_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/insured_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/member_details.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/policy_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/proposer_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policy_card_details_ui_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shimmer/shimmer.dart';

class PoliciesListWidget extends StatefulWidget {
  HomeBloc homeBloc;

  PoliciesListWidget(this.homeBloc);

  @override
  _PoliciesListState createState() => _PoliciesListState();
}

class _PoliciesListState extends State<PoliciesListWidget> with CommonWidget {
  SwiperController _swiperController;
  int totalCount = 1;
  int currentIndex = 0;
  String vehicleRegTitle, insuredMembersTitle, carModelTitle, policyPeriodTitle;
  bool assetIcon;
  //bool isLoading = false;
  List<LoadingStatusModel> loadingStatusList;

  @override
  void initState() {
    _swiperController = SwiperController();
    _swiperController.addListener(() {
      print("CURRENT INDEX: " + _swiperController.index.toString());
    });
    print("PoliciesListWidget init called");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    vehicleRegTitle = S.of(context).vehicle_registration_no.toUpperCase();
    insuredMembersTitle = S.of(context).insured_members.toUpperCase();
    carModelTitle = S.of(context).car_model.toUpperCase();
    policyPeriodTitle = S.of(context).policy_period.toUpperCase();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.homeBloc.policiesStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool isHavingData = snapshot.hasData;

          List<PolicyListItem> policiesList;
          if (isHavingData && !isError) {
            policiesList = snapshot.data;
            totalCount = policiesList.length;
            loadingStatusList = List();
            for(PolicyListItem p in policiesList){
              loadingStatusList.add(LoadingStatusModel(p.policyNo, false));
            }
          }
          return Container(
            height: 150,
            child: Swiper(
              outer: true,
              layout: SwiperLayout.DEFAULT,
              index: currentIndex,
              loop: false,
              viewportFraction: 0.9,
              itemCount: totalCount,
              controller: _swiperController,
              onIndexChanged: (index) {
                currentIndex = index;
                widget.homeBloc.changeCurrentPolicy(policiesList[index]);
                List<PolicyListItem> policiesListData =
                    widget.homeBloc.policiesData;
                if (null == policiesListData[index].memberDetails) {
                  getMemberDetails(policiesList[index]);
                }
              },
              itemBuilder: (context, index) {
                return buildPolicyCard(
                    index, policiesList, isError, isHavingData);
              },
            ),
          );
        });
  }

  getMemberDetails(PolicyListItem policyListItem, {int index}) {
    widget.homeBloc
        .getMemberDetails(MemberDetailsReqModel(
                policy_no: policyListItem.policyNo,
                product_code: policyListItem.productCode)
            .toJson())
        .then((response) {

      print("INDEX "+index.toString());

      if (null == response.apiErrorModel) {
        List<PolicyListItem> policiesListData = widget.homeBloc.policiesData;

        int i = 0;
        for (PolicyListItem p in policiesListData) {
          if (p.policyNo.compareTo(policyListItem.policyNo) == 0) {
            policiesListData[i].memberDetails = response.memberDetails;
            policiesListData[i].apiHit =
                policiesListData[i].apiHit + 1;
            //isLoading = false;

            LoadingStatusModel loadingStatusModel = loadingStatusList[i];
            loadingStatusModel.isLoading = false;
            setState(() {
              loadingStatusList[i] = loadingStatusModel;
            });
          }
          i++;
        }

        widget.homeBloc.policiesData = policiesListData;
        widget.homeBloc.changePolicies(policiesListData);
      }else{
        LoadingStatusModel loadingStatusModel = loadingStatusList[index];
        if(loadingStatusModel.isLoading) {
          loadingStatusModel.isLoading = false;
          setState(() {
            loadingStatusList[index] = loadingStatusModel;
          });
        }
//        if(isLoading){
//          setState(() {
//            isLoading = false;
//          });
//        }
      }
    });
  }

  buildPolicyCard(int index, List<PolicyListItem> policiesList, bool isError,
      bool isHavingData) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    PolicyCardDetails policyCardDetails = PolicyCardDetails();

    if (policiesList != null) {
      PolicyListItem policyListItem = policiesList[index];

      policyCardDetails.apiHit = policyListItem.apiHit;

      policyCardDetails.productName = policyListItem.productName;
      policyCardDetails.policyNo = policyListItem.policyNo;
      policyCardDetails.proposerName = policyListItem.customerName;
      policyCardDetails.isMotor =
          (policyListItem.policyType.toLowerCase().compareTo("motor") == 0);
      policyCardDetails.asset = policyCardDetails.isMotor
          ? AssetConstants.ic_motor_policycard
          : AssetConstants.ic_health_policycard;

      PolicyMemberDetails memberDetails =
          widget.homeBloc.policiesData[index].memberDetails;

      if (memberDetails != null) {
        ProposerListItem proposerListItem = memberDetails.proposer_details;

        if (proposerListItem != null) {
          if (policyCardDetails.isMotor) {
            policyCardDetails.vehicleRegNumber =
                proposerListItem.registerNumber ?? "NA";

            StringBuffer stringBuffer = StringBuffer();
            stringBuffer.write(proposerListItem.company_name ?? "");
            stringBuffer.write(" ");
            stringBuffer.write(proposerListItem.model ?? "");

            if (stringBuffer.toString().trim().isNotEmpty) {
              policyCardDetails.carModel = stringBuffer.toString();
            } else {
              policyCardDetails.carModel = "NA";
            }
          }

          policyCardDetails.policyPeriod = proposerListItem.effectiveDate +
              " to " +
              proposerListItem.expiryDate;

          policyCardDetails.insuredMembersHalf = proposerListItem.propserName;
          policyCardDetails.insuredMembersFull = proposerListItem.propserName;
        }

        List<InsuredListItem> insuredMembers =
            memberDetails.insured_members_list;
        if (insuredMembers != null) {
          StringBuffer stringBuffer = StringBuffer();
          int length = insuredMembers.length;
          String firstInsuredName = "", secondInsuredName = "";

          if (length > 0) {
            int i = 0;
            for (InsuredListItem insuredListItem in insuredMembers) {
              stringBuffer.write(insuredListItem.insuredName);

              if (i == 0) {
                firstInsuredName = insuredListItem.insuredName;
              }

              if (i == 1) {
                secondInsuredName = insuredListItem.insuredName;
              }

              if (length - 1 != i) {
                stringBuffer.write(', ');
              }
              i++;
            }
            policyCardDetails.insuredMembersFull = stringBuffer.toString();
            String lengthOf2Names = secondInsuredName + ", " + firstInsuredName;
            print("lengthOf2Names " + lengthOf2Names.length.toString());
            if (secondInsuredName.isEmpty || lengthOf2Names.length > 30) {
              policyCardDetails.insuredMembersHalf = firstInsuredName + "..";
            } else {
              policyCardDetails.insuredMembersHalf =
                  firstInsuredName + ", " + secondInsuredName + "..";
            }
          }
        }
      } else {
        if (policyListItem.apiHit != 0) {
          policyCardDetails.isError = true;
        }
      }
    }

    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: _getFrontWidget(
          cardKey, policiesList, isError, isHavingData, policyCardDetails, index),
      back: _getBackWidget(
          cardKey, policiesList, isError, isHavingData, policyCardDetails),
    );
  }

  _getFrontWidget(
      GlobalKey<FlipCardState> cardKey,
      List<PolicyListItem> policiesList,
      bool isError,
      bool isHavingData,
      PolicyCardDetails policyCardDetails, int index) {
    return Container(
      child: Stack(
        children: <Widget>[
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadiusAll(radius: 10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: borderRadiusAll(radius: 10.0),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.policy_card_gradient_color1,
                          ColorConstants.policy_card_gradient_color2
                        ])),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              cardKey.currentState.toggleCard();
                            },
                            child: (isHavingData && !isError)
                                ? Text(
                                    policyCardDetails.proposerName
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0))
                                : getEmptyLoadingContainer(200),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          (isHavingData && !isError)
                              ? Text(policyCardDetails.productName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.5))
                              : SizedBox(
                                  width: 10,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      (isHavingData && !isError)
                          ? Container(
                              decoration: BoxDecoration(
                                  color: ColorConstants.policy_number_bg,
                                  borderRadius: borderRadiusAll(radius: 10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 3.0,
                                    bottom: 3.0),
                                child: Text(policyCardDetails.policyNo,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600)),
                              ),
                            )
                          : getEmptyLoadingContainer(150),
                      Expanded(
                          child: SizedBox(
                        height: 5,
                      )),
                      if (!policyCardDetails.isError)
                        (isHavingData && !isError && policyCardDetails.apiHit != 0)
                            ? Text(
                                policyCardDetails.isMotor
                                    ? vehicleRegTitle
                                    : insuredMembersTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.8))
                            : getEmptyLoadingContainer(150),
                      !policyCardDetails.isError
                          ? Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: (isHavingData && !isError && policyCardDetails.apiHit != 0)
                                        ? Text(
                                            policyCardDetails.isMotor
                                                ? policyCardDetails
                                                    .vehicleRegNumber
                                                : policyCardDetails
                                                    .insuredMembersHalf,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0))
                                        : getEmptyLoadingContainer(100),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cardKey.currentState.toggleCard();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
                                      child: Text(
                                        S.of(context).know_more.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                children: <Widget>[
                                  Text(S.of(context).policy_try_again_message,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0)),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkResponse(
                                      onTap: () {
                                        LoadingStatusModel loadingStatusModel = loadingStatusList[index];
                                        loadingStatusModel.isLoading = true;
                                        setState(() {
                                          loadingStatusList[index] = loadingStatusModel;
                                          //isLoading = true;
                                        });
                                        getMemberDetails(
                                            policiesList[currentIndex], index: index);
                                      },
                                      child: Container(
                                        width: loadingStatusList[index].isLoading ? 75 : null,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              borderRadiusAll(radius: 10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 6.0,
                                              right: 6.0,
                                              top: 3.0,
                                              bottom: 3.0),
                                          child: loadingStatusList[index].isLoading ? Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), strokeWidth: 1.5,))) : Text(
                                              S
                                                  .of(context)
                                                  .policy_try_again
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1.0)),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              )),
          Positioned(
            right: 15,
            top: 15,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: ColorConstants.policy_number_bg,
                  borderRadius: borderRadiusAll(radius: 10),
                  image: (isHavingData && !isError)
                      ? DecorationImage(
                          image: AssetImage(policyCardDetails.asset))
                      : null),
            ),
          ),
        ],
      ),
    );
  }

  _getBackWidget(
      GlobalKey<FlipCardState> cardKey,
      List<PolicyListItem> policiesList,
      bool isError,
      bool isHavingData,
      PolicyCardDetails policyCardDetails) {
    return Container(
      child: Stack(
        children: <Widget>[
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadiusAll(radius: 10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: borderRadiusAll(radius: 10.0),
                    color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (isHavingData && !isError)
                          ? Text(policyPeriodTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  letterSpacing: 0.8))
                          : getEmptyLoadingContainer(200),
                      SizedBox(
                        height: 5,
                      ),
                      (isHavingData && !isError)
                          ? Text(policyCardDetails.policyPeriod,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0))
                          : getEmptyLoadingContainer(150),
                      Expanded(
                          child: SizedBox(
                        height: 5,
                      )),
                      (isHavingData && !isError)
                          ? Text(
                              policyCardDetails.isMotor
                                  ? carModelTitle
                                  : insuredMembersTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                  letterSpacing: 0.8))
                          : getEmptyLoadingContainer(150),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: (isHavingData && !isError)
                                  ? Text(
                                      policyCardDetails.isMotor
                                          ? policyCardDetails.carModel
                                          : policyCardDetails
                                              .insuredMembersFull,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0))
                                  : getEmptyLoadingContainer(100),
                            ),
                            InkWell(
                              onTap: () {
                                cardKey.currentState.toggleCard();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
                                child: Text(
                                  S.of(context).back.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Positioned(
            right: 15,
            top: 15,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: ColorConstants.policy_number_bg,
                  borderRadius: borderRadiusAll(radius: 10),
                  image: (isHavingData && !isError)
                      ? DecorationImage(
                          image: AssetImage(policyCardDetails.asset))
                      : null),
            ),
          ),
        ],
      ),
    );
  }

  getEmptyLoadingContainer(double width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Container(
          child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[50],
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadiusAll(radius: 6.0),
            color: Colors.black38,
          ),
          width: width,
          height: 12,
        ),
      )),
    );
  }
}

class LoadingStatusModel{
  String policyNumber;
  bool isLoading;

  LoadingStatusModel(this.policyNumber, this.isLoading);

}