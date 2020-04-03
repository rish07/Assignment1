import 'package:dotted_border/dotted_border.dart';

import '../statefulwidget_base.dart';

class QuickFactWidget extends StatefulWidgetBase {
  final String quoteString;

  QuickFactWidget(this.quoteString);

  @override
  _QuickFactWidgetState createState() => _QuickFactWidgetState();
}

class _QuickFactWidgetState extends State<QuickFactWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: Radius.circular(5.0),
                padding: EdgeInsets.all(0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 5.0),
                    child: Text(widget.quoteString,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                            fontStyle: FontStyle.normal, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SizedBox(width: 40, height: 40, child: Image.asset(AssetConstants.ic_bulb)),
        ),
      ],
    );
  }
}
