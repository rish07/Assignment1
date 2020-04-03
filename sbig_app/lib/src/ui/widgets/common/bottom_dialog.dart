import 'package:flutter/material.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class BottomDialog extends StatelessWidget with CommonWidget {

  final Widget child;
  final Function onClose;

  BottomDialog({@required this.child, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black45,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(50)),
                child: Container(
                  color: Colors.white,
                  width: ScreenUtil.getInstance(context).screenPercentWidth(90),
                  child: child,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: getCloseButton(onClose: () {
                  Navigator.pop(context);
                  if (onClose != null) {
                    onClose();
                  }
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
