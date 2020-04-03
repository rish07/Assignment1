import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/dynamic_read_more_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_time_period_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_premium_break_up_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/dynamic_product_info_bottom_sheet.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class CriticalTimePeriodScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/critical_illness/time_period_screen";

  final CriticalIllnessModel criticalIllnessModel;

  CriticalTimePeriodScreen(this.criticalIllnessModel);

  @override
  _TimePeriodScreenState createState() => _TimePeriodScreenState();
}

class _TimePeriodScreenState extends State<CriticalTimePeriodScreen>
    with CommonWidget {
  bool _isAlertVisible = false;
  int _selectedTimePeriod = -1;
  List<CriticalTimePeriodModel> _timePeriodList;
  String sumInsuredDetails = '';

  @override
  void didChangeDependencies() {
    CriticalSumInsuredModel sumInsuredModel =
        widget.criticalIllnessModel.sumInsuredModel;
    var timePeriod = sumInsuredModel.timePeriodList;
    _timePeriodList = [];
    sumInsuredDetails =
        '${S.of(context).sum_insured_title}: ${sumInsuredModel.amountString}';
    for (int i = 0; i < timePeriod.length; i++) {
      var time = timePeriod[i];
      if(time != null) {
        int year = int.parse(time.year) ?? 0;
        String yearString = year <= 1 ? "Year" : "Years";
        _timePeriodList.add(CriticalTimePeriodModel(
            year: year,
            yearString: "${time.year} $yearString",
            actualPremium: time.grossPremium,
            discountedPremium: time.premiumWithdiscount,
            basicPremium: time.grossPremium,
            totalPremium: time.duePremium,
            discountPercentage: time.discountPercentage,
            isDiscountApplicable: (time.discountPercentage != null &&
                time.discountPercentage != 0) ? true : false,
            taxAmount: time.taxAmount,
            sumInsured: time.sumInsured,
            tax: time.tax));
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          getAppBar(context, S.of(context).coverage_period_title.toUpperCase()),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            sumInsuredDetails,
                            style: TextStyle(
                                color: ColorConstants.disco,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SizedBox(
                                width: 15.0,
                                height: 15.0,
                                child: Image.asset(AssetConstants.ic_edit)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        S.of(context).select_time_period_title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontFamily: StringConstants.EFFRA_LIGHT),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        S.of(context).select_time_period_subtitle,
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GridView.count(
                        childAspectRatio: 0.9,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            List.generate(_timePeriodList.length, (index) {
                          return _buildListItem(_timePeriodList[index], index);
                        }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
//            Padding(
//              padding: const EdgeInsets.only(
//                  bottom: 25.0 + 8.0 - 20.0, left: 12.0, right: 12.0),
//              child: Align(
//                alignment: Alignment.bottomCenter,
//                child: AlertWidget(S.of(context).select_time_period_error,
//                    _isAlertVisible ? 168 : 0),
//              ),
//            ),
//            Align(
//                alignment: Alignment.bottomCenter, child: _showPremiumButton()),
            ),
            _bottomButtonsWidget()
          ],
        ),
      ),
    );
  }

  Widget _bottomButtonsWidget() {
    const double childPaddingVal = 12.0;
    return Container(
      color: ColorConstants.critical_illness_blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
//          Expanded(
//            child: Container(
//              color: ColorConstants.critical_illness_bottom_blue,
//              child: Padding(
//                padding: const EdgeInsets.only(
//                    top: childPaddingVal, bottom: childPaddingVal),
//                child: _bottomButtonItem(S.of(context).critical_view_policy,
//                    AssetConstants.ic_stetho, () {
//                  showTaxBenefitAndOpdBenefitDialog(policyBenefit, context);
//                }),
//              ),
//            ),
//          ),
//          Container(
//            width: 1,
//            color: Colors.blue,
//          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: childPaddingVal, bottom: childPaddingVal),
                child: _bottomButtonItem(
                    S.of(context).critical_tax_benefits, AssetConstants.ic_tax,
                    () {
                  showTaxBenefitAndOpdBenefitDialog(taxBenefit, context);
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomButtonItem(String title, String icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                icon,
                height: 20,
                width: 20,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  _buildListItem(CriticalTimePeriodModel timePeriodModel, int index) {
    bool isSelected = (_selectedTimePeriod == index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 15.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (_isAlertVisible) {
                      setState(() {
                        _isAlertVisible = false;
                      });
                    }
//                    _selectedTimePeriod = index;
                    onClick(index);
                  });
                },
                child: Card(
                  elevation: isSelected ? 5.0 : 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius(topLeft: 30.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: (!isSelected)
                          ? Border.all(color: Colors.grey[300])
                          : null,
                      borderRadius: borderRadius(radius: 0.0, topLeft: 30.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Opacity(
                              opacity: isSelected ? 1.0 : 0.1,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: ColorConstants
                                        .policy_type_gradient_color1,
                                    borderRadius: borderRadius(
                                        radius: 0.0, topLeft: 30.0),
                                    gradient: isSelected
                                        ? LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              ColorConstants
                                                  .east_bay,
                                                ColorConstants
                                                    .disco,
                                                ColorConstants
                                                    .disco
                                              ])
                                        : null),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(timePeriodModel.yearString,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: isSelected
                                              ? Colors.white
                                              : ColorConstants
                                                  .disco,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 5.0,
                                    top: 15.0,
                                    bottom: 5.0),
                                child: Text(
                                    '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.discountedPremium)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500)),
                              ),
                              if (timePeriodModel.isDiscountApplicable)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 5.0),
                                  child: Text(
                                      '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.actualPremium)}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[500],
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.w500)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //Discount Widget (Red one)
          if (timePeriodModel.discountPercentage != 0)
            Positioned(
              right: -5,
              child: Container(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          width: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(AssetConstants.ic_offer),
                                  fit: BoxFit.fill))),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('${timePeriodModel.discountPercentage}%',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                              Text('DISCOUNT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  onClick(int index) {
    setState(() {
      _selectedTimePeriod = index;
      widget.criticalIllnessModel.timePeriodModel =
          _timePeriodList[_selectedTimePeriod];
      Navigator.of(context).pushNamed(CriticalPremiumBreakupScreen.ROUTE_NAME,
          arguments: widget.criticalIllnessModel);
    });
  }


  showPolicyBenefits(){
    List<DynamicReadMoreModel> list = [];
    list.add(DynamicReadMoreModel(StringDescription.BENEFITS_POINT_1));
    list.add(DynamicReadMoreModel(StringDescription.BENEFITS_POINT_2));
    list.add(DynamicReadMoreModel(StringDescription.BENEFITS_POINT_3));
    list.add(DynamicReadMoreModel(StringDescription.BENEFITS_POINT_4));
    DynamicProductInfoReadMoreWidget dynamicProductInfoReadMoreWidget;
    dynamicProductInfoReadMoreWidget = DynamicProductInfoReadMoreWidget(
      S.of(context).view_benefits,
      (){},
      pointsList: list,
      isHavingImportantNote: false,
      note: "",
      showCloseButton: true,
    );

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: dynamicProductInfoReadMoreWidget));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: dynamicProductInfoReadMoreWidget));
    }
  }


  showTaxBenefitAndOpdBenefitDialog(int from, BuildContext context) {
    BaseApiProvider.isInternetConnected().then((isConnected) {
      if (isConnected) {
        if (from == taxBenefit) {
          showWebView(UrlConstants.TAX_BENEFIT_WEBVIEW_URL,
              S.of(context).tax_benefit, DialogKind.TAX_BENEFIT, -1, context);
        } else {
          showPolicyBenefits();
        }
      } else {
        showNoInternetDialog(context, from, (int retryIdentifier) {
          showTaxBenefitAndOpdBenefitDialog(from, context);
        });
      }
    });
  }

  policyBenefitWidget() {
    return Container(

    );
  }
}
