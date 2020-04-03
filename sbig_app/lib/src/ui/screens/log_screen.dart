import 'package:sbig_app/src/resources/log_storage.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class LogScreen extends StatefulWidget {

  static const ROUTE_NAME = "/log_screen";

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> with CommonWidget{

  String text = "";

  @override
  void initState() {
    CounterStorage().readData().then((data){
      setState(() {
        text = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, "Log (Debugging Purpose)"),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SelectableText(text),
          ),
        ),
      ),
    );
  }
}
