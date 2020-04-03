import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sbig_app/src/splash.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import 'controllers/routes/routes.dart';

class SBIGApp extends StatefulWidgetBase {
  @override
  _SBIGAppState createState() => _SBIGAppState();

  static const locale = [Locale("en", "")];

  static void setLocale(BuildContext context, Locale newLocale) async {
    _SBIGAppState state =
        context.ancestorStateOfType(TypeMatcher<_SBIGAppState>());

    state.setState(() {
      state.locale = newLocale;
    });
  }
}

class _SBIGAppState extends State<SBIGApp> with CommonWidget {
  var locale = SBIGApp.locale[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          primaryColorDark: Colors.white,
          accentColor: Colors.white,
          fontFamily: 'Effra'),
      localizationsDelegates: [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(fallback: locale),
      home: SplashAnimation(),
      onGenerateRoute: (RouteSettings settings) {
        return Routes.onGenerateRoute(settings);
      },
    );
  }
}
