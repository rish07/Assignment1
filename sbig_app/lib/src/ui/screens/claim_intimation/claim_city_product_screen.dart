import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/city_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/product_model.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_policy_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/drop_down_box.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ClaimCityProductScreen extends StatelessWidget {
  static const ROUTE_NAME = "/claim_intimation/claim_city_product_screen";

  final ClaimIntimationCitiesArguments claimIntimationCitiesArguments;

  ClaimCityProductScreen(this.claimIntimationCitiesArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
        child: ClaimCityProductScreenWidget(
            claimIntimationCitiesArguments.responseModel,
            claimIntimationCitiesArguments.cityList,
            claimIntimationCitiesArguments.productList),
        bloc: ClaimIntimationBloc());
  }
}

class ClaimCityProductScreenWidget extends StatefulWidget {
  final ClaimIntimationRequestModel responseModel;

  final List<CityList> cityList;
  final List<ProductList> productList;

  ClaimCityProductScreenWidget(
      this.responseModel, this.cityList, this.productList);

  @override
  _State createState() => _State();
}

class _State extends State<ClaimCityProductScreenWidget> with CommonWidget {
  String text = "Nothing to show";
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  String _selectedCity = '', _selectedProduct = '';
  bool isCitySelected = false, isProductSelected = false;
  bool cityError = false, productError = false;
  ScrollController _controller;
  bool keyboardVisible=false;
  bool productTapped=false;
  FocusNode _productFocusNode, _cityFocusNode;
  double defaultBottomHeight = 80.0;

  String cityErrorText = "", productErrorText = '';

  @override
  void initState() {
    _controller=ScrollController();
    _productFocusNode=FocusNode();
    _cityFocusNode =FocusNode();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          print('keyboard visible');
          _loadKeyboard(true);
        }else{
          _loadKeyboard(false);
        }
      },
    );
    _productFocusNode.addListener((){
      print('product focus listner called : keyboard :$keyboardVisible');
     // _scrollToDown();
      setState(() {
        defaultBottomHeight = 180.0;
      });
    });

    _cityFocusNode.addListener((){
      //_scrollToTop();
//      setState(() {
//        productTapped=false;
//        print('City Lis called , Product tapped : $productTapped');
//      });
      defaultBottomHeight = 80.0;
    });
    super.initState();
  }

  _loadKeyboard(bool visible){
    setState(() {
      keyboardVisible=visible;
    });
  }
//  _scrollToDown() {
//    _controller.animateTo(_controller.position.maxScrollExtent, curve: Curves.easeOut, duration: Duration(milliseconds: 100));
//    setState(() {
//      productTapped=true;
//      print('Product tapped : $productTapped');
//    });

//  }


