
import 'package:get_it/get_it.dart';
import 'package:sbig_app/src/controllers/service/call_sms_mail_service.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<Service>(ServiceImplementation(),
      signalsReady: true);
}