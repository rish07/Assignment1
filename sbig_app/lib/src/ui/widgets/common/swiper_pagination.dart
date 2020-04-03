import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CustomPaginationBuilder extends SwiperPlugin {
  final Color activeColor;
  final Color color;
  final Size activeSize;
  final Size size;
  final double space;

  final Key key;

  const CustomPaginationBuilder(
      {this.activeColor,
      this.color,
      this.key,
      this.size: const Size(2.0, 10.0),
      this.activeSize: const Size(2.0, 10.0),
      this.space: 2.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    List<Widget> list = [];

    if (config.itemCount > 20) {
      print(
          "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this situation");
    }

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      Size size = active ? this.activeSize : this.size;
      list.add(SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          decoration: BoxDecoration(
              color: active ? activeColor : color,
              borderRadius: BorderRadius.circular(10.0)),
          key: Key("pagination_$i"),
          margin: EdgeInsets.all(space),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.max,
        children: list,
      );
    } else {
      return Container(
        margin: EdgeInsets.only(left: 8.0, bottom: 35.0),
        child: Row(
          key: key,
          mainAxisSize: MainAxisSize.max,
          children: list,
        ),
      );
    }
  }
}
