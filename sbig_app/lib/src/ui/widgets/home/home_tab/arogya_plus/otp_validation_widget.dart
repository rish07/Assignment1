import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:sbig_app/src/utilities/text_utils.dart';

class VerificationCodeInput extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final TextInputType keyboardType;
  final int length;
  final double itemSize;
  final BoxDecoration itemDecoration;
  final TextStyle textStyle;
  final bool autofocus;
  final Color lableTextStyleColor;
  final ThemeData themeData;
  final OtpFieldController otpFieldController;
  final firstDigitFocusNode;

  VerificationCodeInput({
    Key key,
    this.onCompleted,
    this.keyboardType = TextInputType.number,
    this.length = 4,
    this.itemDecoration,
    this.itemSize = 50,
    this.textStyle = const TextStyle(fontSize: 25.0, color: Colors.black),
    this.autofocus = true,
    this.lableTextStyleColor,
    this.themeData,
    this.otpFieldController,
    this.firstDigitFocusNode,
  })  : assert(length > 0),
        assert(itemSize > 0),
        super(key: key);

  @override
  _VerificationCodeInputState createState() =>
      new _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  final List<FocusNode> _listFocusNode = <FocusNode>[];
  final List<TextEditingController> _listControllerText =
      <TextEditingController>[];
  List<String> _code = List();
  int _currentIdex = 0;

  //final String _blankUnicode = '\uFEFF';
  String _blankUnicode = " ";

  @override
  void initState() {
    if (Platform.isIOS) {
      _blankUnicode = '\u00A0';
    } else {
      _blankUnicode = '\uFEFF';
    }
    if (_listFocusNode.isEmpty) {
      for (var i = 0; i < widget.length; i++) {
        if (i == 0 && null != widget.firstDigitFocusNode) {
          _listFocusNode.add(widget.firstDigitFocusNode);
        } else {
          _listFocusNode.add(FocusNode());
        }
        _listControllerText.add(TextEditingController());
        _code.add(_blankUnicode);
      }
    }
    _listFocusNode.asMap().forEach((index, focusNode) {
      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          String currentText = _listControllerText[index].text;
          if (TextUtils.isEmpty(currentText)) {
            _listControllerText[index].value =
                TextEditingValue(text: _blankUnicode);
          }
        } else {
          String currentText = _listControllerText[index].text;
          if (currentText == _blankUnicode) {
            _listControllerText[index].value = TextEditingValue(text: '');
          }
        }
      });
    });
    if (widget.otpFieldController != null) {
      widget.otpFieldController.addListener((OtpFieldControllerAction action) {
        switch (action) {
          case OtpFieldControllerAction.CLEAR_FIELDS:
            _listControllerText.forEach((cont) {
              cont.text = '';
            });
            _listFocusNode.asMap().forEach((index, focusNode) {
              if (index != 0 && focusNode.hasFocus) {
                focusNode.unfocus();
                FocusScope.of(context).requestFocus(_listFocusNode[0]);
                return;
              }
            });
            break;
        }
      });
    }
    super.initState();
  }

  String _getInputVerify() {
    String verifyCode = '';
    for (var i = 0; i < widget.length; i++) {
      for (var index = 0; index < _listControllerText[i].text.length; index++) {
        if (_listControllerText[i].text[index] != _blankUnicode) {
          verifyCode += _listControllerText[i].text[index];
        }
      }
    }
    return verifyCode;
  }

  Widget _buildInputItem(int index) {
    bool border = (widget.itemDecoration == null);

    return Theme(
      data: ((widget.themeData) != null)
          ? widget.themeData
          : ThemeData(accentColor: Colors.black),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        maxLines: 1,
        maxLength: 3,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp('[0-9$_blankUnicode]')),
        ],
        focusNode: _listFocusNode[index],
        decoration: InputDecoration(
            border: ((!border)
                ? widget.itemDecoration
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.lableTextStyleColor))),
            enabledBorder: ((!border)
                ? widget.itemDecoration
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.lableTextStyleColor))),
            focusedErrorBorder: ((!border)
                ? widget.itemDecoration
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.lableTextStyleColor))),
            focusedBorder: ((!border)
                ? widget.itemDecoration
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.lableTextStyleColor))),
            disabledBorder: ((!border)
                ? widget.itemDecoration
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: widget.lableTextStyleColor))),
            enabled: _currentIdex == index,
            counterText: "",
            contentPadding: EdgeInsets.all(((widget.itemSize * 2) / 10)),
            errorMaxLines: 1,
            fillColor: Colors.black),
