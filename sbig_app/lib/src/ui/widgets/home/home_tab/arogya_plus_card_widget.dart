import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/arogya_plus_product_info_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

import 'arogya_plus/product_info/product_disclaimer_widget.dart';

class ArogyaPlusCardWidget extends StatelessWidget with CommonWidget {
  final ServiceModel serviceModel;
  final double height;

  ArogyaPlusCardWidget(this.serviceModel, [this.height = 260]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _navigate(context);
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius(topLeft: 40.0),
        ),
        child: Container(
          height: height-15,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: borderRadius(topLeft: 40.0),
              image: DecorationImage(
                  image: AssetImage(serviceModel.icon), fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0,top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      serviceModel.title.toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: serviceModel.isSubTitleRequired,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          child: Text(
                            serviceModel.subTitle,
                            style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.yellow),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildListOfPoints(context),
                    SizedBox(
                      height: 10,
                    ),
                    buyNow(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildListOfPoints(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: serviceModel.points.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: <Widget>[
                Image.asset(AssetConstants.ic_tick),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Text(
                    serviceModel.points[index],
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            );
          }),
    );
  }

  Widget buyNow(BuildContext context) {
    return MaterialButton(
      height: 30,
      color: Colors.white,
      onPressed: (){
        _navigate(context);
      },
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(15.0),
      ),
      textColor: Colors.white,
      highlightColor: Colors.grey.shade200,
      highlightElevation: 5.0,
      child: Text(
        S.of(context).buy_now_title.toUpperCase(),
        style: TextStyle(
            fontSize: 12,
            color: ColorConstants.arogya_plus_buy_now,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  _navigate(BuildContext context){
    Future.delayed(Duration(milliseconds: 200),(){
      Navigator.of(context).pushNamed(ArogyaPlusProductInfoScreen.ROUTE_NAME);
    });
  }

//  void showDisclaimer(BuildContext context) async {
//    onClick(bool isAgree) {
//      if (isAgree) {
//        Navigator.of(context).pushNamed(ArogyaPlusProductInfoScreen.ROUTE_NAME);
//      }
//    }
//    rootBundle
//        .loadString(AssetConstants.arogya_plus_disclaimer)
//        .then((disclaimer) {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) => WillPopScope(
//              onWillPop: () {
//                return Future<bool>.value(true);
//              },
//              child: ProductDisclaimerWidget(S.of(context).disclaimer_title, onClick,
//                  disclaimer, S.of(context).agree_terms_info)));
//    });
//  }
}
