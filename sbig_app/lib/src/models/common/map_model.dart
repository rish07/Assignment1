

class MapModel{
  final String key;
  final String value;
  final List<MemberModel> subValueList;

  MapModel(this.key, {this.value, this.subValueList});
}

class MemberModel{
  final String relation;
  final String details;
  String sumInsured ;
  String deduction;

  MemberModel(this.relation, this.details,{this.sumInsured,this.deduction});
}