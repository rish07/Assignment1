
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_list_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_list_response.dart';
import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_suggestion.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import './network_hospital_validators.dart';

class NetworkHospitalBloc extends BaseBloc {

  static const String TPA_CATEGORY_ALL = "";
  static const String TPA_CATEGORY_MEDI_ASSIST = "medi_assist";
  static const String TPA_CATEGORY_PARAMOUNT = "paramount";

  String currentTpaCategorySelected = TPA_CATEGORY_ALL;
  String searchKey ='';
  String lat ='',long='';


  NetworkHospitalListAPiProvider _hospitalListAPiProvider = NetworkHospitalListAPiProvider();

  BehaviorSubject<String> _pinStreamController = BehaviorSubject.seeded("");
  Observable<String> get pinStream => _pinStreamController.stream.transform(NetworkHospitalValidators.getPinValidator());
  String get pin => _pinStreamController.value;

  BehaviorSubject<List<ResponseData>> _hospitalListStreamController = BehaviorSubject();
  Observable<List<ResponseData>> get hospitalListStream => _hospitalListStreamController.stream;
  Function(List<ResponseData>) get changeHospitalList=> _hospitalListStreamController.sink.add;
  List<ResponseData> get hospitalList => _hospitalListStreamController.value;

/*  BehaviorSubject<List<String>> _hospitalSuggestionListStreamController = BehaviorSubject();
  Observable<List<String>> get hospitalSuggestionListStream => _hospitalSuggestionListStreamController.stream;
  List<String> get suggestionList => _hospitalSuggestionListStreamController.value; */

  BehaviorSubject<List<SuggestionData>> _hospitalSuggestionListStreamController = BehaviorSubject();
  Observable<List<SuggestionData>> get hospitalSuggestionListStream => _hospitalSuggestionListStreamController.stream;
  List<SuggestionData> get suggestionList => _hospitalSuggestionListStreamController.value;

  BehaviorSubject<bool> _isLoadingController = BehaviorSubject.seeded(false);
  Observable<bool> get isLoadingStream => _isLoadingController.stream;
  Function(bool) get changeLoader => _isLoadingController.sink.add;
  bool get isLoading => _isLoadingController.value;

  /// To Display the Instruction Screen for the 1st time of loading
  BehaviorSubject<bool> _isFirstController = BehaviorSubject.seeded(false);
  Observable<bool> get isFirstStream => _isFirstController.stream;
  Function(bool) get changeIsFirst => _isFirstController.sink.add;
  bool get isFirst => _isFirstController.value;

  BehaviorSubject<bool> _gpsIconController = BehaviorSubject.seeded(false);
  Observable<bool> get gpsIconStream => _gpsIconController.stream;
  Function(bool) get changeGpsIconStatus => _gpsIconController.sink.add;
  bool get gpsIcon => _gpsIconController.value;

  BehaviorSubject<String> _searchBoxPinErrorStreamController = BehaviorSubject();
  Observable<String> get searchBoxPinCodeErrorStream => _searchBoxPinErrorStreamController.stream;
  Function(String errorMessage) get setPinCodeErrorString => _searchBoxPinErrorStreamController.sink.add;
  String get searchBoxErrorStreamValue => _searchBoxPinErrorStreamController.value;

  BehaviorSubject<UIEvent> _eventStreamController = BehaviorSubject();
  Observable<UIEvent> get eventStream => _eventStreamController.stream;

  NetworkHospitalListModel _networkHospitalListModel;
  NetworkHospitalSuggestionListModel networkHospitalSuggestionListModel;

  int pageNo = 1;
  bool shouldRequestForNextPage = true;
  List<ResponseData> _hospitalList = [];
  List<String> hospitalSuggestionList=[];
  List<SuggestionData> areaSuggestionList=[];
  List<SuggestionData> temList=[];

  String _savedPinToLoadMore = "";
  bool loadMoreEnabled = false;

  void setPin(String pin) {
    return _pinStreamController.sink.add(pin);
  }

  void getHospitalList(String keyword, String tpaCategory,{String latitude, String longitude}) {
    _getHospitalList(keyword, tpaCategory,latitude: latitude,longitude: longitude);
  }

  Future<List<SuggestionData>> getHospitalSuggestionList(String keyword) async {
    return await _getHospitalSuggestionList(keyword);
  }

