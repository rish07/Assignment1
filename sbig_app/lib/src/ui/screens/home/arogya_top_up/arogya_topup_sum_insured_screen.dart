import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_top_up/premium_details/arogya_top_up_premium_bloc.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/member_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_sum_insured.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_time_period.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dotted_line_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/triangle_widget.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/sum_insured_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ArogyaTopUpSumInsuredScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_top_up/sum_insured_screen";

  final ArogyaSumInsuredArguments sumInsuredArguments;

  ArogyaTopUpSumInsuredScreen(this.sumInsuredArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: ArogyaTopUpPremiumBloc(),
      child: ArogyaSumInsuredScreenWidget(sumInsuredArguments),
    );
  }
}

class ArogyaSumInsuredScreenWidget extends StatefulWidget {
  final ArogyaSumInsuredArguments sumInsuredArguments;

  @override
  _ArogyaSumInsuredScreenWidgetState createState() =>
      _ArogyaSumInsuredScreenWidgetState();

  ArogyaSumInsuredScreenWidget(this.sumInsuredArguments);
}

class _ArogyaSumInsuredScreenWidgetState
    extends State<ArogyaSumInsuredScreenWidget> with CommonWidget {
  ArogyaTopUpPremiumBloc _arogyaTopUpPremiumBloc;
  PolicyType policyType;

  double screenWidth;
  double screenHeight;
  List<SumInsuredResModel> sumInsureResModel;
  ArogyaTopUpSumInsuredResModel sumInsuredResModel;
  List<PolicyCoverMemberModel> memberList;
  ArogyaTopUpModel arogyaTopUpModel;
  List<ArogyaSumInsuredModel> sumInsuredList = [];
  List<ArogyaSumInsuredModel> recommendedSumInsuredList = [];
  List<String> sumInsuredStringList = [];
  int _selectedIndex = -1;
  int selectedSumInsured = 0;
  String selectedDeduction = '0';
  bool showRecommended = false;
  List<DeductionList> deductionList=[];
  bool isSumInsuredClicked=false;
  bool isDeductionClicked =false;
  bool visibleNextButton=true;
  bool visibleInstruction=false ;

  int _selectedSumInsuredIndex = -1;
  int _selectedDeductionIndex = -1;

  @override
  void initState() {
    _arogyaTopUpPremiumBloc =
        SbiBlocProvider.of<ArogyaTopUpPremiumBloc>(context);
    policyType = widget.sumInsuredArguments.arogyaTopUpModel.policyType;
    arogyaTopUpModel = widget.sumInsuredArguments.arogyaTopUpModel;
    memberList = widget.sumInsuredArguments.arogyaTopUpModel.policyMembers;
    sumInsuredResModel = widget.sumInsuredArguments.arogyaTopUpModel.arogyaTopUpSumInsuredResModel;
    showRecommended = true;
    _createSumInsuredModel(sumInsuredResModel);
    _listenForEvents();
    super.initState();
  }

  _listenForEvents() {
    _arogyaTopUpPremiumBloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0, (int retryIdentifier) {
        _makeApiCall(policyType);
      }, event.dialogType);
    });
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil.getInstance(context).screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.critical_illness_bg_color,
      appBar: getAppBar(context, S.of(context).coverage_amount.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Text(
                    S.of(context).sum_insured_amount_title,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: StringConstants.EFFRA_LIGHT,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    S.of(context).sum_insured_instruction,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      color: ColorConstants.critical_illness_light_gray,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if(!showRecommended&&_selectedSumInsuredIndex<0)
                      Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0,top:10.0,bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(5.0),
                              color:ColorConstants.sum_insured_container_color,
                            ),
                            child:Text('Please Select Sum Insured',style: TextStyle(color: ColorConstants.sum_insured_text_color,fontSize: 11.0,fontStyle: FontStyle.normal),),

                          ),
                          /*Align(
                            child: Triangle(
                              color: ColorConstants.sum_insured_container_color,
                            ),
                            alignment: Alignment(1,-5),
                          ),*/
                        ],
                      ),
                      if(!showRecommended&&_selectedSumInsuredIndex>=0)
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0,top:10.0,bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius:  BorderRadius.circular(5.0),
                                color:ColorConstants.sum_insured_container_color,
                              ),
                              child:Center(child:
                              RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: '${S.of(context).sum_insured_title} : ',
                                          style: TextStyle(color: Colors.black,fontSize: 12.0,fontStyle: FontStyle.normal),
                                        ),   TextSpan(
                                          text: CommonUtil.instance.convertSumInsuredWithRupeeSymbol(sumInsuredList[_selectedSumInsuredIndex].amount),
                                          style: TextStyle(color: Colors.black,fontSize: 12.0,fontWeight: FontWeight.w700),
                                        ),
                                      ]),
                                  ),
                              ))),
                      SizedBox(
                        width: 3.0,
                      ),
                      if(!showRecommended && _selectedSumInsuredIndex>=0&&_selectedDeductionIndex<0)
                      Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0,top:10.0,bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.circular(5.0),
                              color:ColorConstants.sum_insured_container_color,
                            ),
                            child: Center(child: Text(S.of(context).deductible +": ",style: TextStyle(color: ColorConstants.sum_insured_text_color,fontSize: 12.0,fontStyle: FontStyle.normal),)),
                          )),
                      if(!showRecommended && _selectedSumInsuredIndex>=0&&_selectedDeductionIndex>=0)
                        Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0,top:10.0,bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius:  BorderRadius.circular(5.0),
                                color:ColorConstants.sum_insured_container_color,
                              ),
                              child: Center(
                                child:
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                      text: S.of(context).deductible +" : ",
                                      style: TextStyle(color: Colors.black,fontSize: 13.0,fontStyle: FontStyle.normal),
                                    ),   TextSpan(
                                      text: CommonUtil.instance.convertSumInsuredWithRupeeSymbol(sumInsuredList[_selectedSumInsuredIndex].deductionList[_selectedDeductionIndex].deduction),
                                      style: TextStyle(color: Colors.black,fontSize: 13.0,fontWeight: FontWeight.w700),
                                    ),
                                  ]),
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
                SizedBox(height: 3.0,),
                Expanded(child: _sumInsuredContainer()),
                Container(
                  height: 80.0,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment(-0.6, 0),
                      child: DottedLineWidget(
                        height: 5.0,
                        width: 0.5,
                        color: Colors.grey,
                        axis: Axis.vertical,
                        dashCountValue: 10,
                      )),
                ),
              ],
            ),
            Visibility(
                visible: visibleInstruction,
                child: dedcutionInstruction()),
            Visibility(
                visible: visibleNextButton,
                child: showNextButton()),
          ],
        ),
      ),
    );
  }


  Widget dedcutionInstruction()
  {
    return Align(
      alignment: Alignment(0, 0.9),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
        child: Container(

          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Text('Please choose new value for deductable as it changes with very sum insured value. ',
                    style: TextStyle(color: Colors.white,fontSize: 12.0,fontStyle: FontStyle.normal),),
                ),
                SizedBox(width: 10.0,),
                InkWell(
                  onTap: (){
                    setState(() {
                      visibleNextButton=true;
                      visibleInstruction=false;
                    });
                  },
                  child: Container(
                    height: 30.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                    ),
                    child: Center(child: Text('  OK  ',style: TextStyle(color: Colors.blueAccent,letterSpacing: 0.5,fontSize: 10.0),)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sumInsuredContainer() {
    return Stack(
      children: <Widget>[
        Container(
          ///1.873 is the height factor calculated for IPad, 50 is the overlay padding, 15 the padding of page indicators
          margin: EdgeInsets.only(
              top: isIPad(context)
                  ? ScreenUtil.getInstance(context).screenWidthDp / 1.873 -
                      50 +
                      15
                  : 10.0),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
              color: Colors.white),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment(-0.6, 0),
                  child: DottedLineWidget(
                    height: 5.0,
                    width: 0.5,
                    color: Colors.grey,
                    axis: Axis.vertical,
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                child: (showRecommended)
                    ? ListView.builder(
                        itemCount: recommendedSumInsuredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildSumInsured(
                              recommendedSumInsuredList[index], index);
                        })
                    : Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                                itemCount: sumInsuredList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildMoreSumInsured(
                                      sumInsuredList[index], index);
                                }),
                          ),
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: deductionList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildDeduction(
                                      deductionList[index], index);
                                }),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }

  onUpdate(int index) {
    if (showRecommended) {
      setState(() {
        _selectedIndex = index;
        if (recommendedSumInsuredList != null) {
          if (recommendedSumInsuredList[index].amount == -1) {
            if(sumInsuredList.length>0){
              deductionList=sumInsuredList[0].deductionList;
              sumInsuredList.forEach((s) => s.isSelected = false);
            }
            showRecommended = false;
            selectedDeduction='0';
            return;
          }
          recommendedSumInsuredList.forEach((s) => s.isSelected = false);
          recommendedSumInsuredList[index].isSelected = true;
          selectedSumInsured = recommendedSumInsuredList[index].amount;
          selectedDeduction= recommendedSumInsuredList[index].deduction;
        }
      });
    } else {
      setState(() {
        _selectedIndex = index;
        if (sumInsuredList != null) {
          sumInsuredList.forEach((s) => s.isSelected = false);
          sumInsuredList[index].isSelected = true;
          selectedSumInsured = sumInsuredList[index].amount;
        }
      });
    }
  }

  Widget showNextButton() {
    return EnableDisableButtonWidget(
      (_selectedIndex != -1 && selectedSumInsured > 0 && selectedDeduction != '0')
          ? () {
              _makeApiCall(policyType);
            }
          : null,
      S.of(context).next.toUpperCase(),
      bottomBgColor: Colors.white,
    );
  }

  void _createSumInsuredModel(ArogyaTopUpSumInsuredResModel sumInsuredResModel) {
    var data = sumInsuredResModel?.data ?? [];
    ArogyaSumInsuredModel arogyaSumInsuredModel;
    for (var i = 0; i < data.length; i++) {
      arogyaSumInsuredModel = ArogyaSumInsuredModel();
      arogyaSumInsuredModel.amount = int.parse(data[i].suminsured) ?? 0;
      arogyaSumInsuredModel.amountString = CommonUtil.instance.convertSumInsured(data[i].suminsured);
      arogyaSumInsuredModel.deductionList=data[i].deductionList;
      sumInsuredList.add(arogyaSumInsuredModel);
      if(data[i].suminsured == '300000' || data[i].suminsured == '500000'){
        List<DeductionList> list= data[i].deductionList;
        for(var j=0;j<data[i].deductionList.length;j++){
          if(data[i].deductionList[j].deduction=='300000'){
            arogyaSumInsuredModel.premium = data[i].deductionList[j].premium;
            arogyaSumInsuredModel.deduction=data[i].deductionList[j].deduction;
            arogyaSumInsuredModel.isRecommended = true;
            recommendedSumInsuredList.add(arogyaSumInsuredModel);
          }
        }
      }else if(data[i].suminsured == '700000'){
        List<DeductionList> list= data[i].deductionList;
        for(var j=0;j<data[i].deductionList.length;j++){
          if(data[i].deductionList[j].deduction=='500000'){
            arogyaSumInsuredModel.premium = data[i].deductionList[j].premium;
            arogyaSumInsuredModel.deduction=data[i].deductionList[j].deduction;
            arogyaSumInsuredModel.isRecommended = true;
            recommendedSumInsuredList.add(arogyaSumInsuredModel);
          }
        }
      }

    }
    sumInsuredList.sort((a,b)=> a.amount.compareTo(b.amount));
    if (recommendedSumInsuredList != null) {
    recommendedSumInsuredList..sort((a, b) => a.amount.compareTo(b.amount));
    recommendedSumInsuredList.add(ArogyaSumInsuredModel(amount: -1, premium: '-1', amountString: 'more'));
    }
  }

  _makeApiCall(PolicyType policyType) async {
    List<PolicyCoverMemberModel> policyCoverMemberList =
        arogyaTopUpModel.policyMembers;
    List<Members> membersList = [];
    if(showRecommended){
      if (policyCoverMemberList != null) {
        for (var i = 0; i < policyCoverMemberList.length; i++) {
          membersList.add(Members(
              age: policyCoverMemberList[i].memberDetailsModel.ageGenderModel.age,
              sumInsured: selectedSumInsured,
              deduction: selectedDeduction));
        }
    }
    }else{
      if (policyCoverMemberList != null) {
        for (var i = 0; i < policyCoverMemberList.length; i++) {
          membersList.add(Members(
              age: policyCoverMemberList[i].memberDetailsModel.ageGenderModel.age,
              sumInsured: selectedSumInsured,
              deduction: selectedDeduction));
        }
      }

    }
    ArogyaTopUpPremiumReqModel arogyaTopUpPremiumReqModel = ArogyaTopUpPremiumReqModel();
    arogyaTopUpPremiumReqModel.members = membersList;
    arogyaTopUpPremiumReqModel.memberCount = policyCoverMemberList.length ?? 0;

    showLoaderDialog(context);
    final response = await _arogyaTopUpPremiumBloc.calculatePremium(
        arogyaTopUpPremiumReqModel,
        (policyType.id == PolicyTypeScreen.INDIVIDUAL) ? false : true);
    hideLoaderDialog(context);
    if (response != null) {
      if (showRecommended) {
        ArogyaSumInsuredModel selectedSumInsuredModel =
            recommendedSumInsuredList[_selectedIndex];
        selectedSumInsuredModel.arogyaTopUpPremiumReqModel =
            arogyaTopUpPremiumReqModel;
        selectedSumInsuredModel.arogyaTopUpPremiumResModel = response;
        selectedSumInsuredModel.timePeriod = response?.data ?? null;
        selectedSumInsuredModel.deduction=recommendedSumInsuredList[_selectedIndex].deduction;
        selectedSumInsuredModel.premium=recommendedSumInsuredList[_selectedIndex].premium;
        arogyaTopUpModel.selectedSumInsured = selectedSumInsuredModel;
      } else {
        ArogyaSumInsuredModel selectedSumInsuredModel =
            sumInsuredList[_selectedSumInsuredIndex];
        selectedSumInsuredModel.arogyaTopUpPremiumReqModel =
            arogyaTopUpPremiumReqModel;
        selectedSumInsuredModel.arogyaTopUpPremiumResModel = response;
        selectedSumInsuredModel.timePeriod = response?.data ?? null;
        selectedSumInsuredModel.deduction=selectedDeduction;
        selectedSumInsuredModel.premium= sumInsuredList[_selectedSumInsuredIndex].deductionList[_selectedDeductionIndex].premium;
        arogyaTopUpModel.selectedSumInsured = selectedSumInsuredModel;
      }

      Navigator.of(context).pushNamed(ArogyaTopUpTimePeriodScreen.ROUTE_NAME,
          arguments: arogyaTopUpModel);
    }
  }

  Widget buildSumInsured(ArogyaSumInsuredModel sumInsuredList, int index) {
    var amtStr;
    String value = '';
    String deduction = '0';
    try {
      amtStr = sumInsuredList.amountString.split(' ');
      value = amtStr[0] + '\n' + amtStr[1];
      deduction = CommonUtil.instance
          .convertSumInsuredWithRupeeSymbol(sumInsuredList.deduction);
    } catch (e) {
      value = sumInsuredList.amountString;
    }

    return InkResponse(
      onTap: () {
        onUpdate(index);
      },
      child: SumInsuredWidget(index,
          sumInsured: value,
          isSelected: sumInsuredList.isSelected,
          isFrom: StringConstants.FROM_AROGYA_TOP_UP,
          premium: deduction ?? '0'),
    );
  }

  Widget buildMoreSumInsured(ArogyaSumInsuredModel sumInsuredList, int index) {
    var amtStr;
    String value = '';
    try {
      amtStr = sumInsuredList.amountString.split(' ');
      value = amtStr[0] + '\n' + amtStr[1];
    } catch (e) {
      value = sumInsuredList.amountString;
    }

    return InkWell(
      onTap: () {
        updateDeduction(index);
      },
      child: Column(
      children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 95.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: (sumInsuredList.isSelected)
                        ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.policy_type_gradient_color2,
                          ColorConstants.policy_type_gradient_color1
                        ])
                        : null),
              ),
              Center(
                child: Container(
                  height: 90.0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child:  Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Container(
                          width: 70,
                          height:70,
                          decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                    offset: Offset(1, 5),
                                    spreadRadius: 1)
                              ]),
                          child: Center(
                              child: Container(
                                  child: Text(
                                    value,
                                    style: (false)
                                        ? TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700)
                                        : TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.0,
                                        fontStyle: FontStyle.normal),
                                    textAlign: TextAlign.center,
                                  ))),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }

  Widget buildDeduction(DeductionList deductionList, int index) {
    String deduction = '0';
    try {
      deduction = CommonUtil.instance
          .convertSumInsuredWithRupeeSymbol(deductionList.deduction);
    } catch (e) {}

    return InkWell(
      onTap: (){
        if(_selectedSumInsuredIndex>=0){
          update(index);
        }
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: 95.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      gradient: (deductionList.isSelected)
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                  ColorConstants.policy_type_gradient_color2,
                                  ColorConstants.policy_type_gradient_color1
                                ])
                          : null),
                ),
                Container(
                  height: 90.0,
                  width: double.maxFinite ,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 70.0,
                              margin: EdgeInsets.only(left: 15.0, right: 15.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 5.0,
                                        offset: Offset(1, 5),
                                        spreadRadius: 1)
                                  ]),
                              child: Container(
                                  child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: S.of(context).deductible + '  -  ',
                                        style: (_selectedSumInsuredIndex>=0)
                                            ? TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontStyle: FontStyle.normal)
                                            : TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade300,
                                                fontStyle: FontStyle.normal)),
                                    //TextSpan(text: CommonUtil.instance.getCurrencyFormat().format(premium), style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700))
                                    TextSpan(
                                        text: deduction,
                                        style: (_selectedSumInsuredIndex>=0)
                                            ? TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey.shade900,
                                                fontWeight: FontWeight.w500)
                                            : TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey.shade300,
                                                fontWeight: FontWeight.w400))
                                  ]),
                                ),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }

  void updateDeduction(int index) {
    setState(() {
      if(_selectedSumInsuredIndex!=-1 && _selectedSumInsuredIndex != index){
        visibleNextButton=false;
        visibleInstruction=true;
      }
      _selectedSumInsuredIndex = index;
      _selectedDeductionIndex=-1;
      deductionList = sumInsuredList[index].deductionList;
      if (sumInsuredList != null) {
        sumInsuredList.forEach((s) => s.isSelected = false);
        sumInsuredList[index].isSelected = true;
        selectedSumInsured = sumInsuredList[index].amount;
        selectedDeduction='0';
      }
    });
  }

  void update(int index) {
    setState(() {
      _selectedDeductionIndex=index;
      if (sumInsuredList != null) {
        sumInsuredList.forEach((s) => s.deductionList.forEach((d)=>d.isSelected=false));
        sumInsuredList[_selectedSumInsuredIndex].deductionList[index].isSelected=true;
        selectedDeduction= sumInsuredList[_selectedSumInsuredIndex].deductionList[index].deduction;
      }
    });
  }
}

class ArogyaSumInsuredArguments {
  final ArogyaTopUpModel arogyaTopUpModel;

  ArogyaSumInsuredArguments(this.arogyaTopUpModel);
}

