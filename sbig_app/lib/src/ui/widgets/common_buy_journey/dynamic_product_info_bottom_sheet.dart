import 'package:sbig_app/src/models/widget_models/common_buy_journey/dynamic_read_more_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class DynamicProductInfoReadMoreWidget extends StatelessWidget with CommonWidget {
  String title;
  Function() onClick;
  List<PedQuestionsModel> questionAnswerList;
  List<DynamicReadMoreModel> pointsList;
  bool isHavingImportantNote;
  String note;
  bool showCloseButton;
  int heightPercentage;
  bool isSubPointAvailable;

  DynamicProductInfoReadMoreWidget(this.title, this.onClick,
      {this.questionAnswerList,
      this.pointsList,
      this.isHavingImportantNote=false,
      this.note,
      this.showCloseButton=false,
      this.isSubPointAvailable=false});



  @override
  Widget build(BuildContext context) {
    void gotIt() {
      Navigator.of(context).pop();
      onClick();
    }

    if(pointsList!=null && isHavingImportantNote){
      pointsList.add(DynamicReadMoreModel((note)));
    }
    if(pointsList!=null && pointsList.length <=4) {
      if(isSubPointAvailable){
        heightPercentage=60;
      }else{
        heightPercentage = null;
      }
    } else if(pointsList!=null && pointsList.length > 4 && pointsList.length<=10) {
      heightPercentage = 60;
    }else {
      heightPercentage=null;
    }

    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Container(
                 // height: ScreenUtil.getInstance(context).screenHeightDp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(child: InkResponse(onTap: gotIt, child: Container())),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(40)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                   height: (heightPercentage !=null )?ScreenUtil.getInstance(context).screenPercentageHeight(heightPercentage):null,
                                    width: ScreenUtil.getInstance(context).screenPercentWidth(90),
                                    child: getListWidget(context)),
                                SizedBox(height: 50.0,)
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left :20.0,right: 30.0),
                  child: BlackButtonWidget(
                    gotIt,
                    S.of(context).got_it_title.toUpperCase(),
                    width: 50.0,
                    height: 40.0,
                    titleFontSize: 12,
                    isNormal: true,
                  ),
                ),

              ),
              Visibility(
                visible: showCloseButton,
                child: Container(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child:closeImageWidget(gotIt),
                        ))),
              ),
            ],
          ),
        ));
  }

  getListWidget(BuildContext context) {
    if (questionAnswerList != null) {
      return Container(
          height: ScreenUtil.getInstance(context).screenHeightDp - 190,
          child: ExpandableList(questionAnswerList));
    } else {
      return Container(
        child: Scrollbar(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: pointsList.length,
            //  physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return
                  (index == pointsList.length-1 && isHavingImportantNote)?
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          TextSpan(
                              text: S.of(context).important_note,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: ColorConstants
                                      .disco,
                                  backgroundColor: ColorConstants
                                      .london_hue)),
                          TextSpan(text: " " + pointsList[index].mainTitle),
                        ],
                      ),
                    ),
                  ):
                  Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Image.asset(
                              AssetConstants.ic_tick,
                              color: ColorConstants.disco,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              pointsList[index].mainTitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (null != pointsList[index].subPoints)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: pointsList[index].subPoints.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int i) {
                                String point = pointsList[index].subPoints[i];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6.0),
                                        child: Container(
                                          width: 5.0,
                                          height: 5.0,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),

                    ],
                  ),
                );
              }),
        ),
      );
    }
  }
}

class ExpandableList extends StatefulWidget {
  List<PedQuestionsModel> questionAnswerList;

  ExpandableList(this.questionAnswerList);

  @override
  _ExpandableListState createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  int _index = -1;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.questionAnswerList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _index = index;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.questionAnswerList[index].question,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Visibility(
                      visible: (_index == index),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Text(
                          widget.questionAnswerList[index].answer,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              ),
            );
          }),
    );
  }
}

//
//class ProductInfoBottomSheetWidget {
//  String title;
//  Function() onClick;
//  List<String> points;
//
//  ProductInfoBottomSheetWidget(this.title, this.onClick, this.points);
//
//  void showBottomSheet(BuildContext context) {
//    void gotIt() {
//      Navigator.of(context).pop();
//      onClick();
//    }
//
//    showModalBottomSheet(
//        context: context,
//        backgroundColor: Colors.transparent,
//        builder: (BuildContext context) {
//          return Padding(
//            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisSize: MainAxisSize.max,
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Container(
//                  decoration: BoxDecoration(
//                    color: Colors.white,
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(20),
//                        topRight: Radius.circular(40)),
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.all(20.0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          title,
//                          style: TextStyle(
//                              fontSize: 22,
//                              fontWeight: FontWeight.w900,
//                              color: Colors.black),
//                        ),
//                        SizedBox(
//                          height: 20,
//                        ),
//                        Container(
//                          height: 165,
//                          child: ListView.builder(
//                              shrinkWrap: true,
//                              itemCount: points.length,
//                              itemBuilder: (BuildContext context, int index) {
//                                return Padding(
//                                  padding: const EdgeInsets.only(bottom: 8.0),
//                                  child: Row(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Padding(
//                                        padding:
//                                            const EdgeInsets.only(top: 3.0),
//                                        child: Image.asset(
//                                          AssetConstants.ic_tick,
//                                          color: ColorConstants
//                                              .home_bg_gradient_color2,
//                                        ),
//                                      ),
//                                      SizedBox(
//                                        width: 10,
//                                      ),
//                                      Expanded(
//                                        child: Text(
//                                          points[index],
//                                          style: TextStyle(
//                                              fontSize: 14,
//                                              color: Colors.black,
//                                              fontWeight: FontWeight.w500),
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                );
//                              }),
//                        ),
//                        SizedBox(
//                          height: 20,
//                        ),
//                        Center(
//                          child: BlackButtonWidget(
//                            gotIt,
//                            S.of(context).got_it_title.toUpperCase(),
//                            width: 50.0,
//                            height: 40.0,
//                            titleFontSize: 12,
//                            isNormal: true,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          );
//        });
//  }
//}
