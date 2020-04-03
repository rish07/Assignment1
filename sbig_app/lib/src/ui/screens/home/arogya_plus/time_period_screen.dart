import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/time_period_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class TimePeriodScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_plus/time_period_screen";

  final SelectedMemberDetails selectedMemberDetails;

  TimePeriodScreen(this.selectedMemberDetails);

  @override
  _TimePeriodScreenState createState() => _TimePeriodScreenState();
}

class _TimePeriodScreenState extends State<TimePeriodScreen> with CommonWidget {
  bool _isAlertVisible = false;
  int _selectedTimePeriod = -1;
  List<TimePeriodModel> _timePeriodList;
  String sumInsuredDetails = '';

  @override
  void didChangeDependencies() {
    TimePeriod selected1stYearAndPremium =
        widget.selectedMemberDetails.selectedYearAndPremium;
    SumInsuredModel sumInsuredModel =
        widget.selectedMemberDetails.selectedSumInsured;
    Opd opd = widget.selectedMemberDetails.calculatedPremiumResModel.opd;

    TimePeriod selected2ndYearAndPremium, selected3rdYearAndPremium;

    for (TimePeriod t in opd.year2) {
      if (t.premium == (2 * selected1stYearAndPremium.premium)) {
        selected2ndYearAndPremium = t;
        break;
      }
    }

    for (TimePeriod t in opd.year3) {
      if (t.premium == (3 * selected1stYearAndPremium.premium)) {
        selected3rdYearAndPremium = t;
        break;
      }
    }

//    sumInsuredDetails =
//        '${S.of(context).sum_insured_title}: ${sumInsuredModel.amountString} | ${S.of(context).opd_limit_title}: ${CommonUtil.instance.getCurrencyFormat().format(selected1stYearAndPremium.opd)}';
    sumInsuredDetails =
        '${S.of(context).sum_insured_title}: ${sumInsuredModel.amountString}';

    _timePeriodList = [
      TimePeriodModel(
          year: selected1stYearAndPremium.year,
          yearString: "${selected1stYearAndPremium.year} Year",
          total_premium: selected1stYearAndPremium.total_premium,
          actualPremium: selected1stYearAndPremium.premium,
          discountedPremium: selected1stYearAndPremium.premium_withdiscount,
          discountPercentage: selected1stYearAndPremium.discount_percentage,
          discount_value: selected1stYearAndPremium.discount_value,
          opd: selected1stYearAndPremium.opd,
          tax: selected1stYearAndPremium.tax,
          tax_amount: selected1stYearAndPremium.tax_amount,
          basicpremium: selected1stYearAndPremium.basicpremium,
          childCount: selected1stYearAndPremium.childCount,
          adultCount: selected1stYearAndPremium.adultCount,
          member_discount_percentage: selected1stYearAndPremium.member_discount_percentage,
          member_discount_value: selected1stYearAndPremium.member_discount_value,
          member_individual_premium: selected1stYearAndPremium.member_individual_premium),
      TimePeriodModel(
          year: selected2ndYearAndPremium.year,
          yearString: "${selected2ndYearAndPremium.year} Years",
          total_premium: selected2ndYearAndPremium.total_premium,
          actualPremium: selected2ndYearAndPremium.premium,
          discountedPremium: selected2ndYearAndPremium.premium_withdiscount,
          discountPercentage: selected2ndYearAndPremium.discount_percentage,
          discount_value: selected2ndYearAndPremium.discount_value,
          opd: selected2ndYearAndPremium.opd,
          tax: selected2ndYearAndPremium.tax,
          tax_amount: selected2ndYearAndPremium.tax_amount,
          basicpremium: selected2ndYearAndPremium.basicpremium,
          childCount: selected2ndYearAndPremium.childCount,
          adultCount: selected2ndYearAndPremium.adultCount,
          member_discount_percentage:
              selected2ndYearAndPremium.member_discount_percentage,
          member_discount_value:
              selected2ndYearAndPremium.member_discount_value,
          member_individual_premium: selected2ndYearAndPremium.member_individual_premium),
      TimePeriodModel(
          year: selected3rdYearAndPremium.year,
          yearString: "${selected3rdYearAndPremium.year} Years",
          total_premium: selected3rdYearAndPremium.total_premium,
          actualPremium: selected3rdYearAndPremium.premium,
          discountedPremium: selected3rdYearAndPremium.premium_withdiscount,
          discountPercentage: selected3rdYearAndPremium.discount_percentage,
          discount_value: selected3rdYearAndPremium.discount_value,
          opd: selected3rdYearAndPremium.opd,
          tax: selected3rdYearAndPremium.tax,
          tax_amount: selected3rdYearAndPremium.tax_amount,
          basicpremium: selected3rdYearAndPremium.basicpremium,
          childCount: selected3rdYearAndPremium.childCount,
          adultCount: selected3rdYearAndPremium.adultCount,
          member_discount_percentage:
              selected3rdYearAndPremium.member_discount_percentage,
          member_discount_value:
              selected3rdYearAndPremium.member_discount_value,
          member_individual_premium: selected3rdYearAndPremium.member_individual_premium),
    ];
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
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3.0, top: 5.0, bottom: 5.0, right: 5.0),
                              child: SizedBox(
                                  width: 15.0,
                                  height: 15.0,
                                  child: Image.asset(AssetConstants.ic_edit)),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
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
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
        /*  Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: childPaddingVal, bottom: childPaddingVal),
                child: _bottomButtonItem(
                    S.of(context).opd_benefits_2, AssetConstants.ic_stetho, () {
                  showTaxBenefitAndOpdBenefitDialog(opdBenefit, context);
                }),
              ),
            ),
          ),
          SizedBox(
            width: 1,
          ),*/
          Expanded(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: childPaddingVal, bottom: childPaddingVal),
                child: _bottomButtonItem(
                    S.of(context).tax_benefits_2, AssetConstants.ic_tax, () {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
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
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  _buildListItem(TimePeriodModel timePeriodModel, int index) {
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
                                            begin: Alignment.topRight,
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
                              if (timePeriodModel.discountPercentage != 0)
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
      widget.selectedMemberDetails.finalSelectedYearAndPremium =
          _timePeriodList[_selectedTimePeriod];
      widget.selectedMemberDetails.isFrom =
          PremiumBreakupScreen.FROM_TIME_PERIOD_SCREEN;
      Navigator.of(context).pushNamed(PremiumBreakupScreen.ROUTE_NAME,
          arguments: widget.selectedMemberDetails);
    });
  }

//  Widget _showPremiumButton() {
//    onClick() {
//      setState(() {
//        if (_selectedTimePeriod == -1) {
//          _isAlertVisible = true;
//        } else {
//          widget.selectedMemberDetails.finalSelectedYearAndPremium =
//              _timePeriodList[_selectedTimePeriod];
//          widget.selectedMemberDetails.isFrom = PremiumBreakupScreen.FROM_TIME_PERIOD_SCREEN;
//          Navigator.of(context).pushNamed(PremiumBreakupScreen.ROUTE_NAME,
//              arguments: widget.selectedMemberDetails);
//        }
//      });
//    }
//
//    return BlackButtonWidget(
//        onClick, S.of(context).get_a_quote_title.toUpperCase());
//  }

  showTaxBenefitAndOpdBenefitDialog(int from, BuildContext context) {
    BaseApiProvider.isInternetConnected().then((isConnected) {
      if (isConnected) {
        if (from == taxBenefit) {
          showWebView(UrlConstants.TAX_BENEFIT_WEBVIEW_URL,
              S.of(context).tax_benefit, DialogKind.TAX_BENEFIT, -1, context);
        } else {
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
