
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class CustomMaterialPageRoute extends MaterialPageRoute{

  CustomMaterialPageRoute({WidgetBuilder builder, RouteSettings settings}) :super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation);
    return SlideTransition(position: custom, child: child);
  }
}