import 'package:sbig_app/src/ui/screens/onboarding/link_register_policy_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/register_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class WelcomeScreen extends StatefulWidget {
  static const ROUTE_NAME = "/onboarding/welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

enum Status {
  none,
  yes_selected,
  no_selected,
}

enum WelcomeScreenStatus {
  welcome_screen,
  link_policy_screen,
  register_screen,
}

class _WelcomeScreenState extends State<WelcomeScreen> with CommonWidget {
  Status status = Status.none;
  WelcomeScreenStatus screenStatus = WelcomeScreenStatus.welcome_screen;
  double height, width;

  onStatusChange(WelcomeScreenStatus screenStatus) {
    setState(() {
      this.screenStatus = screenStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = ScreenUtil.getInstance(context).screenHeightDp / 2;
    width = ScreenUtil.getInstance(context).screenWidthDp / 2 - 50 - 20;

    _onBackPressed(int from) {
      onStatusChange(WelcomeScreenStatus.welcome_screen);
    }

    Future<bool> _onWillPop() async {
      if (screenStatus != WelcomeScreenStatus.welcome_screen) {
        _onBackPressed(1);
        return Future.value(false);
      }
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorConstants.arogya_plus_bg_color,
//      appBar: screenStatus == WelcomeScreenStatus.register_screen
//          ? getAppBar(null, "",
//              isActionRequired: false, backActionRequired: true, onBackPressed: _onBackPressed)
//          : null,
        body: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: height + 55,
                child: getHeader()),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 15,
                          // offset: Offset(0, 0),
                          color: Colors.black26,
                          spreadRadius: 5)
                    ],
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(40.0))),
                child: Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: checkScreenStatus()),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getHeader() {
    if (screenStatus != WelcomeScreenStatus.link_policy_screen) {
      return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                child: Image.asset(AssetConstants.bg_welcome),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: (screenStatus == WelcomeScreenStatus.register_screen)
                ? getAppBar(null, "",
                    isActionRequired: true,
                    backActionRequired: true,
                    onBackPressed: (int from) {
                      onStatusChange(WelcomeScreenStatus.welcome_screen);
                    },
                    actionName: S.of(context).skip_title.toUpperCase(),
                    onActionClicked: () {
                      skipOnboard(context);
                    })
                : null,
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                child: Image.asset(AssetConstants.bg_linkpolicy),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: (screenStatus != WelcomeScreenStatus.welcome_screen)
                ? getAppBar(null, "",
                    isActionRequired: true,
                    backActionRequired: true,
                    onBackPressed: (int from) {
                      onStatusChange(WelcomeScreenStatus.welcome_screen);
                    },
                    actionName: S.of(context).skip_title.toUpperCase(),
                    onActionClicked: () {
                      skipOnboard(context);
                    })
                : getAppBar(null, "",
                    isActionRequired: false, backActionRequired: false),
          ),
        ],
      );
    }
  }

  Widget welcomeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Text(
          S.of(context).welcome_title,
          style: TextStyle(
              fontFamily: StringConstants.EFFRA_LIGHT,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          S.of(context).welcome_question,
          style: TextStyle(
              fontFamily: StringConstants.EFFRA_LIGHT,
              fontSize: 16.0,
              color: Colors.grey.shade800),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            yesNoButton(S.of(context).no, width),
            SizedBox(
              width: 20,
            ),
            yesNoButton(S.of(context).yes, width),
          ],
        ),
      ],
    );
  }

  checkScreenStatus() {
    switch (screenStatus) {
      case WelcomeScreenStatus.link_policy_screen:
        return LinkRegisterPolicyScreen(onStatusChange: onStatusChange);
      case WelcomeScreenStatus.register_screen:
        return RegisterScreen(onStatusChange: onStatusChange);
      case WelcomeScreenStatus.welcome_screen:
        return welcomeWidget();
    }
  }

  Widget yesNoButton(String title, double width) {
    Color selectedBgColor = (status.index == Status.yes_selected.index &&
            title.compareTo(S.of(context).yes) == 0)
        ? Colors.black
        : (status.index == Status.no_selected.index &&
                title.compareTo(S.of(context).no) == 0
            ? Colors.black
            : Colors.white);

    Color textColor = status.index == Status.none.index
        ? Colors.black
        : (selectedBgColor == Colors.white ? Colors.black : Colors.white);

    return MaterialButton(
      minWidth: width,
      height: 50,
      color: selectedBgColor,
      onPressed: () {
        setState(() {
          if (screenStatus == WelcomeScreenStatus.welcome_screen) {
            if (title.compareTo(S.of(context).yes) == 0) {
              status = Status.yes_selected;
              screenStatus = WelcomeScreenStatus.link_policy_screen;
            } else {
              status = Status.no_selected;
              screenStatus = WelcomeScreenStatus.register_screen;
            }
          }
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100 / 2),
      ),
      textColor: Colors.white,
      highlightColor: Colors.grey[800],
      highlightElevation: 5.0,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14.0,
            color: textColor,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.0),
      ),
    );
  }
}
