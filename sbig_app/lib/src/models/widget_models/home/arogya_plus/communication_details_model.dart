
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';

class CommunicationDetailsModel{
  String pinCode;
  List<String> areasList;
  String selectedArea;
  PinCodeData seletedAreaData;
  String address;
  String plotNo;
  String buildingName;
  String location;
  String streetName;

  CommunicationDetailsModel({this.pinCode, this.areasList, this.selectedArea,
      this.seletedAreaData, this.address, this.buildingName, this.location,
      this.streetName, this.plotNo});

}