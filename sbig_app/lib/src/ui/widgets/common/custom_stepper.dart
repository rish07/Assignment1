import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

enum CustomStepState {
  indexed,
  disabled,
  error,
  policyDetails,
  hospitalDetails,
  paymentDetails,

}
enum CustomStepperType {
  vertical,
  horizontal,
}

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 48.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

///  * <https://material.io/archive/guidelines/components/steppers.html>
@immutable
class CustomStep {
  const CustomStep({
    this.title,
    this.subtitle,
    @required this.content,
    this.state = CustomStepState.indexed,
    this.isActive = false,
  })
      : assert(title != null),
        assert(content != null),
        assert(state != null);
  final Widget title;
  final Widget subtitle;
  final Widget content;
  final CustomStepState state;
  final bool isActive;
}

/// A material stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// See also:
///
///  * [Step]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class CustomStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps], [type], and [currentStep] arguments must not be null.
  const CustomStepper({
    Key key,
    @required this.customsteps,
    this.physics,
    this.type = StepperType.horizontal,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  })
      : assert(currentStep != null),
        assert(type != null),
        assert(currentStep != null),
        assert(0 <= currentStep && currentStep < customsteps.length),
        super(key: key);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<CustomStep> customsteps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final StepperType type;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int> onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback onStepCancel;

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and two functions,[onStepContinue]
  /// and [onStepCancel]. These can be used to control the stepper.
  ///
  /// {@tool snippet --template=stateless_widget_scaffold}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
  ///          return Row(
  ///            children: <Widget>[
  ///              FlatButton(
  ///                onPressed: onStepContinue,
  ///                child: const Text('CONTINUE'),
  ///              ),
  ///              FlatButton(
  ///                onPressed: onStepCancel,
  ///                child: const Text('CANCEL'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final ControlsWidgetBuilder controlsBuilder;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper>
    with TickerProviderStateMixin {
  List<GlobalKey> _keys;
  final Map<int, CustomStepState> _oldStates = <int, CustomStepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.customsteps.length,
          (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.customsteps.length; i += 1)
      _oldStates[i] = widget.customsteps[i].state;
  }

