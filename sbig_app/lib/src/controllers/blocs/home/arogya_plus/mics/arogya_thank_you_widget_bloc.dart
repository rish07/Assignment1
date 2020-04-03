import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/mics/arogya_plus_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/download_models.dart';

class ArogyaThankYouWidgetBloc extends BaseBloc {
  ArogyaPlusThankYouWidgetApiProvider _apiProvider = ArogyaPlusThankYouWidgetApiProvider();

  BehaviorSubject<UIEvent> _uiEventSC = BehaviorSubject();
  Observable<UIEvent> get uiEventStream => _uiEventSC.stream;

  void download(DocType docType, String policyId) {
    _uiEventSC.add(LoadingScreenUiEvent(true));
    _apiProvider.download(docType, policyId).then((parsedResponse) {
      _uiEventSC.add(LoadingScreenUiEvent(false));
      if(parsedResponse.hasData) {
        if(parsedResponse.data.success) {
          _uiEventSC.add(DownloadCompleteEvent(parsedResponse.data, docType, policyId));
        } else {
          _uiEventSC.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
        }
      } else if(parsedResponse.hasError) {
        if(parsedResponse.error.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
          _uiEventSC.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
        } else if (parsedResponse.error.statusCode == ApiResponseListenerDio.MAINTENANCE){
          _uiEventSC.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
        }else if(parsedResponse.error.statusCode== ApiResponseListenerDio.DDOS_ERROR){
          _uiEventSC.add(DialogEvent.dialogWithOutMessage(ApiResponseListenerDio.DDOS_ERROR));
        } else {
          _uiEventSC.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
        }
      }
    });
  }
  @override
  void dispose() {
    _uiEventSC.close();
  }

}

class DownloadCompleteEvent extends UIEvent {
  DownloadResponse _downloadResponse;
  DownloadResponse get downloadResponse => _downloadResponse;

  DocType _docType;
  DocType get docType => _docType;

  String _policyId;
  String get policyId => _policyId;

  DownloadCompleteEvent(this._downloadResponse, this._docType, this._policyId) : super(_downloadResponse);
}
