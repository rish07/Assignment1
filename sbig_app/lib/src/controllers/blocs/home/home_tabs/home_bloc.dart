

import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/mics/arogya_plus_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/home_tabs/home_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewals_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/download_models.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/download_status_model.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/get_policy_service_details.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/member_details.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/policy_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/service_item.dart';

import 'home_validator.dart';

class HomeBloc extends BaseBloc with HomeValidator{

  List<PolicyListItem> _policiesData;

  List<PolicyListItem> get policiesData => _policiesData;

  set policiesData(List<PolicyListItem> value) {
    _policiesData = value;
  }

  final _servicesController = BehaviorSubject<List<ServicesListItem>>();
  Function(List<ServicesListItem>) get changeServices => _servicesController.sink.add;
  Observable<List<ServicesListItem>> get servicesStream =>
      _servicesController.stream.transform(validateServicesList);
  List<ServicesListItem> get getServicesList => _servicesController.value;

  final _policiesController = BehaviorSubject<List<PolicyListItem>>();
  Function(List<PolicyListItem>) get changePolicies => _policiesController.sink.add;
  Observable<List<PolicyListItem>> get policiesStream =>
      _policiesController.stream.transform(validatePoliciesList);
  List<PolicyListItem> get getPoliciesList => _policiesController.value;

  final _policiesController1 = BehaviorSubject<List<PolicyListItem>>();
  Function(List<PolicyListItem>) get changePolicies1 => _policiesController1.sink.add;
  Observable<List<PolicyListItem>> get policiesStream1 =>
      _policiesController1.stream.transform(validatePoliciesList);
  List<PolicyListItem> get getPoliciesList1 => _policiesController1.value;

  final _policiesListLoaded = BehaviorSubject.seeded(false);
  Function(bool) get changePoliciesListLoaded => _policiesListLoaded.sink.add;
  Observable<bool> get policiesListLoadedStream =>
      _policiesListLoaded.stream;
  bool get getPoliciesListLoaded => _policiesListLoaded.value;

  final _policyListEmptyController = BehaviorSubject.seeded(false);
  Function(bool) get changePolicyListEmpty => _policyListEmptyController.sink.add;
  Observable<bool> get policyListStream =>
      _policyListEmptyController.stream;
  bool get getPolicyListEmpty => _policyListEmptyController.value;

  final _currentPolicyController = BehaviorSubject<PolicyListItem>();
  Function(PolicyListItem) get changeCurrentPolicy => _currentPolicyController.sink.add;
  Observable<PolicyListItem> get currentPolicyStream =>
      _currentPolicyController.stream;
  PolicyListItem get getCurrentPolicy => _currentPolicyController.value;

  final _downloadFileController = BehaviorSubject<DownloadStatusModel>();
  Function(DownloadStatusModel) get changeDownloadStatus => _downloadFileController.sink.add;
  Function(Object) get addDownloadStatusError => _downloadFileController.sink.addError;
  Observable<DownloadStatusModel> get downloadStatusStream =>
      _downloadFileController.stream;
  DownloadStatusModel get getDownloadStatus => _downloadFileController.value;

  Future<PoliciesServicesRes> getPolicyServiceDetails() async {
    return HomeApiProvider.getInstance()
        .getPolicyServiceDetails();
  }

  Future<DownloadResponse> download(DocType docType, String policyNumber) async{
    return HomeApiProvider.getInstance().download(docType, policyNumber);
  }

  Future<MemberDetailsResModel> getMemberDetails(Map<String, dynamic> body) async{
    return HomeApiProvider.getInstance().getMemberDetails(body);
  }

  Future<RenewalPolicyDetailsResModel> getPolicyDetails(
      Map<String, dynamic> body) async {
    return RenewalsPolicyDetailsApiProvider.getInstance()
        .getRenewalPolicyDetails(body);
  }

  Future<ProductInfoResModel> getProductInfo(
      String tag) async {
    return HomeApiProvider.getInstance()
        .getProductInfo(tag);
  }

  @override
  void dispose() {
    _servicesController.close();
    _policiesController.close();
    _policiesController1.close();
    _currentPolicyController.close();
    _downloadFileController.close();
    _policiesListLoaded.close();
    _policyListEmptyController.close();
  }
}