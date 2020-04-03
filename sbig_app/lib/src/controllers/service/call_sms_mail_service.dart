import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

abstract class Service {

  void call(String number);

  void sendSMS(String message, List<String> recipents) ;

  void sendEmail(String email);

}

class ServiceImplementation extends Service{

  @override
  void sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  void call(String number) {
    number = number.replaceAll(" ", "");
    launch("tel:$number");
  }

  @override
  void sendEmail(String email) {
    launch("mailto:$email");
  }



}