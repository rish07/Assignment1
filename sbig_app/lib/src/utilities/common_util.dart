import 'dart:core';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class CommonUtil {
  static CommonUtil instance = CommonUtil();

  final formatCurrency = NumberFormat.simpleCurrency(name: "INR", decimalDigits: 0);

  final RegExp digitFormatter = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  final RegExp panCardFormatter =
  new RegExp(r'^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$');

  final RegExp eiaNumberFormatter =
  new RegExp(r'^[1245][0-9]{11}$');


  getCurrencyFormat() {
    return formatCurrency;
  }

  String getFormattedCurrency(String value) {
    Function mathFunc = (Match match) => '${match[1]},';
    return value.replaceAllMapped(digitFormatter, mathFunc);
  }

  static Future<bool> openMap(String latitude, String longitude,
      String hospitalName, String location) async {
//    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String googleUrl = "";
    if (Platform.isAndroid) {
      if(!TextUtils.isEmpty(latitude) && !TextUtils.isEmpty(longitude)){
        googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      }else{
        googleUrl = 'https://www.google.com/maps/search/?api=1&query=$hospitalName+$location';
      }

      print('googleUrl $googleUrl');

    } else {
      String address = Uri.encodeFull("$hospitalName+$location");
      googleUrl = "http://maps.apple.com/?q=$address";
    }
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
      return true;
    } else {
      return false;
    }
  }

  String getCurrrencyFormattedString(double amount){
    try {
      return getCurrencyFormat().format(amount);
    }catch(e){
      return "$amount";
    }
  }

  convertTo_yyyy_MM_dd(DateTime dateTime) {
    try {
      return DateFormat("yyyy-MM-dd").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  convertTo_dd_MMM_yyyy(DateTime dateTime) {
    try {
      return DateFormat("dd MMM yyyy").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  convertTo_dd_MM_yyyy(DateTime dateTime) {
    try {
      return DateFormat("dd/MM/yyyy").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  convertTo_ddMMyyyy(DateTime dateTime) {
    try {
      return DateFormat("dd-MM-yyyy").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  convertTo_dd_MMM_yyyy_hhmm(DateTime dateTime) {
    try {
      return DateFormat("dd, MMM yyyy hh:mm a").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  convertTo_Cm(int inch, int feet) {
    /// 1 inch = 2.54  cm
    int _inch = inch ?? 0;
    int _foot = feet ?? 0;
    var totalFeet = (_foot * 12) + _inch;
    var total = (totalFeet * 2.54).round() ?? 0;
    return (total);
  }

  convertToMeter(int inch, int feet) {
    /// 1 inch = 2.54  cm
    int _inch = inch ?? 0;
    int _foot = feet ?? 0;
    var totalFeet = (_foot * 12) + _inch;
    var total = ((totalFeet * 2.54)/100).round()?? 0;
    return (total);
  }

  String generateSha256Hexa(String input) {
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString();
//    return md5.convert(utf8.encode(input)).toString();
  }


  DateTime parseDateYYYY_MM_DD_TIME(String date){
    //ex:2019-08-31 23:59:00.0
    try {
      return DateTime.parse(date);
    }catch(e){
      return null;
    }
  }

  convertSumInsured(dynamic sumInsured){
    if(sumInsured!=null){
      if(sumInsured.toString().length == 6){
        return '${sumInsured.toString().substring(0,1)} Lakhs';

      }else if(sumInsured.toString().length == 7){

        return '${sumInsured.toString().substring(0,2)} Lakhs';
      }else {
        return '${sumInsured.toString()} Lakhs';
      }
    }
    return '0 Lakhs';
  }

  convertSumInsuredWithRupeeSymbol (dynamic sumInsured){
    int amount=0;
    String value ='0 Lakhs';
    var amt =sumInsured.toString().replaceRange(sumInsured.toString().length-5,sumInsured.toString().length ,'');
    try{
      amount = int.parse(amt);
      if(amount <=1){
        value = getCurrencyFormat().format(amount)+' Lakh';
      }else{
        value=getCurrencyFormat().format(amount)+' Lakhs';
      }
    }catch(e){
      amount=sumInsured;
      if(amount <=1){
        value =getCurrencyFormat().format(amount)+' Lakh';
      }else{
        value=getCurrencyFormat().format(amount)+' Lakhs';
      }
      return value;
    }
    return value;
  }

  calculateBMI(var inch, var feet ,var weight ){
    print('int inch, int feet int weight : $inch,$feet ,$weight');
    var _height =convertTo_Cm(inch,feet)/100 ??0;
    print('HEIGHT IN CM   : $_height');
    print('HEIGHT IN M   : ${_height/100}');
    var _weight = weight??0;
    var h =  (_height *_height);
    print('HEIGHT IN M2   : ${h}');
    var bmi = (_weight / h) ?? 0;
    print('BMI : $bmi');
    return bmi;
  }

}

