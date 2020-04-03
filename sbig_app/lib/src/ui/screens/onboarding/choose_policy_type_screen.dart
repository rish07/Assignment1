import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_type_list_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_types_model.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ChoosePolicyTypeScreen extends StatefulWidget {

  SingupSigninArguments singupSigninArguments;

  ChoosePolicyTypeScreen(this.singupSigninArguments);

  @override
  _ChoosePolicyTypeScreenState createState() => _ChoosePolicyTypeScreenState();
}

class _ChoosePolicyTypeScreenState extends State<ChoosePolicyTypeScreen> with CommonWidget{

  List<PolicyTypesListModel> _policyTypeList;
  int selectedIndex = -1;

  @override
  void initState() {
    _policyTypeList = List<PolicyTypesListModel>();
    List<PolicyTypeBody> policyTypes = widget.singupSigninArguments.policyTypesResModel.data.body;
    int i = 0;
    for(PolicyTypeBody p in policyTypes){
      PolicyTypesListModel policyTypesListModel = PolicyTypesListModel(
        title: p.title,
        icon: UrlConstants.URL +p.imagePath1,
        activeIcon: UrlConstants.URL + p.imagePath2,
        productCode: p.jsonCondition.productCode,
        policyType: p.jsonCondition.policyType,
        policyTypeName: p.jsonCondition.policyTypeName,
        navigateId: p.jsonCondition.navigateId
      );
      if(widget.singupSigninArguments.selectedPolicyType != null){
        if (widget.singupSigninArguments.selectedPolicyType.productCode.compareTo(policyTypesListModel.productCode) == 0){
          selectedIndex = i;
        }
      }
      _policyTypeList.add(policyTypesListModel);
      i++;
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(left: 3.0, top: 15.0, bottom: 5.0),
                child: Text(
                  S.of(context).policy_type_title.toUpperCase(),
                  style: TextStyle(
                      fontFamily: StringConstants.EFFRA_LIGHT,
                      fontSize: 12.0,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500),
                ),
              ),

              GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(_policyTypeList.length, (index) {
                  return buildListItem(_policyTypeList[index], index);
                }),
              ),
              SizedBox(height: 80,)
            ],

          ),
        ),
      ],
    );
  }

  Widget buildListItem(PolicyTypesListModel policyTypeItem, int index) {

    bool isSelected = (index == selectedIndex);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap: () {
          setState(() {
            widget.singupSigninArguments.onChoosePolicyType(policyTypeItem);
            selectedIndex = index;
          });
        },
        child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius(topRight: 40.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius(topRight: 40.0),
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
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: isSelected
                            ? Image(image: NetworkImage(policyTypeItem.activeIcon), fit: BoxFit.scaleDown,)
                            : Image(image: NetworkImage(policyTypeItem.icon), fit: BoxFit.scaleDown)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      policyTypeItem.title,
                      style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : policyTypeItem.titleColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
