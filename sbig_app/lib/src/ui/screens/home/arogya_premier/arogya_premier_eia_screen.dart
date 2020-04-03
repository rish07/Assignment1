import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/eia/eia_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/eia/eia_validator.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/eia_model.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_policy_summary_page.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_policy_summary.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/eia_number_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';

class ArogyaPremierEIANumberScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_premier/eia_number_screen";

  ArogyaPremierModel arogyaPremierModel;

  ArogyaPremierEIANumberScreen(this.arogyaPremierModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: ArogyaPremierEIANumberScreenWidget(arogyaPremierModel),
      bloc: EiaBloc(),
    );
  }
}

class ArogyaPremierEIANumberScreenWidget extends StatefulWidget {
  ArogyaPremierModel arogyaPremierModel;

  ArogyaPremierEIANumberScreenWidget(this.arogyaPremierModel);

  @override
  _State createState() => _State();
}

class _State extends State<ArogyaPremierEIANumberScreenWidget>
    with CommonWidget {
  EiaBloc eiaBloc;
  ScrollController _controller;
  ArogyaPremierModel arogyaPremierModel;
  bool isYesOrNoButtonClicked = false;
  bool onSubmit = false;
  String eiaNumber = '';
  bool isYesButtonClicked = false;
  bool isNoButtonClicked = false;
  String errorText;

  @override
  void initState() {
    eiaBloc = SbiBlocProvider.of<EiaBloc>(context);
    _controller = ScrollController();
    arogyaPremierModel = widget.arogyaPremierModel;

    super.initState();
  }

  @override
  void dispose() {
    eiaBloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.critical_illness_bg_color,
      appBar: getAppBar(context, S.of(context).arogya_premier.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            EIANumberScreenWidget(eiaBloc, onSubmit, onUpdate),
            if (isYesOrNoButtonClicked)
              _showSubmitButton(),
            //  Align(alignment: Alignment.bottomCenter, child: _showPremiumButton()),
          ],
        ),
      ),
    );
  }

  onUpdate(bool isYes) {
    setState(() {
      if (isYes != null) {
        isYesOrNoButtonClicked = true;
        if (isYes) {
          isYesButtonClicked = true;
          isNoButtonClicked = false;
        } else {
          isYesButtonClicked = false;
          isNoButtonClicked = true;
        }
      }
    });
  }

  onClick() {
    setState(() {
      onSubmit = true;
    });
    if (isYesButtonClicked) {
      String eia = eiaBloc.eiaNumber;
      eiaBloc.changeEiaNumber(eia);
      Future.delayed(Duration(microseconds: 200)).then((value) {
        if (EIAValidator.isEiaValid(eiaBloc.eiaNumber)) {
          EIAModel eiaModel = EIAModel();
          eiaModel.eiaNumber = eiaNumber;
          eiaModel.isEIAAvailable = true;
          arogyaPremierModel.eiaModel = eiaModel;
          _navigate(widget.arogyaPremierModel);
        } else {
          eiaBloc.changeEiaNumber(eia);
        }
      });
    } else {
      EIAModel eiaModel=EIAModel();
      eiaModel.isEIAAvailable=false;
      arogyaPremierModel.eiaModel=eiaModel;
          _navigate(widget.arogyaPremierModel);
    }
  }

  Widget _showSubmitButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).claim_next_button.toUpperCase(),
      bottomBgColor: ColorConstants.claim_intimation_bg_color,
    );
  }

  void _navigate(ArogyaPremierModel arogyaPremierModel) {
    Navigator.of(context).pushNamed(ArogyaPremierPolicySummeryScreen.ROUTE_NAME,
        arguments: widget.arogyaPremierModel);
  }
}