  Future<List<SuggestionData>> _getHospitalSuggestionList(String keyword) async {
    if(searchKey == keyword) {
      searchKey = keyword;
      return suggestionList ?? [];
    }else{
      searchKey = keyword;
      areaSuggestionList.clear();
      networkHospitalSuggestionListModel=null;
    }
    _isLoadingController.add(true);
    var response = await _hospitalListAPiProvider.getSuggestion(keyword);
    _isLoadingController.add(false);
    if(response.hasData) {
      networkHospitalSuggestionListModel = response.data;
      if(networkHospitalSuggestionListModel.status) {
       // temList.addAll(response.data.data);
        //temList.forEach((data)=>data.autoCompleteSearch = data.area+data.pincode+", "+data.city+", "+data.state);
        areaSuggestionList.addAll(response.data.data);
        areaSuggestionList.forEach((data){
          data.autoCompleteSearch = data.area+data.pincode+' '+data.city+", "+data.state;
        });
       _hospitalSuggestionListStreamController.add(areaSuggestionList);
       return areaSuggestionList;
      }
    } else if(response.hasError) {
      print('response.error.statusCode ${response.error.statusCode}');
      if(response.error.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      }
      else if(response.error.statusCode== ApiResponseListenerDio.MAINTENANCE){
        _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      }
      else {
        _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
    }
    return areaSuggestionList;
  }

  /*Future<List<String>> _getHospitalSuggestionList(String keyword) async {
    if(searchKey == keyword) {
      searchKey = keyword;
      return suggestionList ?? [];
    }else{
      searchKey = keyword;
      hospitalSuggestionList.clear();
      networkHospitalSuggestionListModel=null;
    }
    _isLoadingController.add(true);
    var response = await _hospitalListAPiProvider.getSuggestion(keyword);
    _isLoadingController.add(false);
    if(response.hasData) {
      networkHospitalSuggestionListModel = response.data;
      if(networkHospitalSuggestionListModel.status) {
        hospitalSuggestionList.addAll(response.data.data);
        _hospitalSuggestionListStreamController.add(hospitalSuggestionList);
        return hospitalSuggestionList;
      }
    } else if(response.hasError) {
      if(response.error.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      }
      else if(response.error.statusCode== ApiResponseListenerDio.MAINTENANCE){
        _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      }
      else {
        _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
    }
    return hospitalSuggestionList;
  }
*/
  void _getHospitalList(String keyword, String tpaCategory,{String latitude, String longitude}) {
    if(currentTpaCategorySelected != tpaCategory) {
      currentTpaCategorySelected = tpaCategory;
      _hospitalList.clear();
      _networkHospitalListModel = null;
      pageNo = 1;
      loadMoreEnabled = false;
      lat=latitude;
      long=longitude;
    }
    _savedPinToLoadMore = keyword;
 /*   if(!loadMoreEnabled) {
      _isLoadingController.add(true);
    }*/
    if(!loadMoreEnabled && !isLoading) {
      _isLoadingController.add(true);
    }
    _hospitalListAPiProvider.getHospitalListApiNew(keyword, pageNo, tpaCategory: currentTpaCategorySelected,latitude: latitude,longitude: longitude).then((parsedResponse){
      _isLoadingController.add(false);
      loadMoreEnabled = false;
      if(parsedResponse.hasData) {
        _networkHospitalListModel = parsedResponse.data;
        if(_networkHospitalListModel.success) {
          _hospitalList.addAll(parsedResponse.data.responseData);
          _hospitalListStreamController.add(_hospitalList);
        }
      } else if(parsedResponse.hasError) {
        print('response.error.statusCode ${parsedResponse.error.statusCode}');
        if(parsedResponse.error.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
        }
        else if(parsedResponse.error.statusCode== ApiResponseListenerDio.MAINTENANCE){
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
        }
        else {
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
        }
      }
    });
  }

  void fetchFreshHospitalList(String keyword, String tpaCategory,{String latitude, String longitude}) {
    currentTpaCategorySelected = tpaCategory;
    _hospitalList.clear();
    _networkHospitalListModel = null;
    pageNo = 1;
    loadMoreEnabled = false;

    _getHospitalList(keyword, tpaCategory,latitude: latitude,longitude: longitude);
  }

  void hospitalListTryToLoadMore() {
    if(isThereDataToLoad()) {
      if(TextUtils.isEmpty(_savedPinToLoadMore)) {
        _eventStreamController.add(SnackBarEvent("Something went wrong"));
        return;
      }
      pageNo = _getNextPageNumber();
      if(pageNo != null) {
        loadMoreEnabled = true;
        _getHospitalList(_savedPinToLoadMore, currentTpaCategorySelected,latitude: lat,longitude: long);
      }
    }
  }

  bool isThereDataToLoad() {
    if(_networkHospitalListModel == null) return true;
    else {
      return !TextUtils.isEmpty(_networkHospitalListModel.data.nextPage);
    }
  }

  int _getNextPageNumber() {
    if(_networkHospitalListModel == null) return 1;
    if(TextUtils.isEmpty(_networkHospitalListModel.data.nextPage)) return null;
    Uri uri = Uri.dataFromString(_networkHospitalListModel.data.nextPage);

    Map<String, String> qParams = uri.queryParameters;
    double nextPage = double.tryParse(qParams['page']);

    if(double != null) return nextPage.toInt();
    else return null;
  }

  int getTotalSearchResult() {
    if(_networkHospitalListModel != null) {
      return _networkHospitalListModel.totalHospital;
    }
    return 0;
  }

  BehaviorSubject<bool> _searchButtonVisibility = BehaviorSubject.seeded(false);
  Observable<bool> get searchButtonVisibility => _searchButtonVisibility.stream;
  Function(bool) get changeSearchButtonVisibility => _searchButtonVisibility.sink.add;

  NetworkHospitalBloc();

  @override
  void dispose() async{
    await _pinStreamController.drain();
    _pinStreamController.close();
    await _searchButtonVisibility.drain();
    _searchButtonVisibility.close();
    await _hospitalListStreamController.drain();
    _hospitalListStreamController.close();
    await _isLoadingController.drain();
    _isLoadingController.close();
    await _eventStreamController.drain();
    _eventStreamController.close();
    await _searchBoxPinErrorStreamController.drain();
    _searchBoxPinErrorStreamController.close();
    await _isFirstController.drain();
    _isFirstController.close();
    await _hospitalSuggestionListStreamController.drain();
    _hospitalSuggestionListStreamController.close();
    await _gpsIconController.drain();
    _gpsIconController.close();
  }
}


/// Sayon Pincode Based Bloc.. For old methods uncomment below ..
/*class NetworkHospitalBloc extends BaseBloc {

  static const String TPA_CATEGORY_ALL = "";
  static const String TPA_CATEGORY_MEDI_ASSIST = "medi_assist";
  static const String TPA_CATEGORY_PARAMOUNT = "paramount";

  String currentTpaCategorySelected = TPA_CATEGORY_ALL;


  NetworkHospitalListAPiProvider _hospitalListAPiProvider = NetworkHospitalListAPiProvider();

  BehaviorSubject<String> _pinStreamController = BehaviorSubject.seeded("");
  Observable<String> get pinStream => _pinStreamController.stream.transform(NetworkHospitalValidators.getPinValidator());
  String get pin => _pinStreamController.value;

  BehaviorSubject<List<ResponseData>> _hospitalListStreamController = BehaviorSubject();
  Observable<List<ResponseData>> get hospitalListStream => _hospitalListStreamController.stream;

  BehaviorSubject<bool> _isLoadingController = BehaviorSubject.seeded(false);
  Observable<bool> get isLoadingStream => _isLoadingController.stream;
  bool get isLoading => _isLoadingController.value;

  BehaviorSubject<bool> _isFirstController = BehaviorSubject.seeded(false);
  Observable<bool> get isFirstStream => _isFirstController.stream;
  Function(bool) get changeIsFirst => _isFirstController.sink.add;
  bool get isFirst => _isFirstController.value;

  BehaviorSubject<String> _searchBoxPinErrorStreamController = BehaviorSubject();
  Observable<String> get searchBoxPinCodeErrorStream => _searchBoxPinErrorStreamController.stream;
  Function(String errorMessage) get setPinCodeErrorString => _searchBoxPinErrorStreamController.sink.add;
  String get searchBoxErrorStreamValue => _searchBoxPinErrorStreamController.value;

  BehaviorSubject<UIEvent> _eventStreamController = BehaviorSubject();
  Observable<UIEvent> get eventStream => _eventStreamController.stream;

  NetworkHospitalListModel _networkHospitalListModel;

  int pageNo = 1;
  bool shouldRequestForNextPage = true;
  List<ResponseData> _hospitalList = [];

  String _savedPinToLoadMore = "";
  bool loadMoreEnabled = false;

  void setPin(String pin) {
    return _pinStreamController.sink.add(pin);
  }

  void getHospitalList(String pin, String tpaCategory) {
    _getHospitalList(pin, tpaCategory);
  }

  void _getHospitalList(String pin, String tpaCategory) {
    if(currentTpaCategorySelected != tpaCategory) {
      currentTpaCategorySelected = tpaCategory;
      _hospitalList.clear();
      _networkHospitalListModel = null;
      pageNo = 1;
      loadMoreEnabled = false;
    }
    _savedPinToLoadMore = pin;
    if(!loadMoreEnabled) {
      _isLoadingController.add(true);
    }
    _hospitalListAPiProvider.getHospitalListApi(pin, pageNo, tpaCategory: currentTpaCategorySelected).then((parsedResponse){
      _isLoadingController.add(false);
      loadMoreEnabled = false;
      if(parsedResponse.hasData) {
        _networkHospitalListModel = parsedResponse.data;
        if(_networkHospitalListModel.success) {
          _hospitalList.addAll(parsedResponse.data.responseData);
          _hospitalListStreamController.add(_hospitalList);
        }
      } else if(parsedResponse.hasError) {
        if(parsedResponse.error.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
        }
        else if(parsedResponse.error.statusCode== ApiResponseListenerDio.MAINTENANCE){
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
        }
        else if(parsedResponse.error.statusCode== ApiResponseListenerDio.DDOS_ERROR){
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(ApiResponseListenerDio.DDOS_ERROR));
        }
        else {
          _eventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
        }
      }
    });
  }

  void fetchFreshHospitalList(String pin, String tpaCategory) {
    currentTpaCategorySelected = tpaCategory;
    _hospitalList.clear();
    _networkHospitalListModel = null;
    pageNo = 1;
    loadMoreEnabled = false;

    _getHospitalList(pin, tpaCategory);
  }

  void hospitalListTryToLoadMore() {
    if(isThereDataToLoad()) {
      if(TextUtils.isEmpty(_savedPinToLoadMore)) {
        _eventStreamController.add(SnackBarEvent("Something went wrong"));
        return;
      }
      pageNo = _getNextPageNumber();
      if(pageNo != null) {
        loadMoreEnabled = true;
        _getHospitalList(_savedPinToLoadMore, currentTpaCategorySelected);
      }
    }
  }

  bool isThereDataToLoad() {
    if(_networkHospitalListModel == null) return true;
    else {
      return !TextUtils.isEmpty(_networkHospitalListModel.data.nextPage);
    }
  }

  int _getNextPageNumber() {
    if(_networkHospitalListModel == null) return 1;
    if(TextUtils.isEmpty(_networkHospitalListModel.data.nextPage)) return null;
    Uri uri = Uri.dataFromString(_networkHospitalListModel.data.nextPage);

    Map<String, String> qParams = uri.queryParameters;
    double nextPage = double.tryParse(qParams['page']);

    if(double != null) return nextPage.toInt();
    else return null;
  }

  int getTotalSearchResult() {
    if(_networkHospitalListModel != null) {
      return _networkHospitalListModel.totalHospital;
    }
    return 0;
  }

  BehaviorSubject<bool> _searchButtonVisibility = BehaviorSubject.seeded(false);

  Observable<bool> get searchButtonVisibility => _searchButtonVisibility.stream;

  Function(bool) get changeSearchButtonVisibility => _searchButtonVisibility.sink.add;

  NetworkHospitalBloc();

  @override
  void dispose() async{
    await _pinStreamController.drain();
    _pinStreamController.close();
    await _searchButtonVisibility.drain();
    _searchButtonVisibility.close();
    await _hospitalListStreamController.drain();
    _hospitalListStreamController.close();
    await _isLoadingController.drain();
    _isLoadingController.close();
    await _eventStreamController.drain();
    _eventStreamController.close();
    await _searchBoxPinErrorStreamController.drain();
    _searchBoxPinErrorStreamController.close();
    await _isFirstController.drain();
    _isFirstController.close();
  }
}
*/
