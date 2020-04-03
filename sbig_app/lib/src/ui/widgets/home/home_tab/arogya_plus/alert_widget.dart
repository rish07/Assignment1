
import '../../../statefulwidget_base.dart';
import 'package:dotted_border/dotted_border.dart';

class AlertWidget extends StatefulWidgetBase {

  final String errorDescription;
  final double height;

  AlertWidget(this.errorDescription, this.height);

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
          color: (widget.height == 0) ? Colors.white : ColorConstants.red_alert_border_color,
          strokeWidth: 1.5,
          borderType: BorderType.RRect,
          radius: Radius.circular(20.0),
          padding: EdgeInsets.all(0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: AnimatedContainer(
              width: double.maxFinite,
              color: ColorConstants.red_alert_color,
              duration: Duration(milliseconds: 300),
              height: widget.height,
              child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 25,),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(AssetConstants.ic_red_alert),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.errorDescription, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 60,)
                  ],
                ),
              ),
      ),
    );
  }
}