/*
  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.customsteps.length == oldWidget.customsteps.length);

    for (int i = 0; i < oldWidget.customsteps.length; i += 1)
      _oldStates[i] = oldWidget.customsteps[i].state as CustomStepState;
  }
*/

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.customsteps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isDark() {
    return Theme
        .of(context)
        .brightness == Brightness.dark;
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 16.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final CustomStepState state =
    oldState ? _oldStates[index] : widget.customsteps[index].state;
    final bool isDarkActive = _isDark() && widget.customsteps[index].isActive;
    assert(state != null);
    switch (state) {
      case CustomStepState.indexed:
      case CustomStepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case CustomStepState.error:
        return const Text('!', style: _kStepStyle);
      case CustomStepState.policyDetails:
        return Image.asset(AssetConstants.ic_nav_my_services_white);
      case CustomStepState.hospitalDetails:
        return Image.asset(AssetConstants.ic_hospital_details);
      case CustomStepState.paymentDetails:
        return Image.asset(AssetConstants.ic_payment_details);

    }
    return null;
  }

  Color _circleColor(int index) {
    final ThemeData themeData = Theme.of(context);
    if (!_isDark()) {
      return widget.customsteps[index].isActive
          ? ColorConstants.fuchsia_pink
          : Colors.transparent;
    } else {
      return widget.customsteps[index].isActive
          ? themeData.accentColor
          : themeData.backgroundColor;
    }
  }

  Widget _buildCircle(int index, bool oldState) {
    if (_isCurrent(index))
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        width: _kStepSize,
        height: _kStepSize,
        child: AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: kThemeAnimationDuration,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  ColorConstants.chathams_blue,
                  ColorConstants.disco
                ]),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: _buildCircleChild(
                  index,
                  oldState &&
                      widget.customsteps[index].state == CustomStepState.error),
            ),
          ),
        ),
      );
    if (!_isCurrent(index) && widget.customsteps[index].isActive)
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: 19,
        height: 19,
        child: AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: kThemeAnimationDuration,
          decoration:
          BoxDecoration(color: _circleColor(index), shape: BoxShape.circle),
          /*child: Center(
            child: _buildCircleChild(
                index,
                oldState &&
                    widget.customsteps[index].state == CustomStepState.error),
          ),*/
        ),
      );

    if (!_isCurrent(index) && !widget.customsteps[index].isActive)
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        width: 18,
        height: 18,
        child: DottedBorder(
          color: ColorConstants.fuchsia_pink,
          borderType: BorderType.Circle,
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: kThemeAnimationDuration,
            decoration: BoxDecoration(
                color: _circleColor(index), shape: BoxShape.circle),
            /*child: Center(
              child: _buildCircleChild(
                  index,
                  oldState &&
                      widget.customsteps[index].state == CustomStepState.error),
            ),*/
          ),
        ),
      );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: Center(
        child: SizedBox(
          width: _kStepSize,
          height: _kTriangleHeight,
          // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(0.0, 0.8),
              // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(
                  index,
                  oldState &&
                      widget.customsteps[index].state != CustomStepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.customsteps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.customsteps[index].state == CustomStepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.customsteps[index].state != CustomStepState.error)
        return _buildCircle(index, false);
      /* else
        return _buildTriangle(index, false);*/
    }
  }

  Widget _buildVerticalControls() {
    if (widget.controlsBuilder != null)
      return widget.controlsBuilder(context,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel);

    Color cancelColor;

    switch (Theme
        .of(context)
        .brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        break;
      case Brightness.dark:
        cancelColor = Colors.white70;
        break;
    }

    assert(cancelColor != null);

    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
    MaterialLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 8.0),
        child: Row(
          children: <Widget>[
            /* FlatButton(
              onPressed: widget.onStepContinue,
              color: _isDark() ? themeData.backgroundColor : themeData.primaryColor,
              textColor: Colors.white,
              textTheme: ButtonTextTheme.normal,
              child: Text(localizations.continueButtonLabel),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: FlatButton(
                onPressed: widget.onStepCancel,
                textColor: cancelColor,
                textTheme: ButtonTextTheme.normal,
                child: Text(localizations.cancelButtonLabel),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.customsteps[index].state != null);
    switch (widget.customsteps[index].state) {
      case CustomStepState.indexed:
        return textTheme.body2;
      case CustomStepState.disabled:
        return textTheme.body2
            .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case CustomStepState.error:
        return textTheme.body2
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);


      case CustomStepState.policyDetails:
        return textTheme.body2
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);

      case CustomStepState.hospitalDetails:
        return textTheme.body2
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
      case CustomStepState.paymentDetails:
        return textTheme.body2
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);

    }
    return null;
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.customsteps[index].state != null);
    switch (widget.customsteps[index].state) {
      case CustomStepState.indexed:
        return textTheme.caption;
      case CustomStepState.disabled:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case CustomStepState.error:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);


      case CustomStepState.policyDetails:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
      case CustomStepState.hospitalDetails:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
      case CustomStepState.paymentDetails:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);

    }
    return null;
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.customsteps[index].title,
        ),
        if (widget.customsteps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: _subtitleStyle(index),
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: widget.customsteps[index].subtitle,
            ),
          ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              _buildLine(!_isFirst(index)),
              _buildIcon(index),
              _buildLine(!_isLast(index)),
            ],
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 12.0),
            child: _buildHeaderText(index),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 24.0,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 60.0,
              end: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: <Widget>[
                widget.customsteps[index].content,
                _buildVerticalControls(),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.customsteps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              InkWell(
                onTap: widget.customsteps[i].state != CustomStepState.disabled
                    ? () {
                  // In the vertical case we need to scroll to the newly tapped
                  // step.
                  Scrollable.ensureVisible(
                    _keys[i].currentContext,
                    curve: Curves.fastOutSlowIn,
                    duration: kThemeAnimationDuration,
                  );

                  if (widget.onStepTapped != null) widget.onStepTapped(i);
                }
                    : null,
                canRequestFocus:
                widget.customsteps[i].state != CustomStepState.disabled,
                child: _buildVerticalHeader(i),
              ),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.customsteps.length; i += 1) ...<Widget>[
        InkResponse(
          // To avoid moving one custom to another comment the below part

          /*  onTap: widget.customsteps[i].state != CustomStepState.disabled
                ? () {
              if (widget.onStepTapped != null) widget.onStepTapped(i);
            }
                : null,
            canRequestFocus:
            widget.customsteps[i].state != CustomStepState.disabled,*/
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: _buildIcon(i),
                              ),
                            ),
                            Container(
/*
                margin: const EdgeInsetsDirectional.only(start: 12.0),
*/
/*
                    child: _buildHeaderText(i),
*/
                            ),
                          ],
                        ),
                      ],
                    ),
                    /* Row(
                children: <Widget>[
                  Container(s
                    child: Center(
                      child: _buildHeaderText(i),
                    ),
                  ),

                ],
              )*/
                  ],
                ), /*Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: _buildHeaderText(i),
                        ),
                      ),

                    ],
                  ),
                ],
              ),*/
              ],
            )),
        if (!_isLast(i))
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.fuchsia_pink,
                /*gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      ColorConstants.chathams_blue,
                      ColorConstants.disco
                    ]),*/
              ),
/*
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
*/
              height: 1.0,
            ),
          ),
      ],
    ];

    final List<Widget> childrentext = <Widget>[
      for (int i = 0; i < widget.customsteps.length; i += 1) ...<Widget>[
        InkResponse(
            child: Row(
              children: <Widget>[
                _buildHeaderText(i),
              ],
            )),
        if (!_isLast(i))
          Expanded(
            child: Container(
              /*margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 1.0,
              color: Colors.blueAccent,*/
            ),
          ),
      ],
    ];

    return Column(
      children: <Widget>[
        Material(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: <Widget>[
                    Row(children: children),
                    Row(children: childrentext),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: Container(
                color: ColorConstants.health_claim_intimation_bg_color,
                child: widget.customsteps[widget.currentStep].content
            )
        ),
        /*   Expanded(
          child: Container(color: ColorConstants.health_claim_intimation_bg_color,
           child: ListView(
             padding: const EdgeInsets.all(0.0),
             children: <Widget>[
               AnimatedSize(
                 curve: Curves.fastOutSlowIn,
                 duration: kThemeAnimationDuration,
                 vsync: this,
                 child: widget.customsteps[widget.currentStep].content,
               ),
               _buildVerticalControls(),
             ],
           ),
             ),
        ),*/
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null)
        throw FlutterError('Steppers must not be nested.\n'
            'The material specification advises that one should avoid embedding '
            'steppers within steppers. '
            'https://material.io/archive/guidelines/components/steppers.html#steppers-usage');
      return true;
    }());
    assert(widget.type != null);
    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
        return _buildHorizontal();
    }
    return null;
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()
        ..addPolygon(points, true),
      Paint()
        ..color = color,
    );
  }
}