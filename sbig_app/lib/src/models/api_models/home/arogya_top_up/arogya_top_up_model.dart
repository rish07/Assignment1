import 'package:sbig_app/src/models/api_models/common_buy_journey/arogya_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_full_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_quick_quote_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_time_period_model.dart';

import 'arogya_top_up_sum_insured.dart';

class ArogyaTopUpModel extends ArogyaModel{

  ArogyaTopUpSumInsuredResModel arogyaTopUpSumInsuredResModel;

  ArogyaSumInsuredModel selectedSumInsured;
  ArogyaTimePeriodModel selectedTimePeriodModel;

  ArogyaTopUpQuickQuoteReqModel arogyaTopUpQuickQuoteReqModel;
  ArogyaTopUpQuickQuoteResModel arogyaTopUpQuickQuoteResModel;

  ArogyaTopUpFullQuoteReqModel arogyaTopUpFullQuoteReqModel;
  ArogyaTopUpFullQuoteResModel arogyaTopUpFullQuoteResModel;

  ArogyaTopUpModel({this.selectedSumInsured, this.selectedTimePeriodModel,
    this.arogyaTopUpQuickQuoteReqModel, this.arogyaTopUpQuickQuoteResModel,this.arogyaTopUpFullQuoteResModel,
  this.arogyaTopUpFullQuoteReqModel,this.arogyaTopUpSumInsuredResModel});


}