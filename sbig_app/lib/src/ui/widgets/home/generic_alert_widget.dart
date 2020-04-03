import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/outline_button.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class GenericAlertWidget extends StatelessWidget with CommonWidget {

  final Function(int) onClick;
  final int from;
  final String title;
  final String description;
  final String asset;

  GenericAlertWidget({this.onClick, this.from, this.title, this.description, this.asset});

  @override
  Widget build(BuildContext context) {

    void close() {
      Navigator.of(context).pop();
    }

    void navigateToHome() {
      Navigator.of(context).pop();
      onClick(1);
    }

    return Scaffold(
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
                            padding: EdgeInsets.only(top: 0.0),
                            child: getCloseButton(onClose: close),
                          ))),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(40)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                              child: SizedBox(width: 150, height: 150,child: Image.asset(asset)),
                            ),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            BlackButtonWidget(
                              navigateToHome,
                              S.of(context).thank_you_title.toUpperCase(),
                              titleFontSize: 12.0,
                              width: 150,
                              height: 40,
                              isNormal: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
