
class ProductInfo{
  List<HeaderDataModel> headerData;
  List<SubHeaderModel> subHeaderModel;

  ProductInfo({this.headerData, this.subHeaderModel});


}

class HeaderDataModel {
  String title;
  String icon;
  HeaderDataModel({this.title, this.icon});


}
class SubHeaderModel{

  String title;
  String description;
  String displayPoints;
  bool isFAQ ;
  List<ReadMorePointsModel> readMorePoints;
  List<FAQModel> faq;

  SubHeaderModel({
    this.title, this.description, this.displayPoints, this.isFAQ,
    this.readMorePoints, this.faq
});


}


class ReadMorePointsModel{
  List<String> points;
  bool isNoteAvailable;
  String note;

  ReadMorePointsModel({
    this.points, this.isNoteAvailable, this.note
});


}

class FAQModel {
  String question;
  String answer;

  FAQModel({
    this.question, this.answer
});


}