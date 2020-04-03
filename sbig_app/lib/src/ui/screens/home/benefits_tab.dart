import 'package:flutter/services.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_disclaimer_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/services_tab/custom_service_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class BenefitsTab extends StatefulWidgetBase {
  @override
  _BenefitsTabState createState() => _BenefitsTabState();
}

class _BenefitsTabState extends State<BenefitsTab> with CommonWidget {
  ServiceModel bookDoctorBenefitModel, fitternityBenefitModel;
  List<GeneralListModel> comingSoonListModel;

  @override
  void didChangeDependencies() {
    bookDoctorBenefitModel = ServiceModel(
        title: S.of(context).book_doctor_online_title2,
        subTitle: S.of(context).book_doctor_description,
        isSubTitleRequired: true,
        points: [
          S.of(context).book_doctor_point1,
          S.of(context).book_doctor_point2,
          S.of(context).book_doctor_point3
        ],
        icon: AssetConstants.ic_book_doctor,
        color1: ColorConstants.claim_intimation_gradient_color1,
        color2: ColorConstants.claim_intimation_gradient_color2);

    fitternityBenefitModel = ServiceModel(
        title: S.of(context).fitternity_title,
        subTitle: S.of(context).fitternity_subtitle,
        isSubTitleRequired: true,
        points: [
          S.of(context).fitternity_point1,
          S.of(context).fitternity_point2,
          S.of(context).fitternity_point3
        ],
        icon: "",
        color1: ColorConstants.claim_intimation_gradient_color1,
        color2: ColorConstants.claim_intimation_gradient_color2);

    comingSoonListModel = [
      GeneralListModel(
          title: S.of(context).book_health_packages_title,
          subTitle: S.of(context).book_health_packages_subtitle,
          icon: AssetConstants.ic_book_health_packages),
      GeneralListModel(
          title: S.of(context).online_chat_title,
          subTitle: S.of(context).online_chat_subtitle,
          icon: AssetConstants.ic_online_chat),
      GeneralListModel(
          title: S.of(context).fitness_class_title,
          subTitle: S.of(context).fitness_class_subtitle,
          icon: AssetConstants.ic_fitness_class),
      GeneralListModel(
          title: S.of(context).stay_active_benefits_title,
          subTitle: S.of(context).stay_active_benefits_subtitle,
          icon: AssetConstants.ic_stay_active_benefits),
    ];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 12, right: 12),
            child: CustomServiceWidget(
                bookDoctorBenefitModel,
                S.of(context).book_now_title.toUpperCase(),
                OnClickId.BOOK_DOCTOR_CARD,
                300,
                150,
                130)),
        Container(
            margin: EdgeInsets.only(left: 12, right: 12),
            child: CustomServiceWidget(
                fitternityBenefitModel,
                S.of(context).book_now_title.toUpperCase(),
                OnClickId.FITTERNITY_CARD,
                300,
                150,
                130)),
        Padding(
          padding: const EdgeInsets.only(
              left: 12.0, right: 12.0, top: 15.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                  width: 22,
                  height: 22,
                  child: Image.asset(AssetConstants.ic_star)),
              SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).coming_soon_title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Card(
            elevation: 5.0,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: comingSoonListModel.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildListItem(comingSoonListModel[index]);
                }),
          ),
        ),
      ],
    );
  }

  Widget buildListItem(GeneralListModel comingSoonListModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.2,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius:
                        borderRadius(radius: 5.0, topRight: 5.0, topLeft: 5.0),
                    border: Border.all(color: Colors.grey.shade600, width: 1.5),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.benefits_gradient_color1,
                          ColorConstants.benefits_gradient_color2
                        ]),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: 35,
                        width: 35,
                        child: Image.asset(comingSoonListModel.icon))),
              )
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  comingSoonListModel.title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: comingSoonListModel.titleColor),
                ),
                Text(
                  comingSoonListModel.subTitle,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: comingSoonListModel.subTitleColor),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
