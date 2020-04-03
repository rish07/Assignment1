import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

class PolicyCoverMemberWidget extends StatelessWidget with CommonWidget {

  final PolicyCoverMemberModel _policyCoverMemberModel;
  final Function() onTap;
  final bool isSelected;
  final String ageGenderString;
  final String ageString;
  final bool isAgeVisible;


  PolicyCoverMemberWidget(this._policyCoverMemberModel,{this.onTap,this.isSelected,this.ageGenderString,this.ageString,this.isAgeVisible=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkResponse(
        onTap:onTap,
        child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius(topRight: 40.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius(topRight: 40.0),
                gradient: isSelected
                    ? LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      _policyCoverMemberModel.color1,
                      _policyCoverMemberModel.color2
                    ])
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 5.0, bottom: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 30,
                        width: 30,
                        child: isSelected
                            ? Image.asset(_policyCoverMemberModel.activeIcon)
                            : Image.asset(_policyCoverMemberModel.icon)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _policyCoverMemberModel.title,
                      style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Colors.white
                              : _policyCoverMemberModel.titleColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                        visible:isAgeVisible ,
                        child: Text(ageGenderString,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 12))),
                  ],
                ),
              ),
            )),
      ),
    );
  }

}
