import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/models/api_models/home/loader/loaderMessageList.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class LoadingScreen extends StatelessWidget {
  String loaderMessage ="";
  @override
  Widget build(BuildContext context) {
    loaderMessage=LoaderList().getLoaderMessage();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: ColorConstants.black_60,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Image(
                          height: 100,
                          width: 100,
                          image: AssetImage(AssetConstants.gif_loader),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 4),
                      child: Text(
                        S.of(context).loading.toUpperCase(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getInstance(context).screenPercentWidth(70),
                      margin: EdgeInsets.only(top: 4),
                      child: Text(
                        "\"${(loaderMessage==null)?S.of(context).loading_screen_text : loaderMessage}\"",
                        style:
                            TextStyle(fontStyle: FontStyle.italic, fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
