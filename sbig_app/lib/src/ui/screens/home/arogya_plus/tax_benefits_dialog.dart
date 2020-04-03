import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class WebViewDialog extends StatefulWidget {
  final String url, title;
  final DialogKind dialogType;
  final int initialScale;

  WebViewDialog(this.url, this.title,  this.dialogType, {this.initialScale = 0});

  @override
  _WebViewDialogState createState() => _WebViewDialogState();
}

class _WebViewDialogState extends State<WebViewDialog> with CommonWidget {

  int heightPercentage;
  double _margin = 10;

  @override
  void initState() {
    if(widget.dialogType == DialogKind.TAX_BENEFIT) {
      heightPercentage = 60;
    } else {
      heightPercentage = 80;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.maxFinite,
            width: double.infinity,
            color: Colors.black45,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(top: _margin, bottom: _margin),
                      child: closeImageWidget(() {
                        Navigator.of(context).pop();
                      }),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(8)),
                  child: Container(
                    color: Colors.white,
                    height: ScreenUtil.getInstance(context).screenPercentageHeight(heightPercentage),
                    width: ScreenUtil.getInstance(context).screenPercentWidth(90),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              widget.title,
                              style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Expanded(
                            child: WebviewScaffold(
                              url: widget.url,
                              debuggingEnabled: true,
                              withJavascript: true,
                              withZoom: true,
                              resizeToAvoidBottomInset: true,
                              scrollBar: true,
                              withOverviewMode: false,
                              initialScale: widget.initialScale,
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

enum DialogKind {
  TAX_BENEFIT, OPD_BENEFIT, T_n_C, PRIVACY_POLICY
}
