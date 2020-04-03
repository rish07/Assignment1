import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


final SharedPrefsHelper prefsHelper =  SharedPrefsHelper();

class SharedPrefsHelper{

  static final SharedPrefsHelper _instance = SharedPrefsHelper._internal();

  factory SharedPrefsHelper() {
    return _instance;
  }

  SharedPrefsHelper._internal();

  SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    return 0;
  }

  String getToken() {
    return _prefs.getString(StringConstants.TOKEN);
  }

  Future<bool> setToken(String token) {
    return _prefs.setString(StringConstants.TOKEN, token);
  }

  String getUserName() {
    return _prefs.getString(StringConstants.USER_NAME);
  }

  Future<bool> setUserName(String token) {
    return _prefs.setString(StringConstants.USER_NAME, token);
  }

  Future<bool> setMobileNo(String mobile) {
    return _prefs.setString(StringConstants.LOGGED_IN_MOBILE_NO, mobile);
  }

  String getMobileNo() {
    return _prefs.getString(StringConstants.LOGGED_IN_MOBILE_NO);
  }


  int getRedirection() {
    return _prefs.getInt(StringConstants.REDIRECTION);
  }

  Future<bool> setRedirection(int redirection) {
    return _prefs.setInt(StringConstants.REDIRECTION, redirection);
  }

  setUserIsLoggedIn(bool loggedIn) {
    _prefs.setBool(StringConstants.IS_USER_LOGGED_IN, loggedIn);
  }

  setAlertShown(bool isAlertShown) {
    _prefs.setBool(StringConstants.IS_ALERT_SHOWN, isAlertShown);
  }

  setIsReloadRequired(bool isReloadRequired) {
    _prefs.setBool(StringConstants.IS_RELOAD_REQUIRED, isReloadRequired);
  }

  setUserIsLinkedPolicy(bool isLinkedPolicy) {
    _prefs.setBool(StringConstants.IS_USER_LINKED_POLICY, isLinkedPolicy);
  }

  void setDocPrimeUserDataAvailable(bool isAvailable) {
    _prefs.setBool(StringConstants.DOC_PRIME_USER_DATA_AVAILABILITY, isAvailable);
  }

  bool isDocPrimeUserDataAvailable() {
    return _prefs.getBool(StringConstants.DOC_PRIME_USER_DATA_AVAILABILITY);
  }

  bool isUserLoggedIn() {
    bool isUserLoggedIn = _prefs.getBool(StringConstants.IS_USER_LOGGED_IN);
    return isUserLoggedIn != null ? isUserLoggedIn : false;
  }

  bool isReloadRequired() {
    bool isReloadRequired = _prefs.getBool(StringConstants.IS_RELOAD_REQUIRED);
    return isReloadRequired != null ? isReloadRequired : false;
  }

  bool isAlertShown() {
    bool isAlertShown = _prefs.getBool(StringConstants.IS_ALERT_SHOWN);
    return isAlertShown != null ? isAlertShown : false;
  }

  bool isUserLinkedPolicy() {
    bool isUserLinkedPolicy = _prefs.getBool(StringConstants.IS_USER_LINKED_POLICY);
    return isUserLinkedPolicy != null ? isUserLinkedPolicy : false;
  }

  bool isFirstTimeLaunch() {
    bool firstAppLaunch = _prefs.getBool(StringConstants.FIRST_TIME_APP_LAUNCH);
    if(firstAppLaunch == null) return true;
    return !firstAppLaunch;
  }

  void setToFirstTimeLaunchDone() {
    _prefs.setBool(StringConstants.FIRST_TIME_APP_LAUNCH, true);
  }

  int getApiHitCount() {
    return _prefs.getInt(StringConstants.API_HIT_COUNT);
  }

  String getApiHitDateTime() {
    return _prefs.getString(StringConstants.API_HIT_DATE);
  }

  Future<bool> setApiHitCount(int count) {
    return _prefs.setInt(StringConstants.API_HIT_COUNT, count);
  }

  Future<bool> setApiHitDateTime(DateTime dateTime) {
    return _prefs.setString(StringConstants.API_HIT_DATE,
        null != dateTime ? dateTime.toString() : null);
  }

  bool isFirstTimeNetworkHospital() {
    bool firstLaunch = _prefs.getBool(StringConstants.NETWORK_HOSPITAL_LAUNCH);
    if(firstLaunch == null) return true;
    return !firstLaunch;
  }

  void setToFirstNetworkHospitalDone() {
    _prefs.setBool(StringConstants.NETWORK_HOSPITAL_LAUNCH, true);
  }

  void setLoaderMessage(List<String> loaderMessage){
    _prefs.setStringList(StringConstants.LOADER_MESSAGE, loaderMessage);
  }

  List<String> getLoaderMessages(){
    return _prefs.getStringList(StringConstants.LOADER_MESSAGE);
  }

  void setLoaderMessageDate(String date){
    _prefs.setString(StringConstants.LOADER_MESSAGE_DATE, date);
  }

  String getLoaderDate(){
    return _prefs.getString(StringConstants.LOADER_MESSAGE_DATE);
  }

  void setLoaderIndex(int index){
    _prefs.setInt(StringConstants.LOADER_MESSAGE_INDEX, index);
  }

  int getLoaderIndex(){
    return _prefs.getInt(StringConstants.LOADER_MESSAGE_INDEX);
  }
}
