import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/cover_member/cover_member_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_premier/sum_insured/sum_insured_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/cover_member_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_sum_insured.dart';

import '../../base_bloc.dart';

class CoverMemberBloc extends BaseBloc  {

  BehaviorSubject<DialogEvent> _eventStreamController = BehaviorSubject();
  Observable<DialogEvent> get eventStream => _eventStreamController.stream;
  Function(DialogEvent) get changeEventStream => _eventStreamController.add;

  BehaviorSubject<bool> _isLoadingController = BehaviorSubject.seeded(false);
  Observable<bool> get isLoadingStream => _isLoadingController.stream;
  Function(bool) get changeLoadingStream => _isLoadingController.add;
  bool get isLoading => _isLoadingController.value;

  Future<CoverMemberResModel> getCoverMember  (int isFrom,{int policyType}) async {
    _isLoadingController.add(true);
    var response = await CoverMemberApiProvider.getInstance().getCoverMembers(isFrom,policyType: policyType);
    _isLoadingController.add(false);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }

  Future<SumInsuredResModel> getSumInsured (int isFrom,int age) async {
    _isLoadingController.add(true);
    var response = await SumInuredApiProvider.getInstance().getSumInsured(isFrom,age);
    _isLoadingController.add(false);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }

  Future<ArogyaTopUpSumInsuredResModel> getArogyaTopUpSumInsured (int age) async {
    _isLoadingController.add(true);
    var response = await SumInuredApiProvider.getInstance().getArogyaTopUpSumInsured(age);
    _isLoadingController.add(false);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }



  @override
  void dispose() async {
    await _eventStreamController.drain();
    _eventStreamController.close();
    await _isLoadingController.drain();
    _isLoadingController.close();

  }
}
