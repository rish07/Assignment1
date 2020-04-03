import 'dart:async';

import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';

class BuyerDetailsBloc extends BaseBloc{

  //StreamController<int> buyerDetailsController = StreamController.broadcast();

  StreamController<int> communicationWidgetSC = StreamController.broadcast();
  StreamController<int> proposerDetailsWidgetSC = StreamController.broadcast();
  StreamController<int> nominieeDetailsWidgetSC = StreamController.broadcast();
  StreamController<int> appointeeDetailsWidgetSC = StreamController.broadcast();

  @override
  void dispose() {
    //buyerDetailsController.close();
    communicationWidgetSC.close();
    proposerDetailsWidgetSC.close();
    nominieeDetailsWidgetSC.close();
    appointeeDetailsWidgetSC.close();
  }
}