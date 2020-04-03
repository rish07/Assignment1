import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_premier/premium_details/arogya_premier_premium_bloc.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/member_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_premium_model.dart';

import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_time_period_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dotted_line_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/sum_insured_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ArogyaPremierSumInsuredScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_premier/sum_insured_screen";

  final ArogyaSumInsuredArguments sumInsuredArguments;

  ArogyaPremierSumInsuredScreen(this.sumInsuredArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: ArogyaPremierPremiumBloc(),
      child: ArogyaPremierSumInsuredScreenWidget(sumInsuredArguments),
    );
  }
}

class ArogyaPremierSumInsuredScreenWidget extends StatefulWidget {
  final ArogyaSumInsuredArguments sumInsuredArguments;

  @override
  _ArogyaPremierSumInsuredScreenWidgetState createState() =>
      _ArogyaPremierSumInsuredScreenWidgetState();

  ArogyaPremierSumInsuredScreenWidget(this.sumInsuredArguments);
}

class _ArogyaPremierSumInsuredScreenWidgetState
    extends State<ArogyaPremierSumInsuredScreenWidget> with CommonWidget {
  ArogyaPremierPremiumBloc _arogyaPremierPremiumBloc;
  PolicyType policyType;

  double screenWidth;
  double screenHeight;
  List<SumInsuredResModel> sumInsureResModel;
  SumInsuredResModel sumInsuredResModel;
  List<PolicyCoverMemberModel> memberList;
  ArogyaPremierModel _arogyaPremierModel;
  List<ArogyaSumInsuredModel> sumInsuredList = [];
  List<ArogyaSumInsuredModel> recommendedSumInsuredList = [];
  int _selectedIndex=-1;
  int selectedSumInsured =-1;
  bool showRecommended =false;


  @override
  void initState() {
    _arogyaPremierPremiumBloc = SbiBlocProvider.of<ArogyaPremierPremiumBloc>(context);
    policyType = widget.sumInsuredArguments.arogyaPremierModel.policyType;
    _arogyaPremierModel = widget.sumInsuredArguments.arogyaPremierModel;
    memberList = widget.sumInsuredArguments.arogyaPremierModel.policyMembers;
    sumInsuredResModel = widget.sumInsuredArguments.arogyaPremierModel.sumInsuredResModel;
    showRecommended =true;
    _createSumInsuredModel(sumInsuredResModel);
    _listenForEvents();
    super.initState();
  }

  _listenForEvents() {
    _arogyaPremierPremiumBloc.eventStream.listen((event) {
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
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0),
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
                Expanded(child: _sumInsuredContainer()),
                Container(height: 80.0,color: Colors.white,
                  child:  Align(
                      alignment: Alignment(-0.6, 0),
                      child: DottedLineWidget(height: 5.0,width:0.5,color: Colors.grey,axis: Axis.vertical,dashCountValue: 10,)),),
              ],
            ),
            showNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _sumInsuredContainer() {
    return Stack(
      children: <Widget>[
        Container(///1.873 is the height factor calculated for IPad, 50 is the overlay padding, 15 the padding of page indicators
          margin: EdgeInsets.only(
              top: isIPad(context)
                  ? ScreenUtil.getInstance(context).screenWidthDp / 1.873 - 50 + 15
                  : 10.0),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
              color: Colors.white),
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment(-0.6, 0),
                  child: DottedLineWidget(height: 5.0,width:0.5,color: Colors.grey,axis: Axis.vertical,)),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                child:(showRecommended)?
                ListView.builder(
                    itemCount: recommendedSumInsuredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildSumInsured(recommendedSumInsuredList[index],index);
                    }):
                ListView.builder(
                    itemCount: sumInsuredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildSumInsured(sumInsuredList[index],index);
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }

  onUpdate(int index) {
    if(showRecommended){
      setState(() {
        _selectedIndex=index;
        if(recommendedSumInsuredList !=null){
          if(recommendedSumInsuredList[index].amount == -1){
            if(selectedSumInsured >0){
              for(var i=0;i<sumInsuredList.length;i++){
                if(sumInsuredList[i].isSelected){
                  _selectedIndex=i;
                }
              }
            }
            showRecommended=false;
            return;
          }
          recommendedSumInsuredList.forEach((s)=>s.isSelected=false);
          recommendedSumInsuredList[index].isSelected=true;
          selectedSumInsured=recommendedSumInsuredList[index].amount;
          print('RECOMMENDED selectedSumInsured $selectedSumInsured _selectedIndex $_selectedIndex');
        }
      });

    }else{
      setState(() {
        _selectedIndex=index;
        if(sumInsuredList !=null){
          sumInsuredList.forEach((s)=>s.isSelected=false);
          sumInsuredList[index].isSelected=true;
          selectedSumInsured=sumInsuredList[index].amount;
          print('ACTUAL selectedSumInsured $selectedSumInsured _selectedIndex $_selectedIndex');
        }
      });

    }

  }

  Widget showNextButton() {
    return EnableDisableButtonWidget(
      (_selectedIndex != -1  && selectedSumInsured >0)?() {
        _makeApiCall(policyType);
      }:null,
      S.of(context).next.toUpperCase(),
      bottomBgColor: Colors.white,
    );
  }

  void _createSumInsuredModel(SumInsuredResModel sumInsuredResModel) {
    var data = sumInsuredResModel?.data ?? [];
    ArogyaSumInsuredModel arogyaSumInsuredModel;
    for (var i = 0; i < data.length; i++) {
      arogyaSumInsuredModel = ArogyaSumInsuredModel();
      arogyaSumInsuredModel.amount = int.parse(data[i].suminsured) ?? 0;
      arogyaSumInsuredModel.premium = data[i].premium;
      arogyaSumInsuredModel.amountString = CommonUtil.instance.convertSumInsured(data[i].suminsured);
      if (data[i].suminsured == '1000000' ||
          data[i].suminsured == '1500000' ||
          data[i].suminsured == '2000000') {
        arogyaSumInsuredModel.isRecommended = true;
        recommendedSumInsuredList.add(arogyaSumInsuredModel);
      }
      sumInsuredList.add(arogyaSumInsuredModel);
    }
    if(recommendedSumInsuredList!=null){
      recommendedSumInsuredList..sort((a, b) => a.amount.compareTo(b.amount));
      recommendedSumInsuredList.add(ArogyaSumInsuredModel(amount: -1 ,premium: '-1',amountString: 'more'));
    }

    for(var k=0;k<recommendedSumInsuredList.length;k++){
      if(recommendedSumInsuredList[k].amount.toString() == '2000000'){
        recommendedSumInsuredList[k].isSelected=true;
        selectedSumInsured=recommendedSumInsuredList[k].amount;
        _selectedIndex=k;
        break;
      }
    }
    if (sumInsuredList != null) {
      sumInsuredList.sort((a, b) => a.amount.compareTo(b.amount));
    }
  }

  _makeApiCall(PolicyType policyType) async {
    List<PolicyCoverMemberModel> policyCoverMemberList = _arogyaPremierModel.policyMembers;
    List<Members> membersList = [];
    if (policyCoverMemberList != null) {
      for (var i = 0; i < policyCoverMemberList.length; i++) {
        membersList.add(Members(
            age: policyCoverMemberList[i].memberDetailsModel.ageGenderModel.age,
            sumInsured: selectedSumInsured));
      }
    }
    ArogyaPremierPremiumReqModel arogyaPremierPremiumReqModel = ArogyaPremierPremiumReqModel();
    arogyaPremierPremiumReqModel.members = membersList;
    arogyaPremierPremiumReqModel.memberCount = policyCoverMemberList.length ?? 0;

    showLoaderDialog(context);
    final response = await _arogyaPremierPremiumBloc.calculatePremium(arogyaPremierPremiumReqModel, (policyType.id == PolicyTypeScreen.INDIVIDUAL || policyType.id == PolicyTypeScreen.FAMILY_FLOATER) ? false : true);
    hideLoaderDialog(context);
    if (response != null) {
      if(showRecommended){
        ArogyaSumInsuredModel selectedSumInsuredModel = recommendedSumInsuredList[_selectedIndex];
        selectedSumInsuredModel.arogyaPremierPremiumReqModel = arogyaPremierPremiumReqModel;
        selectedSumInsuredModel.arogyaPremierPremiumResModel = response;
        selectedSumInsuredModel.timePeriod = response?.data ?? null;
        _arogyaPremierModel.selectedSumInsured = selectedSumInsuredModel;
      }else{
        ArogyaSumInsuredModel selectedSumInsuredModel = sumInsuredList[_selectedIndex];
        selectedSumInsuredModel.arogyaPremierPremiumReqModel = arogyaPremierPremiumReqModel;
        selectedSumInsuredModel.arogyaPremierPremiumResModel = response;
        selectedSumInsuredModel.timePeriod = response?.data ?? null;
        _arogyaPremierModel.selectedSumInsured = selectedSumInsuredModel;
      }

      Navigator.of(context).pushNamed(ArogyaTimePeriodScreen.ROUTE_NAME,
          arguments: _arogyaPremierModel);
    }
  }

  Widget buildSumInsured(ArogyaSumInsuredModel sumInsuredList, int index) {
    var amtStr ;
    String value='';
  try{
    amtStr =sumInsuredList.amountString.split(' ');
    value =amtStr[0] + '\n'+amtStr[1];
  }catch(e){
    value=sumInsuredList.amountString;
  }

    return InkResponse(
      onTap: (){
        onUpdate(index);
      },
      child: SumInsuredWidget(
        index,
        sumInsured: value,
        isSelected: sumInsuredList.isSelected,
        premium:CommonUtil.instance
            .getCurrencyFormat()
            .format(int.parse(sumInsuredList?.premium??'0')),
      ),
    );
  }
}

class ArogyaSumInsuredArguments {
  final ArogyaPremierModel arogyaPremierModel;

  ArogyaSumInsuredArguments(this.arogyaPremierModel);
}
