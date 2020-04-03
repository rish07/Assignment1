import 'package:sbig_app/src/controllers/service/call_sms_mail_service.dart';
import 'package:sbig_app/src/controllers/service/service_locator.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/widgets/claim/claim_service_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ContactSBIGScreen extends StatefulWidget {
  static const ROUTE_NAME = "/services_tab/contact_sbig_screen";

  @override
  _ContactSBIGScreenState createState() => _ContactSBIGScreenState();
}

class _ContactSBIGScreenState extends State<ContactSBIGScreen>
    with CommonWidget {
  final Service _service = getIt<Service>();
  ServiceModel callServiceModel, messageServiceModel, emailServiceModel;

  @override
  void didChangeDependencies() {
    callServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_call.toUpperCase(),
        subTitle: S.of(context).claim_intimation_call_no,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_mobile,
        color1: ColorConstants.claim_intimation_call_color1,
        color2: ColorConstants.claim_intimation_call_color2);

    messageServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_message.toUpperCase(),
        subTitle: S.of(context).claim_intimation_message_no,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_group,
        color1: ColorConstants.claim_intimation_message_color1,
        color2: ColorConstants.claim_intimation_message_color2);

    emailServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_email.toUpperCase(),
        subTitle: S.of(context).claim_intimation_email_address,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_mail,
        color1: ColorConstants.claim_intimation_email_color1,
        color2: ColorConstants.claim_intimation_email_color2);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.faqs_bg,
      appBar: getAppBar(context, S.of(context).contact_sbig.toUpperCase()),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: ConnectWithUsWidget(callServiceModel, 2),
                          ),
                          onTap: () {
                            _service
                                .call(S.of(context).claim_intimation_call_no);
                          },
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ConnectWithUsWidget(messageServiceModel, 2),
                          ),
                          onTap: () {
                            _service.sendSMS(S.of(context).claim.toUpperCase(),
                                [S.of(context).claim_intimation_message_no]);
                          },
                        ),
                        InkWell(
                            onTap: () {
                              _service.sendEmail(
                                  S.of(context).claim_intimation_email_address);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ConnectWithUsWidget(emailServiceModel, 2),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
