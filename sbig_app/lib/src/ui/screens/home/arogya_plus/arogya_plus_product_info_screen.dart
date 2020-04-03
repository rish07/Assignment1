import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_info_bottom_sheet.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_info_header_item.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ArogyaPlusProductInfoScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_plus/product_info_screen";

  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ArogyaPlusProductInfoScreen>
    with CommonWidget {
  double height = 100;
  ScrollController _controller;
  bool _isVisible = true;

  List<String> _childList;
  int _selectedIndex = -1;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _childList = [
      S.of(context).arogya_plus_sub_point1.toUpperCase(),
      S.of(context).arogya_plus_sub_point2.toUpperCase(),
      S.of(context).arogya_plus_sub_point3.toUpperCase(),
      S.of(context).arogya_plus_sub_point4.toUpperCase(),
      S.of(context).arogya_plus_sub_point5.toUpperCase(),
      S.of(context).arogya_plus_sub_point6.toUpperCase(),
      S.of(context).arogya_plus_sub_point7
    ];
    super.didChangeDependencies();
  }

  _scrollListener() {
    if (_controller.offset > 30) {
      setState(() {
        _isVisible = false;
      });
    } else {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: ScreenUtil.getInstance(context).screenHeightDp / 2.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                      ColorConstants.arogya_plus_product_info_gradient_color2,
                      ColorConstants.arogya_plus_product_info_gradient_color1
                    ])),
              ),
              Column(
                children: <Widget>[
                  getAppBar(
                      context, S.of(context).arogya_plus_title.toUpperCase(),
                      titleColor: Colors.white,
                      fontSize: 16.0,
                      isNormal: false,
                      letterSpacing: 1.5),
                  Expanded(
                    child: CustomScrollView(
                      controller: _controller,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        if(Platform.isAndroid) SliverAppBar(
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          expandedHeight: 130.0,
                          flexibleSpace: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: _getHeaderContainer(),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(_buildChildList()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _getQuoteButton(context),
            ],
          ),
        ));
  }

  List<Container> _buildChildList() {
    List<Container> list = List();
    int i = 0;
    for (String item in _childList) {
      list.add(_buildListItem(item, i));
      i++;
    }

    Container bottomPaddingContainer = Container(
      height: 200,
    );
    list.add(bottomPaddingContainer);

    if(Platform.isIOS){
      list.insert(0, Container(child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
        child: _getHeaderContainer(),
      ),));
    }

    return list;
  }

  Container _buildListItem(String item, int i) {
    Container child = Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: (i == 0)
              ? [
                  BoxShadow(
                    color: ColorConstants
                        .arogya_plus_product_info_gradient_color2
                        .withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(-0, -2),
                  )
                ]
              : null,
          borderRadius: (i == 0)
              ? BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0))
              : null),
      child: Padding(
        padding: EdgeInsets.only(
            left: 20.0, right: 20.0, top: (i == 0) ? 20.0 : 15.0),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = i;
            });
          },
          child: (_selectedIndex != i)
              ? Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.header_points_bg_color,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  letterSpacing: 0.6),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                )
              : _onSelected(item, i),
        ),
      ),
    );
    return child;
  }

  Widget _onSelected(String title, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Card(
          margin: EdgeInsets.all(0.0),
          elevation: 5.0,
          child: Container(
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 15.0, bottom: 5.0),
                          child: Text(
                            title.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                letterSpacing: 0.6),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(Icons.arrow_drop_up),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 10.0, right: 10.0),
                  child: _getIndexedWidget(index),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: (index != 0 && index != 5)
                            ? OutlineButton(
                                padding:
                                    EdgeInsets.only(left: 15.0, right: 15.0),
                                onPressed: () {
                                  _onReadMore(context, index);
                                },
                                highlightColor: Colors.grey.shade200,
                                child: Text(
                                  S.of(context).read_more_title.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      letterSpacing: 1.0),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onReadMore(BuildContext context, int index) {
    onClick() {}

    ProductInfoReadMoreWidget productInfoReadMoreWidget;
    switch (index) {
      case 1:
        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
            S.of(context).arogya_plus_sub_point2,
            onClick,
            StringDescription.key_features);
        break;
      case 2:
//        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
//            S.of(context).arogya_plus_sub_point3, onClick, null,
//            coverageList: StringDescription.coverageList);
        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
            S.of(context).arogya_plus_sub_point3,
            onClick,
            StringDescription.coverageList);
        break;
      case 3:
        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
          S.of(context).arogya_plus_sub_point4,
          onClick,
          StringDescription.exclusions,
          isHavingImportantNote: true,
        );
        break;
      case 4:
        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
          S.of(context).arogya_plus_sub_point5,
          onClick,
          null,
          coverageList: StringDescription.important_conditions,
        );
        break;
      case 5:
        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
            S.of(context).arogya_plus_sub_point6,
            onClick,
            StringDescription.sum_insured);
        break;
      case 6:
        productInfoReadMoreWidget = ProductInfoReadMoreWidget(
            S.of(context).arogya_plus_sub_point7, onClick, null,
            questionAnswerList: StringDescription.faqs);
        break;
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: productInfoReadMoreWidget));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: productInfoReadMoreWidget));
    }
  }

  Widget _getIndexedWidget(int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            StringDescription.about_arogya_plus,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        );
        break;
      case 1:
        return _onExpand(StringDescription.key_features, 7);
        break;
      case 2:
        return _onExpand(StringDescription.coverageList, 4);
