
class ApiErrorModel{
  int _statusCode;
  String _message;
  String _errorCode;
  bool _status;


  int get statusCode => _statusCode;

  set statusCode(int value) {
    _statusCode = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

  String get errorCode => _errorCode;

  set errorCode(String value) {
    _errorCode = value;
  }

  bool get status => _status;

  set status(bool value) {
    _status = value;
  }

  ApiErrorModel(this._message, [this._statusCode]);

  ApiErrorModel.fromJson(Map<String, dynamic> parsedJson) :
        _status = parsedJson['status'],
        _message = parsedJson['message'],
        _errorCode=parsedJson["errorCode"];


}
