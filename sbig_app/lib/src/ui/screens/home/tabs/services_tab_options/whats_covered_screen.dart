import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class WhatsCoveredScreen extends StatefulWidget {
  static const ROUTE_NAME = "/services_tab/whats_covered_screen";

  List<PedQuestionsModel> questionAnswerList;

  WhatsCoveredScreen(this.questionAnswerList);

  @override
  _WhatsCoveredScreenState createState() => _WhatsCoveredScreenState();
}

class _WhatsCoveredScreenState extends State<WhatsCoveredScreen> with CommonWidget {
  int _index = -1;

  List<PedQuestionsModel> questionAnswerList;
  List<PedQuestionsModel> filteredList = List();

  @override
  void initState() {
    questionAnswerList = widget.questionAnswerList;
    filteredList.addAll(questionAnswerList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.faqs_bg,
        appBar: getAppBar(context, S.of(context).whats_covered.toUpperCase()),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              getSearchBar(),
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Image.asset(
                                AssetConstants.ic_tick,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                filteredList[index].question,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  S.of(context).coverage_link,
                  style: TextStyle(
                    color: ColorConstants.claim_intimation_call_color2,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  getSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 25.0, top: 10.0),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 10.0),
                      border: InputBorder.none,
                      hintText: S.of(context).enter_here,
                      hintStyle: TextStyle(fontSize: 14.0, ),
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(20), WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9 ]")),],
                    onChanged: (text){
                      setState(() {
                        filteredList.clear();
                        filteredList = questionAnswerList.where((l) => l.question.toLowerCase().contains(text.toLowerCase())).toList();
                      });
                    },
                  ),
                ),
              ),
            ),
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            SizedBox(width: 5,)
          ],
        ),
      ),
    );
  }
}
