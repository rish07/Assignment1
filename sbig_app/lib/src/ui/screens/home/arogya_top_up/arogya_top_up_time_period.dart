import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_time_period_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_topup_premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';


class ArogyaTopUpTimePeriodScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_top_up/time_period_screen";

  final  ArogyaTopUpModel arogyaTopUpModel;

  ArogyaTopUpTimePeriodScreen(this.arogyaTopUpModel);

  @override
  _TimePeriodScreenState createState() => _TimePeriodScreenState();
}

class _TimePeriodScreenState extends State<ArogyaTopUpTimePeriodScreen>
    with CommonWidget {
  bool _isAlertVisible = false;
  int _selectedTimePeriod = -1;
  List<ArogyaTimePeriodModel> _timePeriodList;
  String sumInsuredDetails = '';

  @override
  void didChangeDependencies() {
    ArogyaSumInsuredModel sumInsuredModel = widget.arogyaTopUpModel.selectedSumInsured;
    var timePeriod = widget.arogyaTopUpModel.selectedSumInsured.timePeriod;
    _timePeriodList = [];

    String sumInsuredAmt = CommonUtil.instance.convertSumInsuredWithRupeeSymbol(sumInsuredModel.amount)?? '' ;
    String deduction = CommonUtil.instance.convertSumInsuredWithRupeeSymbol(sumInsuredModel.deduction)?? '' ;
    sumInsuredDetails = '${S.of(context).sum_insured_title}: $sumInsuredAmt\n${S.of(context).deductible}: $deduction';

    var time1 = timePeriod?.year1;
    if(time1 !=null){
      _timePeriodList.add(ArogyaTimePeriodModel(
          year: 1,
          yearString: "1 Year",
          actualPremium: time1.basePremium,
          discountedPremium: time1.premiumWithdiscount,
          basicPremium: time1.basePremium,
          totalPremium: time1.totalPremium,
          discountPercentage: time1.discountPercentage,
          discountValue: time1.discountedValue,
          isDiscountApplicable: (time1.discountPercentage!=null && time1.discountPercentage!=0)?true:false,
          taxAmount: time1.taxAmount,
          sumInsured: sumInsuredModel?.amount ??0,
          member_discount_percentage: time1.memberDiscountPercentage,
          member_discount_value: time1.memberDiscountValue,
          tax: time1.tax));
    }

    var time2 = timePeriod?.year2;
    if(time2 !=null){
      _timePeriodList.add(ArogyaTimePeriodModel(
          year: 2,
          yearString: "2 Years",
          actualPremium: time2.basePremium,
          discountedPremium: time2.premiumWithdiscount,
          basicPremium: time2.basePremium,
          totalPremium: time2.totalPremium,
          discountPercentage: time2.discountPercentage,
          discountValue: time2.discountedValue,
          isDiscountApplicable: (time2.discountPercentage!=null && time2.discountPercentage!=0)?true:false,
          taxAmount: time2.taxAmount,
          sumInsured: sumInsuredModel?.amount ??0,
          member_discount_percentage: time2.memberDiscountPercentage,
          member_discount_value: time1.memberDiscountValue,
          tax: time2.tax));
    }

    var time3 = timePeriod?.year3;
    if(time3 !=null){
      _timePeriodList.add(ArogyaTimePeriodModel(
          year: 3,
          yearString: "3 Years",
          actualPremium: time3.basePremium,
          discountedPremium: time3.premiumWithdiscount,
          basicPremium: time3.basePremium,
          totalPremium: time3.totalPremium,
          discountPercentage: time3.discountPercentage,
          discountValue: time3.discountedValue,
          isDiscountApplicable: (time3.discountPercentage!=null && time3.discountPercentage!=0)?true:false,
          taxAmount: time3.taxAmount,
          sumInsured: sumInsuredModel?.amount ??0,
          member_discount_percentage: time3.memberDiscountPercentage,
          member_discount_value: time1.memberDiscountValue,
          tax: time3.tax));
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
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            sumInsuredDetails,
                            style: TextStyle(
                                color: ColorConstants.opd_amount_text_color,
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
                        height: 30.0,
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
          /// Policy Benefits is not there for arogya Premier ..
          /* Expanded(
            child: Container(
              color: ColorConstants.critical_illness_bottom_blue,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: childPaddingVal, bottom: childPaddingVal),
                child: _bottomButtonItem(S.of(context).critical_view_policy,
                    AssetConstants.ic_stetho, () {
                      showTaxBenefitAndOpdBenefitDialog(policyBenefit, context);
                    }),
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.blue,
          ),*/
          Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: childPaddingVal, bottom: childPaddingVal),
                child: _bottomButtonItem(
                    S.of(context).tax_benefits_2, AssetConstants.ic_tax,
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
          Padding(
            padding: const EdgeInsets.only(left:28.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    ColorConstants.pre_medical_gradient_color1,
                    ColorConstants.pre_medical_gradient_color2
                  ])),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  icon,
                  height: 20,
                  width: 20,
                ),
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
  _buildListItem(ArogyaTimePeriodModel timePeriodModel, int index) {
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
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          ColorConstants
                                              .policy_type_gradient_color1,
                                          ColorConstants
                                              .policy_type_gradient_color2
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
                                              .time_period_year_color,
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
      widget.arogyaTopUpModel.selectedTimePeriodModel = _timePeriodList[_selectedTimePeriod];
      Navigator.of(context).pushNamed(ArogyaTopUpPremiumBreakupScreen.ROUTE_NAME,
          arguments: widget.arogyaTopUpModel);
    });
  }

  showTaxBenefitAndOpdBenefitDialog(int from, BuildContext context) {
    BaseApiProvider.isInternetConnected().then((isConnected) {
      if (isConnected) {
        if (from == taxBenefit) {
          showWebView(UrlConstants.TAX_BENEFIT_WEBVIEW_URL,
              S.of(context).tax_benefit, DialogKind.TAX_BENEFIT, -1, context);
        } else {
          //TODO data from new HTML
          showWebView(UrlConstants.AROGYA_PLUS_OPD_BENEFIT_WEBVIEW_URL,
              S.of(context).opd_benefit, DialogKind.OPD_BENEFIT, -1, context);
        }
      } else {
        showNoInternetDialog(context, from, (int retryIdentifier) {
          showTaxBenefitAndOpdBenefitDialog(from, context);
        });
      }
    });
  }
}


