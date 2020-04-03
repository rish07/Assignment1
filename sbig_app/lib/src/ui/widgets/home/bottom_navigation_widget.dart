import 'dart:io';

import 'package:sbig_app/src/models/widget_models/home/tab_item_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

import '../statefulwidget_base.dart';

class BottomNavigationWidget extends StatefulWidgetBase {
  final int _selectedIndex;
  final Function(int) _onItemTapped;

  BottomNavigationWidget(this._selectedIndex, this._onItemTapped);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with CommonWidget {
  List<TabItemModel> navTabList;

  @override
  void didChangeDependencies() {
    navTabList = [
      TabItemModel(
          icon: AssetConstants.ic_nav_home,
          title: S.of(context).home_tab_title,
          titleColor: Colors.grey[800],
          activeIcon: AssetConstants.ic_nav_home_white,
          activeTitleColor: Colors.white),
      TabItemModel(
          icon: AssetConstants.ic_nav_my_services,
          title: S.of(context).services_tab_title,
          titleColor: Colors.grey[800],
          activeIcon: AssetConstants.ic_nav_my_services_white,
          activeTitleColor: Colors.white),
      TabItemModel(
          icon: AssetConstants.ic_nav_benefits,
          title: S.of(context).benefits_tab_title,
          titleColor: Colors.grey[800],
          activeIcon: AssetConstants.ic_nav_benefits_white,
          activeTitleColor: Colors.white),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: buildTabList(),
                ),
              ),
            ),
          ),
        ),
      );
    }else {
      return Container(
        //color: Colors.white,
        decoration: BoxDecoration(
          color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(-0, -2),
              )],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildTabList(),
          ),
        ),
      );
    }
  }

  List<Widget> buildTabList() {
    List<Widget> list = [];
    int index = 0;
    navTabList.forEach((tabItem) {
      list.add(buildTabItem(tabItem, index++));
    });
    return list;
  }

  Widget buildTabItem(TabItemModel tabItem, int index) {

    bool isSelected = (widget._selectedIndex == index);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          widget._onItemTapped(index);
        },
        child: Card(
          elevation: (widget._selectedIndex == index)? 10:0,
          margin: EdgeInsets.only(bottom: 0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: (index == 2) ? Radius.circular(25.0) : Radius.circular(15.0),
                topRight: (index == 0) ? Radius.circular(25.0) : Radius.circular(15.0),
                bottomRight: Platform.isIOS
                    ? Radius.circular(15.0)
                    : Radius.circular(0.0),
                bottomLeft: Platform.isIOS
                    ? Radius.circular(15.0)
                    : Radius.circular(0.0)),
          ),
          child: Container(
            width: 80,
            decoration: (widget._selectedIndex == index)
                ? BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: (index == 2) ? Radius.circular(25.0) : Radius.circular(15.0),
                  topRight: (index == 0) ? Radius.circular(25.0) : Radius.circular(15.0),
                  bottomRight: Platform.isIOS
                      ? Radius.circular(15.0)
                      : Radius.circular(0.0),
                  bottomLeft: Platform.isIOS
                      ? Radius.circular(15.0)
                      : Radius.circular(0.0)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    offset: Offset(2, 10),
                    color: Colors.black26.withOpacity(.1),
                    spreadRadius: 5)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorConstants.network_hospital_gradient_color1,
                    ColorConstants.network_hospital_gradient_color2
                  ]),
            )
                : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 18,
                    width: 18,
                    child: imageWidget(
                        isSelected ? tabItem.activeIcon : tabItem.icon, null),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      tabItem.title,
                      style: TextStyle(
                          color: isSelected
                              ? tabItem.activeTitleColor
                              : tabItem.titleColor,
                          fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



//  Widget buildTabItem(TabItemModel tabItem, int index) {
//
//    bool isSelected = (widget._selectedIndex == index);
//
//    return Padding(
//      padding: const EdgeInsets.only(top: 8.0),
//      child: InkWell(
//        onTap: () {
//          widget._onItemTapped(index);
//        },
//        child: Container(
//          width: 80,
//          decoration: (widget._selectedIndex == index)
//              ? BoxDecoration(
//                  borderRadius: BorderRadius.only(
//                      topLeft: (index == 2) ? Radius.circular(25.0) : Radius.circular(15.0),
//                      topRight: (index == 0) ? Radius.circular(25.0) : Radius.circular(15.0),
//                      bottomRight: Platform.isIOS
//                          ? Radius.circular(15.0)
//                          : Radius.circular(0.0),
//                      bottomLeft: Platform.isIOS
//                          ? Radius.circular(15.0)
//                          : Radius.circular(0.0)),
//                  gradient: LinearGradient(
//                      begin: Alignment.topRight,
//                      end: Alignment.bottomLeft,
//                      colors: [
//                        ColorConstants.network_hospital_gradient_color1,
//                        ColorConstants.network_hospital_gradient_color2
//                      ]),
//                )
//              : null,
//          child: Padding(
//            padding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                SizedBox(
//                  height: 18,
//                  width: 18,
//                  child: imageWidget(
//                      isSelected ? tabItem.activeIcon : tabItem.icon, null),
//                ),
//                Padding(
//                  padding: const EdgeInsets.only(bottom: 5.0),
//                  child: Text(
//                    tabItem.title,
//                    style: TextStyle(
//                        color: isSelected
//                            ? tabItem.activeTitleColor
//                            : tabItem.titleColor,
//                        fontSize: 12),
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  EdgeInsets getPadding(){
    if(Platform.isAndroid) {
      return EdgeInsets.only(left: 15.0, top: 8.0, right: 15.0);
  }else{
      return EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0);
  }}
}
