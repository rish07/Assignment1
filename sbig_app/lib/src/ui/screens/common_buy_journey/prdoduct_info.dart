import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/product_info/product_info_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/dynamic_read_more_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/health_product_info_header.dart';
import 'package:sbig_app/src/ui/widgets/common/loading_screen.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/dynamic_product_info_bottom_sheet.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_info_header_item.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ProductInfoScreen extends StatelessWidget {
  static const ROUTE_NAME = "/product_info_screen";

  final ProductInfoArguments productInfoArguments;

  ProductInfoScreen(this.productInfoArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: ProductInfoBloc(),
      child: ProductInfoScreenWidget(productInfoArguments.isFrom,
          productInfoArguments.productInfoResModel),
    );
  }
}

class ProductInfoScreenWidget extends StatefulWidgetBase {
  final int isFrom;
  final ProductInfoResModel productInfoResModel;

  ProductInfoScreenWidget(this.isFrom, this.productInfoResModel);

  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreenWidget>
    with CommonWidget {
  double height = 100;
  ScrollController _controller;
  bool _isVisible = true;

  int _selectedIndex = -1;
  ProductInfoBloc productInfoBloc;
  ProductInfoResModel resModel;

  List<Header> headerList = [];
  List<Body> body = [];
  bool isError = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    productInfoBloc = SbiBlocProvider.of<ProductInfoBloc>(context);
    resModel = widget.productInfoResModel ?? ProductInfoResModel();
    headerList = resModel.data?.header ?? [];
    body = resModel.data?.body ?? [];
    //_callApi(widget.isFrom);
    _listenForEvents();
    super.initState();
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
    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil.getInstance(context).screenHeightDp / 2,
                  decoration: BoxDecoration(
                      gradient: (isError)
                          ? null
                          : LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                  ColorConstants.east_bay,
                                  ColorConstants.disco,
                                  ColorConstants.disco
                                ])),
                ),
                Column(
                  children: <Widget>[
                    getAppBar(context, getTitle(widget.isFrom).toUpperCase(),
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
                          if (Platform.isAndroid)
                            SliverAppBar(
                                backgroundColor: Colors.transparent,
                                automaticallyImplyLeading: false,
                                expandedHeight: (headerList != null)
                                    ? headerList.length / 2 * 62.0
                                    : 0.0,
                                flexibleSpace: _buildHeaderContainer()
//                            Container(
//                              color: Colors.transparent,
//                              child: Padding(
//                                padding: const EdgeInsets.only(
//                                    left: 15.0, right: 15.0),
//                                //child: _getHeaderContainer(),
//                                child: GridView.count(
//                                  childAspectRatio: 3,
//                                  crossAxisCount: 2,
//                                  crossAxisSpacing: 1.0,
//                                  physics: NeverScrollableScrollPhysics(),
//                                  shrinkWrap: true,
//                                  children:
//                                  List.generate(headerList.length, (index) {
//                                    return _buildHeaderChildContainer(
//                                        headerList[index], index);
//                                  }),
//                                ),
//                              ),
//                            ),
                                ),
                          SliverList(
                            delegate:
                                SliverChildListDelegate(_buildChildList()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isError) _getQuoteButton(context),
                StreamBuilder<bool>(
                    stream: productInfoBloc.isLoadingStream,
                    builder: (context, snapshot) {
                      bool isVisible = false;
                      if (snapshot != null &&
                          (snapshot.hasData && snapshot.data)) {
                        isVisible = true;
                      }
                      return Visibility(
                        visible: isVisible,
                        child: Container(
                            color: Colors.white, child: LoadingScreen()),
                      );
                    }),
              ],
            ),
          )),
    );
  }

  _buildHeaderContainer() {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        //child: _getHeaderContainer(),
        child: GridView.count(
          childAspectRatio: 3,
          crossAxisCount: 2,
          crossAxisSpacing: 1.0,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(headerList.length, (index) {
            return _buildHeaderChildContainer(headerList[index], index);
          }),
        ),
      ),
    );
  }

  List<Container> _buildChildList() {
    List<Container> list = List();
    int i = 0;
    body.forEach((b) {
      if (b.slugType.contains(StringDescription.SLUG_LIST) ||
          b.slugType.contains(StringDescription.SLUG_FAQ)) {
        list.add(_buildListItem(b.title, i, b?.points ?? [], b));
        i++;
      }
    });
    Container bottomPaddingContainer = Container(
      height: 200,
    );
    list.add(bottomPaddingContainer);

    if (Platform.isIOS) {
      list.insert(
          0,
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20.0),
              child: _buildHeaderContainer(),
            ),
          ));
    }

    return list;
  }

  Container _buildListItem(String item, int i, List<Points> points, Body b) {
    Container child = Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: (i == 0)
              ? [
                  BoxShadow(
                    color: ColorConstants.disco.withOpacity(0.2),
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
                              item.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                )
              : _onSelected(item, i, points, b),
        ),
      ),
    );
    return child;
  }

  Widget _onSelected(String title, int index, List<Points> points, Body b) {
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
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w600),
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
                  child: _getIndexedWidget(title, index, points, b),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: (_getReadMoreVisibility(points))
                            ? OutlineButton(
                                padding:
                                    EdgeInsets.only(left: 15.0, right: 15.0),
                                onPressed: () {
                                  _onReadMore(context, index, points, b);
                                },
                                highlightColor: Colors.grey.shade200,
                                child: Text(
                                  S.of(context).read_more_title.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: ColorConstants.disco,
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

  bool _getReadMoreVisibility(List<Points> points) {
    if (points != null) {
      if (points.length > 2) {
        return true;
      } else {
        if (points.length == 1) {
          if (points[0]?.subPoints != null) {
            return true;
          }
          return false;
        }
        return false;
      }
    }
    return false;
  }

  _onReadMore(BuildContext context, int index, List<Points> points, Body b) {
    onClick() {}

    Body data = b;
    bool isNoteAvailable = false;
    String note = '';
    bool isSubPointAvailable = false;
    DynamicProductInfoReadMoreWidget dynamicProductInfoReadMoreWidget;
    if (data != null) {
      if (data.slugType.contains(StringDescription.SLUG_FAQ)) {
        List<Points> point = data?.points;
        if (point != null) {
          List<PedQuestionsModel> questions = [];
          for (int i = 0; i < point.length; i++) {
            String subPoint = '';
            if (point[i]?.subPoints != null) {
              for (int j = 0; j < point[i].subPoints.length; j++) {
                subPoint = subPoint + (point[i].subPoints[j].title) + ' ';
              }
            }
            questions.add(
                PedQuestionsModel(question: point[i].title, answer: subPoint));
          }
          dynamicProductInfoReadMoreWidget = DynamicProductInfoReadMoreWidget(
            data.title,
            onClick,
            questionAnswerList: questions,
          );
        }
      } else {
        List<DynamicReadMoreModel> list = [];

        for (int i = 0; i < data.points.length; i++) {
          List<String> sPoint = [];
          if (data.points[i].pointType
              .contains(StringDescription.SLUG_IMPORTANT_POINT)) {
            if (data.points[i]?.subPoints != null) {
              isSubPointAvailable = true;
              for (int j = 0; j < data.points[i].subPoints.length; j++) {
                isNoteAvailable = true;
                note = note + (data.points[i].subPoints[j].title) + ' ';
              }
            }
            continue;
          } else {
            if (data.points[i]?.subPoints != null) {
              isSubPointAvailable = true;
              sPoint = [];
              for (int j = 0; j < data.points[i].subPoints.length; j++) {
                sPoint.add(data.points[i].subPoints[j].title);
              }
            }
            list.add(
                DynamicReadMoreModel(data.points[i].title, subPoints: sPoint));
          }
        }

        dynamicProductInfoReadMoreWidget = DynamicProductInfoReadMoreWidget(
          data.title,
          onClick,
          pointsList: list,
          isHavingImportantNote: isNoteAvailable,
          note: note,
          isSubPointAvailable: isSubPointAvailable,
        );
      }
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: dynamicProductInfoReadMoreWidget));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: dynamicProductInfoReadMoreWidget));
    }
  }

  Widget _getIndexedWidget(
      String title, int index, List<Points> points, Body body) {
    if (points != null) {
      if (body.slugType.contains(StringDescription.SLUG_FAQ)) {
        if (points.length >= 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                points[0].title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                child: Text(
                  points[0].subPoints[0].title,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          );
        }
      } else {
        if (points.length == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              points[0].title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          );
        } else if (points.length == 0 && body.description.length > 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              body.description ?? '',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          );
        } else if (points.length > 2) {
          return _onExpand(points, points.length - 2);
        } else {
          return _onExpand(points, 0);
        }
      }
    }
  }

  _onExpand(List<Points> points, int offset) {
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
                    points[index].title,
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

  _getQuoteButton(BuildContext context) {
    onClick() {
      switch (widget.isFrom) {
        case StringConstants.FROM_CRITICAL_ILLNESS:
          Navigator.of(context).pushNamed(PersonalDetailsScreen.ROUTE_NAME,
              arguments: PersonalDetailsArguments(
                  StringConstants.FROM_CRITICAL_ILLNESS, null));
          break;
        case StringConstants.FROM_AROGYA_PREMIER:
          Navigator.of(context).pushNamed(PersonalDetailsScreen.ROUTE_NAME,
              arguments: PersonalDetailsArguments(
                  StringConstants.FROM_AROGYA_PREMIER, null));
          break;
        case StringConstants.FROM_AROGYA_TOP_UP:
          Navigator.of(context).pushNamed(PersonalDetailsScreen.ROUTE_NAME,
              arguments: PersonalDetailsArguments(
                  StringConstants.FROM_AROGYA_TOP_UP, null));
          break;
      }
    }

    return BlackButtonWidget(
      onClick,
      S.of(context).get_a_quote_title.toUpperCase(),
      isNormal: false,
    );
  }

  Widget _buildHeaderChildContainer(Header header, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
      child: ArogyaProductInfoHeaderItem(
          header?.title ?? '',
          [
            ColorConstants.pre_medical_gradient_color1,
            ColorConstants.pre_medical_gradient_color2
          ],
          header?.imagePath1 ?? ''),
    );
  }

  @override
  void dispose() {
    productInfoBloc.dispose();
    super.dispose();
  }

  String getTitle(int isFrom) {
    switch (isFrom) {
      case StringConstants.FROM_AROGYA_PREMIER:
        return S.of(context).arogya_premier;
        break;
      case StringConstants.FROM_CRITICAL_ILLNESS:
        return S.of(context).critical_illness;
        break;
      case StringConstants.FROM_AROGYA_TOP_UP:
        return S.of(context).arogya_top_up;
        break;
      default:
        return '';
    }
  }

  _listenForEvents() {
    productInfoBloc.eventStream.listen((event) {
      try {
        hideLoaderDialog(context);
        setState(() {
          isError = true;
        });
        handleApiError(
            context,
            0,
            (int retryIdentifier) {
              isError = false;
              _callApi(widget.isFrom);
            },
            event.dialogType,
            onClose: () {
              Navigator.of(context).pop();
            });
      } catch (e) {
        print("_listenForEvents " + e.toString());
      }
    });
  }

  void _callApi(int isFrom) async {
    final response = await productInfoBloc.getProductInfo(isFrom);
    setState(() {
      resModel = response ?? ProductInfoResModel();
      headerList = resModel.data?.header ?? [];
      body = resModel.data?.body ?? [];
    });
  }

  Future<bool> _backPressed() {
    Navigator.of(context).pop(true);
    return Future.value(false);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class ProductInfoArguments {
  final int isFrom;
  final ProductInfoResModel productInfoResModel;

  ProductInfoArguments(this.isFrom, this.productInfoResModel);
}
