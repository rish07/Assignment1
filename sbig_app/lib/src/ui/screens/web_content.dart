import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/loading_screen.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class WebContent extends StatefulWidget {
  static const ROUTE_NAME = "/web_content";

  final WebContentArguments _webContentArguments;
  WebContent(this._webContentArguments);

  @override
  _WebContentState createState() => _WebContentState();
}

class _WebContentState extends State<WebContent> with CommonWidget {
  final flutterWebViewPlugIn = FlutterWebviewPlugin();
  bool _isLoaderVisible = true;
  double percentageLoading = 0.0;

  @override
  void initState() {
    flutterWebViewPlugIn.onUrlChanged.listen((url) {
      //debugPrint("WEBVIEW URL CHANGED => $url");
      if (url.endsWith("docprimecallback")) {
        Future.delayed(Duration(seconds: 2)).then((aVal) {
          flutterWebViewPlugIn.close();
          Navigator.of(context)
              .popUntil(ModalRoute.withName(HomeScreen.ROUTE_NAME));
        });
      }
    });

    flutterWebViewPlugIn.onProgressChanged.listen((progress) {
      debugPrint("WEB VIEW Progress: $progress");
      if (_isLoaderVisible) {
        setState(() {
          percentageLoading = progress;
        });
      }
    });

    flutterWebViewPlugIn.onStateChanged.listen((currentState) {
      debugPrint("WEB VIEW Current State: ${currentState.type}");
      if (currentState.type == WebViewState.abortLoad || currentState.type == WebViewState.finishLoad) {
        if (_isLoaderVisible) {
          //setState(() {
          _isLoaderVisible = false;
          // });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        debugPrint("BACK PRESSED IN WEBViEW");
        bool canGoBack = await flutterWebViewPlugIn.canGoBack();
        if (canGoBack) {
          flutterWebViewPlugIn.goBack();
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        appBar: (widget._webContentArguments.tag.compareTo('DOCPRIME') == 0)?_docPrimeAppBar():_webAppBar(),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              WebviewScaffold(
                url: widget._webContentArguments._url,
                withLocalStorage: true,
                debuggingEnabled: kReleaseMode,
                geolocationEnabled: true,
                hidden: false,
                percentageLoading: percentageLoading,
                //initialChild: (widget._webContentArguments.tag.compareTo('DOCPRIME') != 0) ? _tweakedLoaderWidget(_isLoaderVisible) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A harmless workaround to hide the initial child from the background
  /// of the webview  when the webview has already been loaded,
  /// by making the opacity 0.
  /// When the [_isLoaderVisible] is made false the opacity is made 0.
  ///
  /// Could not use visibility widget, cause it was producing unintended result.
  /// The whole webview was becoming invisible when the initial child was
  /// made invisible.
  Widget _tweakedLoaderWidget(bool loaderVisible) {
    return Opacity(
      opacity: loaderVisible ? 1 : 0,
      child: LoadingScreen(),
    );
  }

//  Widget _tweakedLoaderWidget(bool loaderVisible) {
//    return Opacity(
//      opacity: loaderVisible ? 1 : 0,
//      child: Container(
//        width: double.infinity,
//        height: double.infinity,
//        color: Colors.transparent,
//        child: Align(
//          alignment: Alignment.topCenter,
//          child: LinearPercentIndicator(
//            width: ScreenUtil.getInstance(context).screenWidthDp,
//            progressColor: Colors.blue,
//            percent: percentageLoading,
//            clipLinearGradient: false,
//            animation: true,
//          ),
//        ),
//      )
//    );
//  }

  AppBar _docPrimeAppBar() {
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
                flutterWebViewPlugIn?.close();
                Navigator.of(context).pop();
                //_webViewController.loadUrl("http://13.235.199.36/webcore/docprimecallback");
              }),
        )
      ],
    );
  }


  AppBar _webAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: InkResponse(
          onTap: () {
            flutterWebViewPlugIn?.close();
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 0.0, top: 18.0, bottom: 18.0),
            child: Image.asset(AssetConstants.ic_left_arrow),
          )),
      centerTitle: true,
      title: Text(
        widget._webContentArguments.title,
        style:  TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontSize: 14,
            letterSpacing: 1.0),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class WebContentArguments {
  final _url;
  final String tag;
  final String title;

  WebContentArguments(this._url, this.tag, {this.title});

}