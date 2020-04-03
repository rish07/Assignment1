import 'package:flutter/material.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/screens/common_buy_journey/prdoduct_info.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

import '../../../statefulwidget_base.dart';

class CriticalIllnessCardWidget extends StatefulWidget {
  final ServiceModel serviceModel;
  final double height;

  CriticalIllnessCardWidget(this.serviceModel, [this.height = 260]);

  @override
  _State createState() => _State();
}

class _State extends State<CriticalIllnessCardWidget> with CommonWidget {
  ServiceModel serviceModel;
  double height;

  @override
  void initState() {
    serviceModel = widget.serviceModel;
    height = widget.height;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigate(context);
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius(topLeft: 40.0),
        ),
        child: Container(
          height: height - 15,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: borderRadius(topLeft: 40.0),
              image: DecorationImage(
                  image: AssetImage(serviceModel.icon), fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
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
      onPressed: () {
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

  _navigate(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME, arguments:  ProductInfoArguments(StringConstants.FROM_AROGYA_PREMIER,null));
       // Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,arguments: StringConstants.FROM_CRITICAL_ILLNESS);
    });
  }
}
