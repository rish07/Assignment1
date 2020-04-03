import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/premium_details/premium_bloc.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/time_period_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/arc_clipper.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/custom_arc_clipper2.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/common_util.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class SumInsuredAndPremiumScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_plus/sum_insured_screen";

  final SelectedMemberDetails arguments;

  SumInsuredAndPremiumScreen(this.arguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: SumInsuredAndPremiumWidget(arguments),
      bloc: PremiumBloc(),
    );
  }
}

class SumInsuredAndPremiumWidget extends StatefulWidgetBase {
  final SelectedMemberDetails arguments;

  SumInsuredAndPremiumWidget(this.arguments);

  @override
  _SumInsuredAndPremiumWidgetState createState() =>
      _SumInsuredAndPremiumWidgetState();
}

class _SumInsuredAndPremiumWidgetState extends State<SumInsuredAndPremiumWidget>
    with CommonWidget {
  bool isAlertVisible = false;
  int _selectedSumInsured = 2, _selectedPremium = -1;

  List<SumInsuredModel> sumInsuredList;
  List<TimePeriod> premiumList;
  double screenWidth;
  SelectedMemberDetails _selectedMemberDetails;

  PremiumBloc _bloc;
  int apiCallIndex = -1;
  static const double _buttonHeight = 70;

  @override
  void initState() {
    _bloc = SbiBlocProvider.of<PremiumBloc>(context);
    _selectedMemberDetails = widget.arguments;

    Opd opd = _selectedMemberDetails.calculatedPremiumResModel.opd;
    if (opd != null) {
      sumInsuredList = [
        SumInsuredModel(
            amount: 100000, amountString: '₹1 Lakh', timePeriodList: null),
        SumInsuredModel(
            amount: 200000, amountString: '₹2 Lakhs', timePeriodList: null),
        SumInsuredModel(
            amount: 300000,
            amountString: '₹3 Lakhs',
            timePeriodList: opd.year1,
            calculatePremiumReqModel:
                _selectedMemberDetails.calculatePremiumReqModel,
            calculatedPremiumResModel:
                _selectedMemberDetails.calculatedPremiumResModel)
      ];

      premiumList = opd.year1;
    }
    _listenForEvents();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil.getInstance(context).screenWidthDp - 40; //remove margin
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          getAppBar(context, S.of(context).coverage_amount_title.toUpperCase()),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.4,
            child: ClipPath(
              clipper: CurveClipper2(_buttonHeight),
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  ColorConstants.home_bg_gradient_color1,
                  ColorConstants.home_bg_gradient_color2
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          S.of(context).sum_insured_title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: StringConstants.EFFRA_LIGHT),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _buildSumInsuredList(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          S.of(context).premium_amount_title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontFamily: StringConstants.EFFRA_LIGHT),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: premiumList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return _buildPremiumListItem(
                                  premiumList[index], index);
                            }),
//                  SizedBox(
//                    height: 200,
//                  ),
                      ],
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text('${S.of(context).opd_benefits_applicable_title}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: ColorConstants.opd_amount_text_color)),
                  ),
                ],
              )),
