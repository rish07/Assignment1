import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import 'home_tab/arogya_plus/outline_button.dart';

class DisclaimerWidget extends StatelessWidget with CommonWidget {
  String title;
  Function(bool) onClick;
  String description;
  String agreeTermsDescription;

  DisclaimerWidget(
      this.title, this.onClick, this.description, this.agreeTermsDescription);

  @override
  Widget build(BuildContext context) {
    void onAgree() {
      Navigator.of(context).pop();
      onClick(true);
    }

    void onDisAgree() {
      onClick(false);
      Navigator.of(context).pop();
    }

    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Padding(
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
                          child: getCloseButton(onClose: onDisAgree),
                        ))),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(40)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                              height: 22,
                              width: 22,
                              child: Image.asset(AssetConstants.ic_disclaimer)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        agreeTermsDescription,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                            color: Colors.grey[800]
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlackButtonWidget(
                          onAgree, S.of(context).agree_title.toUpperCase()),
                      SizedBox(
                        height: 20,
                      ),
                      OutlineButtonWidget(onDisAgree,
                          S.of(context).dont_agree_title.toUpperCase())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