//        return Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(
//              StringDescription.coverageList[0].mainTitle,
//              style: TextStyle(
//                fontSize: 14,
//                color: Colors.black,
//              ),
//            ),
//            if (null != StringDescription.coverageList[0].subPoints)
//              Padding(
//                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
//                child: ListView.builder(
//                    shrinkWrap: true,
//                    itemCount:
//                        StringDescription.coverageList[0].subPoints.length - 4,
//                    physics: const NeverScrollableScrollPhysics(),
//                    itemBuilder: (BuildContext context, int i) {
//                      String point =
//                          StringDescription.coverageList[0].subPoints[i];
//                      return Padding(
//                        padding: const EdgeInsets.only(top: 8.0),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Container(
//                              width: 5.0,
//                              height: 5.0,
//                              decoration: BoxDecoration(
//                                  color: Colors.black, shape: BoxShape.circle),
//                            ),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Expanded(
//                              child: Text(
//                                point,
//                                style: TextStyle(
//                                    fontSize: 14,
//                                    color: Colors.black,
//                                    fontWeight: FontWeight.w500),
//                              ),
//                            )
//                          ],
//                        ),
//                      );
//                    }),
//              ),
//            SizedBox(
//              height: 15.0,
//            )
//          ],
//        );
        break;
      case 3:
        return _onExpand(StringDescription.exclusions, 4);
        break;
      case 4:
        return _onExpand(StringDescription.important_conditions_strings, 1);
      case 5:
        return _onExpand(StringDescription.sum_insured, 0);
        break;
      case 6:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              StringDescription.faq_question1,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
              child: Text(
                StringDescription.faq_answer1,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        );
        break;
    }
  }

  _onExpand(List<String> points, int offset) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: points.length - offset,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Image.asset(
                    AssetConstants.ic_tick,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    points[index],
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _getHeaderContainer() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                child: ProductInfoHeaderItem(
                    S.of(context).arogya_plus_point1,
                    [
                      ColorConstants.pre_medical_gradient_color1,
                      ColorConstants.pre_medical_gradient_color2
                    ],
                    AssetConstants.ic_same_premium),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                child: ProductInfoHeaderItem(
                    S.of(context).arogya_plus_point2,
                    [
                      ColorConstants.maternity_gradient_color1,
                      ColorConstants.maternity_gradient_color2
                    ],
                    AssetConstants.ic_stethoscope),
              ),
            )
          ],
        ),
        Visibility(
          visible: _isVisible,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0, top: 4.0),
                  child: ProductInfoHeaderItem(
                      S.of(context).arogya_plus_point3,
                      [
                        ColorConstants.pre_medical_gradient_color1,
                        ColorConstants.pre_medical_gradient_color2
                      ],
                      AssetConstants.ic_save_tax_blue),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                  child: ProductInfoHeaderItem(
                      S.of(context).arogya_plus_point4,
                      [
                        ColorConstants.pre_medical_gradient_color1,
                        ColorConstants.pre_medical_gradient_color2
                      ],
                      AssetConstants.ic_bed),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _getQuoteButton(BuildContext context) {
    onClick() {
      Navigator.of(context).pushNamed(PersonalDetailsScreen.ROUTE_NAME,
          arguments: PersonalDetailsArguments(
              StringConstants.FROM_AROGYA_PLUS, null));
    }

    return BlackButtonWidget(
      onClick,
      S.of(context).get_a_quote_title.toUpperCase(),
      isNormal: false,
    );
  }
}
