import 'package:flutter/material.dart';

class PageIndicatorWidget extends StatefulWidget {
  final _totalItems;
  final int _initialPosition;
  final Color _color;
  final Color _colorActive;
  final double sizeWidth;

  final PageIndicatorController _pageIndicatorController;

  PageIndicatorWidget(this._totalItems, this._initialPosition, this._color,
      this._colorActive, this.sizeWidth, this._pageIndicatorController);

  @override
  _PageIndicatorWidgetState createState() => _PageIndicatorWidgetState();
}

class _PageIndicatorWidgetState extends State<PageIndicatorWidget> {
  int selectedPosition;
  double gap = 3;

  @override
  void initState() {
    selectedPosition = widget._initialPosition;
    widget._pageIndicatorController.addPageChangeListener((curPage) {
      setState(() {
        if (curPage < widget._totalItems) {
          selectedPosition = curPage;
        } else {
          debugPrint(
              "Invalid position. Page count is smaller than current page");
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: _calculateWidth(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget._totalItems,
        itemBuilder: (context, index) {
          return Row(
            children: <Widget>[
              _bar(index == selectedPosition),
              SizedBox(width: gap)
            ],
          );
        },
      ),
    );
  }

  AnimatedContainer _bar(isSelected) {
    Color color = isSelected ? widget._colorActive : widget._color;
    double width = isSelected ? widget.sizeWidth : widget.sizeWidth * .75;
    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: color));
  }

  double _calculateWidth() {
    double width = 0;
    for (int i = 0; i < widget._totalItems; i++) {
      if (i == 0) {
        width = width + widget.sizeWidth + gap;
      } else {
        width = width + widget.sizeWidth * 0.75 + gap;
      }
    }
    return width;
  }

  @override
  void dispose() {
    widget._pageIndicatorController.removePageChangeListener();
    super.dispose();
  }
}

class PageIndicatorController {
  Function(int) _pageChangeListener;
  bool hasListener;

  void addPageChangeListener(Function(int) listener) {
    _pageChangeListener = listener;
    hasListener = true;
  }

  void notifyPageChange(int currentPage) {
    if (_pageChangeListener != null) {
      _pageChangeListener(currentPage);
    }
  }

  void removePageChangeListener() {
    _pageChangeListener = null;
    hasListener = false;
  }
}
