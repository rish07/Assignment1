import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

class ConnectWithUsWidget extends StatelessWidget with CommonWidget {

  final ServiceModel serviceModel;

  final int flexValue;

   ConnectWithUsWidget( this.serviceModel, [this.flexValue=0]);
  //ClaimServiceWidget(this.serviceModel);

  @override
  Widget build(BuildContext context) {
    return
      Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(
            topLeft: Radius.circular(6.0),
            bottomLeft: Radius.circular(6.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(6.0)
          ),
        ),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    height: 56,
                    width: 45,
                    decoration:BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.0),
                          bottomLeft: Radius.circular(6.0),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [serviceModel.color1, serviceModel.color2]))
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8,top: 10,bottom: 8),
                    child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset(serviceModel.icon))),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,top: 12,bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    serviceModel.title,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 2,),
                  Text(
                    serviceModel.subTitle,
                    style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        color: Colors.black45),
                  ),
                ],
              ),
            ),
    ],),
      );



  }
}
