

class PolicyCardDetails {
  String _vehicleRegNumber = "";
  String _carModel = "";
  String _insuredMembersHalf = "";
  String _insuredMembersFull = "";
  String _policyPeriod = "";
  String _productName = "";
  String _policyNo = "";
  String _proposerName = "";
  String _asset = "";
  bool _isError = false;
  bool _isMotor = false;
  int _apiHit = 0;

  String get vehicleRegNumber => _vehicleRegNumber;

  set vehicleRegNumber(String value) {
    _vehicleRegNumber = value;
  }

  String get carModel => _carModel;

  set carModel(String value) {
    _carModel = value;
  }

  String get insuredMembersHalf => _insuredMembersHalf;

  set insuredMembersHalf(String value) {
    _insuredMembersHalf = value;
  }

  String get insuredMembersFull => _insuredMembersFull;

  set insuredMembersFull(String value) {
    _insuredMembersFull = value;
  }

  String get policyPeriod => _policyPeriod;

  set policyPeriod(String value) {
    _policyPeriod = value;
  }

  String get productName => _productName;

  set productName(String value) {
    _productName = value;
  }

  String get policyNo => _policyNo;

  set policyNo(String value) {
    _policyNo = value;
  }

  String get proposerName => _proposerName;

  set proposerName(String value) {
    _proposerName = value;
  }

  bool get isMotor => _isMotor;

  set isMotor(bool value) {
    _isMotor = value;
  }

  String get asset => _asset;

  set asset(String value) {
    _asset = value;
  }

  bool get isError => _isError;

  set isError(bool value) {
    _isError = value;
  }

  int get apiHit => _apiHit;

  set apiHit(int value) {
    _apiHit = value;
  }
}