//          Padding(
//            padding: const EdgeInsets.only(
//                bottom: 25.0 + 8.0 - 20.0, left: 12.0, right: 12.0),
//            child: Align(
//              alignment: Alignment.bottomCenter,
//              child: AlertWidget(
//                  (_selectedSumInsured == -1)
//                      ? S.of(context).select_sum_insured_error
//                      : S.of(context).select_premium_error,
//                  isAlertVisible ? 168 : 0),
//            ),
//          ),
          //Align(alignment: Alignment.bottomCenter, child: _showButton()),
        ],
      )),
    );
  }

  Widget _buildPremiumListItem(TimePeriod premiumModel, int index) {
    bool isSelected = (_selectedPremium == index);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isAlertVisible) {
              isAlertVisible = false;
            }
            _selectedPremium = index;
          });
          onClick();
        },
        child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius(topLeft: 30.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius(topLeft: 30.0),
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                            ColorConstants.policy_type_gradient_color1,
                            ColorConstants.policy_type_gradient_color2
                          ])
                    : null,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 2 - 20,
                      child: Text(
                        '${CommonUtil.instance.getCurrencyFormat().format(premiumModel.premium)}',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: isSelected ? 1 : 0.2,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0)),
                                  color: isSelected
                                      ? Colors.white
                                      : ColorConstants
                                          .premium_opd_amount_card_color),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(left:4.0),
                                child: Text(
                                  //'${S.of(context).opd_benefits_title}',
                                  '${' OPD: '+CommonUtil.instance.getCurrencyFormat().format(premiumModel.opd)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          ColorConstants.opd_amount_text_color),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  updatePremiumAndOpdData(int index) async {
    if (index == -1) {
      return;
    }
    if (null == sumInsuredList[index].timePeriodList) {
      CalculatePremiumReqModel calculatePremiumReqModel;
      if (sumInsuredList[index].calculatePremiumReqModel == null) {
        calculatePremiumReqModel = _selectedMemberDetails.calculatePremiumReqModel;
      /*  if (_selectedMemberDetails.policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL) {
          // Sum Insured has to be calculated based on total policy members
          calculatePremiumReqModel.sumInsured = (sumInsuredList[index].amount) * (calculatePremiumReqModel.childCount + calculatePremiumReqModel.adultCount);
        } else {
          // Sum Insured is same for Individual and Family Floater
          calculatePremiumReqModel.sumInsured = sumInsuredList[index].amount;
        }*/

        //Archanna (24-01-2020) -- Sum insured for Individual , Family floater and Family Individual are same
        // (no need to multiply with No.of.Members with sum insured, it will handled at backend )
        calculatePremiumReqModel.sumInsured = sumInsuredList[index].amount;
        sumInsuredList[index].calculatePremiumReqModel = calculatePremiumReqModel;
      } else {
        calculatePremiumReqModel =
            sumInsuredList[index].calculatePremiumReqModel;
      }

      apiCallIndex = index;
      showLoaderDialog(context);
      var response = await _bloc.calculatePremium(calculatePremiumReqModel, widget.arguments.policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL);
      if (response != null) {
        hideLoaderDialog(context);
        sumInsuredList[index].calculatedPremiumResModel = response;
        Opd opd = response.opd;
        if (opd != null) {
          sumInsuredList[index].timePeriodList = opd.year1;
          premiumList = opd.year1;
        }
      } else {
        return;
      }
    } else {
      premiumList = sumInsuredList[index].timePeriodList;
    }
    setState(() {
      if (isAlertVisible) {
        isAlertVisible = false;
      }
      _selectedSumInsured = index;
    });
  }

  _buildSumInsuredList() {
    double screenWidth =
        this.screenWidth - 20 - ((sumInsuredList.length - 1) * 15);
    double cardWidth = screenWidth / sumInsuredList.length;
    return Container(
      height: 70,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: sumInsuredList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  updatePremiumAndOpdData(index);
                },
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        borderRadius(radius: 5.0, topRight: 5.0, topLeft: 5.0),
                  ),
                  child: Container(
                    width: cardWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: (_selectedSumInsured == index)
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                  ColorConstants.policy_type_gradient_color1,
                                  ColorConstants.policy_type_gradient_color2
                                ])
                          : null,
                    ),
                    child: Center(
                        child: Text(
                      sumInsuredList[index].amountString,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: (_selectedSumInsured == index)
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                ),
              ),
            );
          }),
    );
  }

  onClick() {
    setState(() {
      if (_selectedSumInsured == -1 || _selectedPremium == -1) {
        isAlertVisible = true;
      } else {
        _selectedMemberDetails.selectedYearAndPremium =
            premiumList[_selectedPremium];
        _selectedMemberDetails.selectedSumInsured =
            sumInsuredList[_selectedSumInsured];
        Navigator.of(context).pushNamed(TimePeriodScreen.ROUTE_NAME,
            arguments: _selectedMemberDetails);
      }
    });
  }

  Widget _showButton() {
    return BlackButtonWidget(
        onClick, S.of(context).get_a_quote_title.toUpperCase());
  }

  _listenForEvents() {
    _bloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0,(int retryIdentifier) {
        updatePremiumAndOpdData(apiCallIndex);
      }, event.dialogType);
     /* switch (event.dialogType) {
        case DialogEvent.DIALOG_TYPE_NETWORK_ERROR:
          showNoInternetDialog(
            context,
            0,
            (int retryIdentifier) {
              updatePremiumAndOpdData(apiCallIndex);
            },
          );
          break;
        case DialogEvent.DIALOG_TYPE_OH_SNAP:
          showServerErrorDialog(context, 0, (int retryIdentifier) {
            updatePremiumAndOpdData(apiCallIndex);
          });
          break;
      }*/
    });
  }
}
