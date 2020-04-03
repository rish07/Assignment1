import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class FaqsScreen extends StatefulWidget {
  static const ROUTE_NAME = "/services_tab/faqs_screen";

  List<PedQuestionsModel> questionAnswerList;
  FaqsScreen(this.questionAnswerList);

  @override
  _FaqsScreenState createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> with CommonWidget {
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
        appBar: getAppBar(context, S.of(context).faqs_title),
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
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_index == index) {
                                _index = -1;
                              } else {
                                _index = index;
                              }
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Card(
                                    shape: (index == 0) ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(20.0)),
                                    ) : null,
                                    elevation: 0.0,
                                    margin: EdgeInsets.all(0.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0,
                                                bottom: 12.0,
                                                left: 10.0),
                                            child: Text(
                                              filteredList[index].question ?? "",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  letterSpacing: 0.6),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(_index == index
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: (_index == index),
                                    child: Card(
                                      margin: EdgeInsets.all(0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          width: double.infinity,
                                          child: Text(
                                            filteredList[index].answer ?? "",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                shape: (index == 0) ? RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20.0)),
                                ) : null,
                                elevation: 5.0,
                                margin: EdgeInsets.all(0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, bottom: 15.0, left: 10.0),
                                        child: Text(
                                          filteredList[index].question ?? "",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              letterSpacing: 0.6),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5.0),
                                      child: Icon(_index == index
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(3.0),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  getSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
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
                        hintText: S.of(context).enter_question,
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
