import 'package:sbig_app/src/ui/widgets/common/button_gradient_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import '../outline_button.dart';

class ProductDisclaimerWidget extends StatelessWidget with CommonWidget {
  String title;
  Function(bool) onClick;
  String description;
  String agreeTermsDescription;


  ProductDisclaimerWidget(
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
                            child: getCloseButton(onClose: onDisAgree),
                          ))),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
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
                        Container(
                          height: isIPad(context) ? 70.0 : 155.0,
                          child: Scrollbar(
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                Text(
                                  description,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600], letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          agreeTermsDescription,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600], letterSpacing: 0.5
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        /*BlackButtonWidget(
                          onAgree, S.of(context).agree_title.toUpperCase(), width: 180.0, height: 45.0,), */
                        GradientButtonWidget(
                          onAgree, S.of(context).agree_title.toUpperCase(), width: 180.0, height: 45.0,gradientColours:  [
                          ColorConstants.policy_type_gradient_color1,
                          ColorConstants.policy_type_gradient_color2],isNormal: false,),
                        SizedBox(
                          height: 15,
                        ),
                        OutlineButtonWidget(onDisAgree,
                          S.of(context).dont_agree_title.toUpperCase(), width: 180, height: 45.0,textColour: ColorConstants.policy_type_gradient_color1 ,outlineBorderColour: ColorConstants.policy_type_gradient_color1,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
