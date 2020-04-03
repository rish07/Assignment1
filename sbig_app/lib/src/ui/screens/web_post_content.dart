import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/src/linear_percent_indicator.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import 'home/home_screen.dart';

class WebPostContent extends StatefulWidget {
  static const routeName = "/web_post_content";

  final WebPostContentArguments _webContentArguments;

  WebPostContent(this._webContentArguments);

  @override
  _WebContentState createState() => _WebContentState();
}

class _WebContentState extends State<WebPostContent> with CommonWidget {
  bool _isLoaderVisible = true;
  double percentageLoading = 0.0;
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canGoBack = await webView.canGoBack();
        if (canGoBack) {
          webView.goBack();
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        appBar: _webAppBar(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[getInAppWebViewChild()],
          ),
        ),
      ),
    );
  }

  getInAppWebViewChild() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Visibility(
          visible: percentageLoading < 1.0,
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width,
            progressColor: Colors.lightBlue,
            percent: percentageLoading,
            padding: EdgeInsets.all(0.0),
            clipLinearGradient: false,
            animation: false,
          ),
        ),
        Expanded(
          child: InAppWebView(
            initialUrl: widget._webContentArguments.url,
            initialHeaders: {},
            initialOptions: InAppWebViewWidgetOptions(
                inAppWebViewOptions: InAppWebViewOptions(
              debuggingEnabled: true,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
              webView.postUrl(
                  url: widget._webContentArguments.url,
                  postData: getPostData(
                      widget._webContentArguments.token,
                      widget._webContentArguments.mobile,
                      widget._webContentArguments.email));
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              print("FITTERNITY URL: " + url);
              if (url.endsWith("fitternitycallback")) {
                Future.delayed(Duration(seconds: 2)).then((aVal) {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(HomeScreen.ROUTE_NAME));
                });
              }
            },
            onLoadStop:
                (InAppWebViewController controller, String url) async {},
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              if (_isLoaderVisible) {
                setState(() {
                  percentageLoading = progress / 100;
                  if (percentageLoading == 1) {
                    _isLoaderVisible = false;
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Uint8List getPostData(String token, String mobile, String email) {
    StringBuffer postString = StringBuffer();
    postString.write("token=");
    postString.write(token);

    postString.write("&");
    postString.write("customer_email=");
    postString.write(email);

    postString.write("customer_mobileno=");
    postString.write(mobile);

    return Uint8List.fromList(postString.toString().codeUnits);
  }

  AppBar _webAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: Platform.isIOS ? 8.0 : NavigationToolbar.kMiddleSpacing,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Image(
            image: AssetImage(AssetConstants.ic_toolbar_sbig),
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 0),
          child: getCloseButton(
              color: Colors.black,
              onClose: () {
                webView.stopLoading();
                Navigator.of(context).pop();
              }),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class WebPostContentArguments {
  final url;
  final String tag;
  final String title;
  final String email;
  final String mobile;
  final String token;

  WebPostContentArguments(this.url, this.tag,
      {this.title, this.email, this.mobile, this.token});
}
