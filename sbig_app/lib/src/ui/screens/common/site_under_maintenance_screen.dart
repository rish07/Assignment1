import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class SiteUnderMaintenanceScreen extends StatelessWidget with CommonWidget {
  static const route_name = '/site_under_maintenance_route';

  final double imageWidthPercent = 0.85;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorConstants.policy_type_gradient_color2,
                    ColorConstants.policy_type_gradient_color1
                  ]
                )
              ),
            ),
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    width: MediaQuery.of(context).size.width * imageWidthPercent,
                    child: Image(
                      image: AssetImage(AssetConstants.img_site_under_maintenance),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text(
                      S.of(context).sorry_for_inconvenience,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Text(
                      S.of(context).app_under_maintenance,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16,),
                    ),
                  )
                ],
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child:closeImageWidget(() {
                    Navigator.of(context).pop();
                  }),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