//            inputFormatters: [
//              WhitelistingTextInputFormatter.digitsOnly
//            ],
        onChanged: (String value) {
          _onOtpValueChange(index, value);
        },
        controller: _listControllerText[index],
        maxLengthEnforced: true,
        autocorrect: false,
        textAlign: TextAlign.center,
        autofocus: widget.autofocus,
        style: widget.textStyle,
      ),
    );
  }

  void _onOtpValueChange(int index, String value) {
    var split = value.replaceAll(_blankUnicode, '');
    var newVal = split.split('');

    print("newVal length " + newVal.length.toString());
    print("newVal length " + newVal.toString());

    if (newVal.length == 2) {
      String lastVal = newVal.last;
      String firstVal = newVal.first;

      if (_code[index].contains(lastVal)) {
        String text = _blankUnicode + firstVal;
        _listControllerText[index].value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length));
        value = firstVal;
      } else if (_code[index].contains(firstVal)) {
        String text = _blankUnicode + lastVal;
        _listControllerText[index].value = TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length));
        value = lastVal;
      }
    }

//    if(index == 0) {
//      if(value.length == 1 && value != _blankUnicode) {
//        _listControllerText[0].value = TextEditingValue(text: _blankUnicode + value);
//      }
//    }
    if (!TextUtils.isEmpty(value)) {
      if (index < widget.length - 1) {
        _next(index);
      }
      _code[index] = value;
      final String currentOtpValue = _getInputVerify().trim();
      if (currentOtpValue.length == widget.length) {
        //_listControllerText[index].selection = TextSelection.collapsed(offset: _listControllerText[index].text.length, affinity: TextAffinity.downstream);
//        TextSelection previousSelection = _listControllerText[index].selection;
//        _listControllerText[index].text = _listControllerText[index].text;
//        _listControllerText[index].selection = previousSelection;
//        _listControllerText[index].value =
//            _listControllerText[index].value.copyWith(
//              text: _listControllerText[index].text,
//              selection: TextSelection(
//                  baseOffset: _listControllerText[index].text.length,
//                  extentOffset: _listControllerText[index].text.length),
//              composing: TextRange.empty,
//            );
        // _listFocusNode[index].unfocus();
        widget.onCompleted(currentOtpValue);
        return;
      } else {
        widget.onCompleted('-1');
      }
    } else {
      widget.onCompleted('-1');
      _code[index] = _blankUnicode;
      _prev(index);
    }
  }

  void _next(int index) {
    print("_nextIndex " + index.toString());
    if (index != widget.length) {
      setState(() {
        _currentIdex = index + 1;
      });
      _listFocusNode[index].unfocus();
      FocusScope.of(context).requestFocus(_listFocusNode[index + 1]);
    }
  }

  void _prev(int index) {
    print("_prevIndex " + index.toString());
    if (index > 0) {
      setState(() {
        _currentIdex = index - 1;
      });
      _listFocusNode[index].unfocus();
      FocusScope.of(context).requestFocus(_listFocusNode[index - 1]);
    }
  }

  List<Widget> _buildListWidget() {
    List<Widget> listWidget = List();
    for (int index = 0; index < widget.length; index++) {
      double left = (index == 0) ? 0.0 : (widget.itemSize / 10);
      listWidget.add(Container(
          height: widget.itemSize,
          width: widget.itemSize,
          margin: EdgeInsets.only(left: left),
          decoration: widget.itemDecoration,
          child: _buildInputItem(index)));
    }
    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _buildListWidget(),
    );
  }
}

class OtpFieldController {
  Function(OtpFieldControllerAction action) listener;

  void addListener(Function(OtpFieldControllerAction action) listener) {
    this.listener = listener;
  }

  void removeListener() {
    this.listener = null;
  }

  void clearFields() {
    if (listener != null) {
      listener(OtpFieldControllerAction.CLEAR_FIELDS);
    }
  }
}

enum OtpFieldControllerAction { CLEAR_FIELDS }