//  _scrollToTop() {
//    _controller.animateTo(_controller.position.minScrollExtent, curve: Curves.easeIn, duration: Duration(milliseconds: 100));
//    setState(() {
//      productTapped=true;
//      print('Product tapped : $productTapped');
//    });
//
//  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _productController.dispose();
    _controller.dispose();
    _productFocusNode.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.claim_intimation_bg_color,
      appBar: getAppBar(
          context, S.of(context).claim_intimation_title.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
           ListView(
             controller: _controller,
             shrinkWrap: true,
             reverse: true,
             children: <Widget>[
               Column(
                 children: <Widget>[
                   /*SizedBox(
                     height: 40.0,
                   ),*/
                   Padding(
                     padding: EdgeInsets.only(left: 20, right: 20, top: 50),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         cityDropDown(),
                         SizedBox(
                           height: 5,
                         ),
                         if (cityError && cityErrorText!=null)
                           Text(
                             cityErrorText,
                             style: TextStyle(
                                 fontStyle: FontStyle.normal,
                                 fontSize: 11,
                                 color: Colors.redAccent),
                           ),
                       ],
                     ),
                   ),
                   SizedBox(
                     height: 50.0,
                   ),
                   Padding(
                     padding: EdgeInsets.only(left: 20, right: 20),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                         productDropDown(),
                         SizedBox(
                           height: 5,
                         ),
                         if (productError && productErrorText!=null)
                           Text(
                             productErrorText,
                             style: TextStyle(
                                 fontStyle: FontStyle.normal,
                                 fontSize: 11,
                                 color: Colors.redAccent),
                           ),
                       ],
                     ),
                   ),
                  //(productTapped) ?SizedBox(height: 180,):Padding(padding: EdgeInsets.all(0.0),) ,
                  SizedBox(height: defaultBottomHeight,),
                 ],
               ),
             ],
           ),
            if (isCitySelected && isProductSelected && !keyboardVisible)
              _showNextButton(),
            //Align(alignment: Alignment.bottomCenter, child: _showPremiumButton()),
          ],
        ),
      ),
    );
  }

  Widget _showNextButton() {
    onClick() {
      _selectedCity = _cityController.text;
      _selectedProduct = _productController.text;
      print('City : $_selectedCity , Product : $_selectedProduct');
      cityErrorText = _validateCity(_selectedCity);
      productErrorText = _validateProduct(_selectedProduct);
      print('City Error : $cityErrorText , Product Error : $productErrorText');

      if (cityErrorText != null) {
        setState(() {
          cityError = true;
        });
      }

      if (productErrorText != null) {
        setState(() {
          productError = true;
        });
      }

      if (cityErrorText == null && productErrorText == null) {
        _navigate(_selectedCity, _selectedProduct);
      }
    }

    return BlackButtonWidget(
      onClick,
      S.of(context).claim_next_button.toUpperCase(),
      bottomBgColor: ColorConstants.claim_intimation_bg_color,
    );
  }

  void _navigate(String selectedCity, String selectedProduct) {
    var cityId;
    this
        .widget
        .cityList
        .where((city) => city.cityName == selectedCity)
        .forEach((city) => cityId = city.id);

    var productId;
    this
        .widget
        .productList
        .where((product) => product.productName == selectedProduct)
        .forEach((product) => productId = product.id);

    ClaimIntimationRequestModel responseModel = this.widget.responseModel;
    responseModel.city = cityId.toString();
    responseModel.product = productId.toString();
    print('city & product  Screen : $responseModel');
    Navigator.of(context).pushNamed(ClaimPolicyNumberScreen.ROUTE_NAME,
        arguments: ClaimPolicyArgument(responseModel));
  }

  List<String> getCitySuggestions(String query) {
    List<String> matches = List();
    this.widget.cityList.forEach((city) {
      matches.add(city.cityName);
    });
    if(query.length==0){
      return matches;
    }
    matches.retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));
    return matches;
  }

  List<String> getProductSuggestions(String query) {
    debugPrint('getProduct suggestion : $query');
    List<String> matches = List();
    this.widget.productList.forEach((product) {
      matches.add(product.productName);
    });
    if(query.length==0){
      return matches;
    }
    matches.retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));
    return matches;
  }

  String _validateCity(String cityName) {
    var validCity =
        this.widget.cityList?.where((city) => city.cityName == cityName);
    if (cityName.isEmpty) {
      return S.of(context).please_select_city;
    } else if (validCity == null || validCity.length == 0) {
      return S.of(context).valid_city;
    }
    return null;
  }

  String _validateProduct(String productName) {
    var validProduct = this
        .widget
        .productList
        ?.where((product) => product.productName == productName);
    if (productName.isEmpty) {
      return S.of(context).please_select_product;
    } else if (validProduct == null || validProduct.length == 0) {
      return S.of(context).valid_product;
    }
    return null;
  }

  Widget cityDropDown() {
    return Theme(
      data: new ThemeData(
          primaryColor: Colors.black45,
          accentColor: Colors.black,
          hintColor: Colors.black),
      child: TypeAheadFormField(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._cityController,
            focusNode: _cityFocusNode,
            maxLines: 1,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
            ],
            style: TextStyle(
                letterSpacing: 0.5,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
              ),
              border: OutlineInputBorder(
                  borderRadius:
                      borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                  borderSide:
                      BorderSide(color: ColorConstants.claim_remark_color)),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                    BorderSide(color: ColorConstants.claim_remark_color),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                    BorderSide(color: ColorConstants.claim_dropdown_color),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                    BorderSide(color: ColorConstants.claim_dropdown_color),
              ),
              labelText: S.of(context).select_city.toUpperCase(),
              labelStyle: TextStyle(
                  letterSpacing: 0.5,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            )),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 0.5,
        ),
        suggestionsCallback: (pattern) {
        debugPrint('city pattern : $pattern');
          if (pattern.length == 0) {
            return getCitySuggestions('');
          } else {
            return getCitySuggestions(pattern);
          }
        },
        itemBuilder: (context, suggestion) {
          return Padding(
            padding: EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 8),
            child: Text(
              suggestion,
              textAlign: TextAlign.start,
              style: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.claim_drop_down_text),
            ),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this._cityController.text = suggestion;
          setState(() {
            isCitySelected = true;
            cityErrorText=" ";
          });
        },
      ),
    );
  }

  Widget productDropDown() {
    return Theme(
      data: new ThemeData(
          primaryColor: Colors.black45,
          accentColor: Colors.black,
          hintColor: Colors.black),
      child: TypeAheadFormField(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._productController,
            focusNode: _productFocusNode,
            maxLines: null,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
            ],
            style: TextStyle(
                letterSpacing: 0.5,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
              ),
              border: OutlineInputBorder(
                  borderRadius:
                  borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                  borderSide:
                  BorderSide(color: ColorConstants.claim_remark_color)),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                BorderSide(color: ColorConstants.claim_remark_color),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                BorderSide(color: ColorConstants.claim_dropdown_color),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                BorderSide(color: ColorConstants.claim_dropdown_color),
              ),
              labelText: S.of(context).select_product.toUpperCase(),
              labelStyle: TextStyle(
                  letterSpacing: 0.5,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 12),
            )),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 0.5,
        ),
        suggestionsCallback: (pattern) {
          debugPrint('product pattern : $pattern');
          if (pattern.length == 0) {
            return getProductSuggestions('');
          } else {
            return getProductSuggestions(pattern);
          }
        },
        itemBuilder: (context, suggestion) {
          return Padding(
            padding: EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 8),
            child: Text(
              suggestion,
              textAlign: TextAlign.start,
              style: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.claim_drop_down_text),
            ),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this._productController.text = suggestion;
          setState(() {
            isProductSelected = true;
            productErrorText="  ";
          });
        },
      ),
    );
  }

}

class ClaimIntimationCitiesArguments {
  final ClaimIntimationRequestModel responseModel;

  final List<CityList> cityList;
  final List<ProductList> productList;

  ClaimIntimationCitiesArguments(
      this.responseModel, this.cityList, this.productList);
}
