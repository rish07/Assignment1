import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/controllers/service/call_sms_mail_service.dart';
import 'package:sbig_app/src/controllers/service/service_locator.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/widgets/claim/claim_service_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ConnectWithUsScreen extends StatefulWidget {

  @override
  _ConnectWithUsScreenState createState() => _ConnectWithUsScreenState();
}

class _ConnectWithUsScreenState extends State<ConnectWithUsScreen> with CommonWidget {
  double screenWidth;
  double screenHeight;
  final Service _service = getIt<Service>();
  ServiceModel callServiceModel, messageServiceModel, emailServiceModel;

  @override
  void didChangeDependencies() {
    screenWidth = ScreenUtil.getInstance(context).screenWidthDp;
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    callServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_call.toUpperCase(),
        subTitle: S.of(context).claim_intimation_call_no,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_mobile,
        color1: ColorConstants.claim_intimation_call_color1,
        color2: ColorConstants.claim_intimation_call_color2);

    messageServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_message.toUpperCase(),
        subTitle: S.of(context).claim_intimation_message_no,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_group,
        color1: ColorConstants.claim_intimation_message_color1,
        color2: ColorConstants.claim_intimation_message_color2);

    emailServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_email.toUpperCase(),
        subTitle: S.of(context).claim_intimation_email_address,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_mail,
        color1: ColorConstants.claim_intimation_email_color1,
        color2: ColorConstants.claim_intimation_email_color2);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            Expanded(
              child: Container(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5.0, right: 10.0),
                        child:getCloseButton(onClose: (){
                          Navigator.of(context).pop();
                        }),
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0 ),
              child: Container(
                decoration: BoxDecoration(
                    color:ColorConstants.connect_with_us_bg_color,
                    borderRadius: borderRadius(radius:0.0,topLeft: 6.0, topRight: 50.0)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Container(
                        child: Text(
                          S.of(context).connect_us_title,
                          style: TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 0.75,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,


                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20,bottom: 10),
                              child: ConnectWithUsWidget(callServiceModel,2),
                            ),
                            onTap: () {
                              _service
                                  .call(S.of(context).claim_intimation_call_no);
                            },
                          ),

                          InkWell(
                            child: Padding(
                              padding:  const EdgeInsets.only(bottom: 10),
                              child: ConnectWithUsWidget(messageServiceModel,2),
                            ),
                            onTap: () {
                              _service.sendSMS(
                                  S.of(context).claim.toUpperCase(),
                                  [S.of(context).claim_intimation_message_no]);
                            },
                          ),

                          InkWell(
                              onTap: () {
                                _service.sendEmail(
                                    S.of(context).claim_intimation_email_address);
                              },
                              child: Padding(
                                padding:  const EdgeInsets.only(bottom: 10),
                                child: ConnectWithUsWidget(emailServiceModel, 2),
                              )),
                        ],
                      ),

                      SizedBox(height: 20),

                      InkWell(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          child: Text(S.of(context).connect_wih_us_thanks ,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.blue_text,
                            ),),
                        ),
                        onTap:(){
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _showCloseButton(){

    onClick(){
      Navigator.of(context).pop();
    }
    return  closeImageWidget(onClick);
  }
}
