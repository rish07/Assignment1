import 'package:flutter/material.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

class NetworkHospitalOnBoard extends StatefulWidget {
  @override
  _NetworkHospitalOnBoardState createState() => _NetworkHospitalOnBoardState();
}

class _NetworkHospitalOnBoardState extends State<NetworkHospitalOnBoard> with CommonWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    void close() {
      /// handle the shared pref bool onclick
      Navigator.of(context).pop();
    }
    Future<bool> _onBackPressed() {
      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black.withOpacity(0.5),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
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
                              padding: EdgeInsets.only(top: 10.0),
                              child: getCloseButton(onClose: close),
                            ))),
                  ),

                ],
              ),
            ),
          )),
    );
  }
}
