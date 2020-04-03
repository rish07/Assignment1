import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ServiceModel {
  final String title;
  final String subTitle;
  final bool isSubTitleRequired;
  final List<String> points;
  final String icon;
  final Color color1;
  final Color color2;

  ServiceModel(
      {this.title,
      this.subTitle,
      this.isSubTitleRequired,
      this.points,
      this.icon,
      this.color1,
      this.color2});
}
