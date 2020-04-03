// https://github.com/OpenFlutter/flutter_screenutil
import 'package:flutter/material.dart';

class ScreenUtil {
  static ScreenUtil instance = ScreenUtil();

  // Size of the phone in UI Design , px
  double width;
  double height;

  // allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is false.
  bool allowFontScaling;

  static MediaQueryData _mediaQueryData;
  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;

  static double _bottomBarHeight;

  static double _textScaleFactor;

  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;


  ScreenUtil({
    this.width = 1080,
    this.height = 1920,
    this.allowFontScaling = false,
  });

  static ScreenUtil getInstance(BuildContext context) {
    return instance = ScreenUtil._(context);
  }

  ScreenUtil._(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;

    blockSizeHorizontal = _screenWidth / 100;
    blockSizeVertical = _screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;

    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (_screenWidth -
        _safeAreaHorizontal) / 100;

    safeBlockVertical = (_screenHeight -
        _safeAreaVertical) / 100;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;

  // The number of font pixels for each logical pixel.
  static double get textScaleFactory => _textScaleFactor;

  // The size of the media in logical pixels (e.g, the size of the screen).
  static double get pixelRatio => _pixelRatio;

  // The horizontal extent of this size.
  double get screenWidthDp => _screenWidth;

  // The vertical extent of this size. dp
  double get screenHeightDp => _screenHeight;

  // The vertical extent of this size. px
  double get screenWidth => _screenWidth * _pixelRatio;

  // The vertical extent of this size. px
  double get screenHeight => _screenHeight * _pixelRatio;

  // The offset from the top
  static double get statusBarHeight => _statusBarHeight;

  // The offset from the bottom.
  static double get bottomBarHeight => _bottomBarHeight;

  // The ratio of the actual dp to the design draft px
  get scaleWidth => _screenWidth / instance.width;

  get scaleHeight => _screenHeight / instance.height;

  // Adapted to the device width of the UI Design.
  // Height can also be adapted according to this to ensure no deformation ,
  // if you want a square
  setWidth(num width) => width * scaleWidth;

  // Highly adaptable to the device according to UI Design
  // It is recommended to use this method to achieve a high degree of adaptation
  // when it is found that one screen in the UI design
  // does not match the current style effect, or if there is a difference in shape.
  setHeight(num height) => height * scaleHeight;

  //Font size adaptation method
  //@param [fontSize] The size of the font on the UI design, in px.
  //@param [allowFontScaling]
  setSp(num fontSize) => allowFontScaling
      ? setWidth(fontSize)
      : setWidth(fontSize) / _textScaleFactor;

  double screenPercentWidth(int percent) => safeBlockHorizontal * percent;

  double screenPercentageHeight(int percent) => safeBlockVertical * percent;

}