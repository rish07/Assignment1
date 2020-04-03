

import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/widgets/home/services_tab/custom_service_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ServicesTab extends StatefulWidgetBase {
  @override
  _ServicesTabState createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {

  ServiceModel networkHospitalServiceModel, claimIntimationServiceModel;

  @override
  void didChangeDependencies() {
    networkHospitalServiceModel = ServiceModel(
        title: S.of(context).network_hospitals_title,
        subTitle: "",
        isSubTitleRequired: false,
        points: [
          S.of(context).network_hospitals_point1,
          S.of(context).network_hospitals_point2,
          //S.of(context).network_hospitals_point3
        ],
        icon: AssetConstants.ic_network_hptl, color1: ColorConstants.network_hospital_gradient_color1, color2: ColorConstants.network_hospital_gradient_color2);

    claimIntimationServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_title,
        subTitle: S.of(context).claim_intimation_subtitle,
        isSubTitleRequired: true,
        points: [
          S.of(context).claim_intimation_point1,
          S.of(context).claim_intimation_point2,
          S.of(context).claim_intimation_point3
        ],
        icon: AssetConstants.ic_note2, color1: ColorConstants.claim_intimation_gradient_color1, color2: ColorConstants.claim_intimation_gradient_color2);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container( // Network Hospital
            margin: EdgeInsets.only(left: 12, right: 12),
            child: CustomServiceWidget(networkHospitalServiceModel, S.of(context).checkout_title.toUpperCase(),OnClickId.NETWORK_HOSPITAL),),
        Container( // Claim Intimation
            margin: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 12),
            child: CustomServiceWidget(claimIntimationServiceModel, S.of(context).checkout_title.toUpperCase(),OnClickId.CLAIM, 300)),
        //SizedBox(height: 54,)
      ],
    );
  }
}

