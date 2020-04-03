import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';

import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';

import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';

import 'health_question_api_provider.dart';


class HealthQuestionBloc extends BaseBloc {
  BehaviorSubject<DialogEvent> _eventStreamController = BehaviorSubject();

  Observable<DialogEvent> get eventStream => _eventStreamController.stream;

  Function(DialogEvent) get changeEventStream => _eventStreamController.add;

  Future<HealthQuestionResModel> getHealthQuestionContent(int isFrom) async {
    var response = await HealthQuestionApiProvider.getInstance()
        .getHealthQuestionContent(isFrom);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(
            DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }

  @override
  void dispose() async {
    await _eventStreamController.drain();
    _eventStreamController.close();
  }
}
