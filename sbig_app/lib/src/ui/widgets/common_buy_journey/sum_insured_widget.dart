import 'package:flutter/material.dart';

import '../statefulwidget_base.dart';

class SumInsuredWidget extends StatelessWidget {
  String sumInsured;
  dynamic premium;
  bool isSelected;
  int index;
  bool isRecommendedVisible;
  int isFrom;

  SumInsuredWidget(this.index,
      {this.sumInsured = '',
      this.premium = '',
      this.isSelected = false,
        isRecommendedVisible=false,
      this.isFrom});

  @override
  Widget build(BuildContext context) {
    return (sumInsured != 'more') ?
    Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: double.maxFinite,
                height: 90.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    gradient: (isSelected)
                        ? LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                                ColorConstants.east_bay,
                                ColorConstants.disco,
                                ColorConstants.disco
                              ])
                        : null),
              ),
              Container(
                height: 90.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      offset: Offset(1, 5),
                                      spreadRadius: 1)
                                ]),
                            child: Center(
                                child: Container(
                                    child: Text(
                              sumInsured,
                              style: (isSelected)?
                              TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700):
                              TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                  fontStyle: FontStyle.normal),
                              textAlign: TextAlign.center,
                            ))),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Container(
                            height: 65.0,
                            margin: EdgeInsets.only(right: 15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5.0,
                                      offset: Offset(1, 5),
                                      spreadRadius: 1)
                                ]),
                            child: Container(
                                child: Center(
                              child: (premium.toString().contains('-'))?
                              Text(
                                'Contact Branch',
                                  textAlign: TextAlign.center,

                                  style:
                                  TextStyle(

                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w700),):
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: (isFrom ==StringConstants.FROM_AROGYA_TOP_UP)?'${S.of(context).deductible} - ':'${S.of(context).premium_title} - ',
                                      style: (isSelected)
                                          ? TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal)
                                          : TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontStyle: FontStyle.normal)),
                                  //TextSpan(text: CommonUtil.instance.getCurrencyFormat().format(premium), style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.w700))
                                  TextSpan(
                                      text: premium,
                                      style: (isSelected)?
                                      TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.w900):
                                      TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w600))
                                ]),
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    ):
    Column(
      children: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 50.0),
                child: Container(
                    child: new CircleAvatar(
                      child: Icon(Icons.add,color: ColorConstants.disco,size: 15.0,),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    width: 20.0,
                    height: 20.0,
                    padding: const EdgeInsets.all(2.0), // border width
                    decoration: new BoxDecoration(
                      color: ColorConstants.disco, // border color
                      shape: BoxShape.circle,
                    )
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(child: Container(child: Text('More Options'.toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12.0,letterSpacing: 1.0,fontStyle: FontStyle.normal),))),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    ) ;
  }
}
