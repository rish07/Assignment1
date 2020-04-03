import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ServicesTabError extends StatelessWidget {
  String imageAsset;
  String title;
  String subTitle;
  int retryIdentifier;
  Function onRetryClick;
  bool isInternerError;

  ServicesTabError(
      {this.imageAsset,
      this.title,
      this.subTitle,
      this.retryIdentifier,
      this.onRetryClick,
      this.isInternerError = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              isInternerError
                  ? Image(
                      width: double.infinity,
                      image: AssetImage(imageAsset),
                      fit: BoxFit.fitWidth,
                    )
                  : Image(
                      height: 120,
                      image: AssetImage(imageAsset),
                    ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: StringConstants.EFFRA,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 28),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    subTitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
                child: BlackButtonWidget(
                  () {
                    onRetryClick(retryIdentifier);
                  },
                  S.of(context).retry.toUpperCase(),
                  titleFontSize: 12,
                  height: 40,
                  width: ScreenUtil.getInstance(context).screenPercentWidth(50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
