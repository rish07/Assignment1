import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/outline_button.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class CustomerRepresentativeWidget extends StatelessWidget with CommonWidget {
  static const NEAREST_BRANCH = 1;
  static const CONNECT_WITH_US = 2;
  static const GO_BACK_TO_HOME = 3;

  Function(int) onClick;
  String title,subTitle;

  CustomerRepresentativeWidget(this.onClick,{this.title='',this.subTitle});

  double width;

  @override
  Widget build(BuildContext context) {
    width = ScreenUtil.getInstance(context).screenWidthDp - 24;

    void close() {
      Navigator.of(context).pop();
    }

    void navigateToHome() {
      Navigator.of(context).pop();
      onClick(GO_BACK_TO_HOME);
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
                              padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
                              child: Image.asset(AssetConstants.ic_telephone),
                            ),
                            Text(
                              (title==null || title.isEmpty)?S.of(context).additional_info_required:title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              (subTitle==null || subTitle.isEmpty)?S.of(context).customer_representative:subTitle,
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
                              S.of(context).ok_thanks.toUpperCase(),
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

//    return Scaffold(
//        backgroundColor: Colors.black.withOpacity(0.5),
//        body: Padding(
//          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              Expanded(
//                child: Container(
//                    child: Align(
//                        alignment: Alignment.topRight,
//                        child: Padding(
//                          padding: EdgeInsets.only(top: 10.0),
//                          child: getCloseButton(onClose: navigateToHome),
//                        ))),
//              ),
//              Container(
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(20),
//                      topRight: Radius.circular(40)),
//                ),
//                child: Padding(
//                  padding: const EdgeInsets.all(20.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      SizedBox(
//                          height: 40,
//                          width: 40,
//                          child: Image.asset(AssetConstants.ic_disclaimer)),
//                      SizedBox(
//                        height: 20,
//                      ),
//                      Text(
//                        S.of(context).nearest_branch_description,
//                        textAlign: TextAlign.center,
//                        style: TextStyle(
//                            fontSize: 16,
//                            fontWeight: FontWeight.w500,
//                            color: Colors.black),
//                      ),
//                      Text(
//                        S.of(context).thank_you_message,
//                        style: TextStyle(
//                            fontSize: 16,
//                            fontWeight: FontWeight.w700,
//                            color: Colors.black),
//                      ),
//                      SizedBox(
//                        height: 40,
//                      ),
//                      BlackButtonWidget(navigateToNearestBranch,
//                          S.of(context).nearest_branch.toUpperCase()),
//                      SizedBox(
//                        height: 20,
//                      ),
//                      OutlineButtonWidget(navigateToConnectWithUs,
//                          S.of(context).connect_us_title.toUpperCase()),
//                      SizedBox(
//                        height: 40,
//                      ),
//                      InkWell(
//                        onTap: navigateToHome,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            //Image.asset(AssetConstants.ic_right_arrow),
//                            Icon(Icons.keyboard_backspace, color: ColorConstants.premium_opd_amount_card_color,),
//                            SizedBox(width: 8,),
//                            Text(
//                              S.of(context).go_back_to_home,
//                              style: TextStyle(
//                                  fontSize: 12,
//                                  fontWeight: FontWeight.w700,
//                                  color: ColorConstants.premium_opd_amount_card_color),
//                            )
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ));
  }
}
