
class UrlConstants{

  //************************************* USE FOR PRODUCTION ****************************************************************//
  //static const URL = "https://mobileapi.sbigeneral.in/";  // Production URL
  static const DOC_PRIME_URL = "https://sbig.docprime.com";
 //************************************* USE FOR PRODUCTION ***************************************************************/

  //************************************* USE FOR DEVELOPMENT ****************************************************************/
  static const URL = "http://13.235.199.36";  //Dev Public URL
  //static const URL = "http://15.206.154.75";  // Testing URL
  //static const URL = "http://15.206.152.213";  // UAT URL
  //static const URL = "http://15.206.130.114";  // production IP URL
  //static const URL = "http://13.235.199.36:3000";  // Testing Proxy URL
  //static const URL = "http://13.235.199.36:4000";  // UAT Proxy URL
  //static const DOC_PRIME_URL = "https://kubeqa4.docprime.com/?utm_source=sbi_utm";
  static const FITTERNITY_URL = "http://apistage.fitn.in:9111/sbi";
  static const FITTERNITY_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmaXR0ZXJuaXR5IiwibmFtZSI6InNiaWciLCJlbnYiOiJzdGFnZSIsImlhdCI6MTU3NDMyNDQzM30.gKSY53izgoVmgNBdsaZlTD51RyJGDPr2u4ns2rsQgro";
  //************************************* USE FOR DEVELOPMENT ****************************************************************/

  static const _BASE_URL = "$URL/api/";


  static const ICON = "$URL";

  static const TOKEN_API =  "${_BASE_URL}token";
  //static const BANNERS_ICON = "${_BASE_URL}static/";
  static const BANNERS_API = "${_BASE_URL}banners";

  //Loader Message
  static const LOADER_MSG_API = "${_BASE_URL}loadermessage";

  //Tag based product info
  static const TAG_BASED_PRODUCT_INFO_URL = "${_BASE_URL}static_entries/content?group=";

  //Arogya Plus
  static const LEAD_CREATION_API = "${_BASE_URL}newlead";
  static const CALCULATE_PREMIUM_URL = "${_BASE_URL}newjourney/quotecalculate";
  static const CALCULATE_PREMIUM_FAMILY_FLOATER_URL = "${_BASE_URL}newjourney/quotecalculate?type=family_floater";
  static const RECALCULATE_PREMIUM_URL = "${_BASE_URL}newjourney/premiumcalculation";
  static const PINCODE_AREAS_URL = "${_BASE_URL}pincodebased";
  static const QUOTE_CREATION_URL = "${_BASE_URL}newjourney/quotecreation";
  static const AGENT_RECEIPT_URL = "${_BASE_URL}newjourney/agent/receipt";
  static const GET_OTP_API = "${_BASE_URL}getotp";
  static const VERIFY_OTP_API = "${_BASE_URL}verifyotp";
  static const PAYMENT_STATUS_CHECK = "${_BASE_URL}newjourney/paymentprocess";
  static const ORDER_ID_GENERATION = "${_BASE_URL}newjourney/paymentidgeneration";
  static const HEALTH_CARD_DOWNLOAD_API = "${_BASE_URL}policy/healthcard";
  static const POLICY_DOCUMENT_DOWNLOAD_API = "${_BASE_URL}policy/policydocument";

  //Critical Illness
  static const CALCULATE_PREMIUM_CRITICAL_ILLNESS_URL = "${_BASE_URL}newjourney/quotecalculate?type=critical_illness";
  static const PRODUCT_INFO_CRITICAL_ILLNESS_URL = "${_BASE_URL}static_entries/content?group=critical_illness";
  static const COVER_MEMBER_CRITICAL_ILLNESS_URL = "${_BASE_URL}static_entries/content?group=critical_illness_insured_details";
  static const HEALTH_QUESTION_CRITICAL_ILLNESS_URL = "${_BASE_URL}static_entries/content?group=critical_illness_health_questionnaire";
  static const QUICK_QUOTE_CRITICAL_ILLNESS_URL = "${_BASE_URL}criticalillness/quickquote";
  static const FULL_QUOTE_CRITICAL_ILLNESS_URL = "${_BASE_URL}criticalillness/fullquote";
  static const PAYMENT_PROCESS_CRITICAL_ILLNESS_URL = "${_BASE_URL}criticalillness/insurance";
  static const SUM_INSURED_CRITICAL_ILLNESS_URL = "${_BASE_URL}criticalillness/getsuminsured";
  static const INSURANCE_COMPANY_CRITICAL_ILLNESS_URL = "${_BASE_URL}criticalillness/getinsurancecompany";

  //Arogya Premier
  static const PRODUCT_INFO_AROGYA_PREMIER_URL = "${_BASE_URL}static_entries/content?group=arogya_premier";
  static const COVER_MEMBER_AROGYA_PREMIER_INDIVIDUAL_URL = "${_BASE_URL}static_entries/content?group=arogya_premier_insured_details_individual";
  static const COVER_MEMBER_AROGYA_PREMIER_FAMILY_URL = "${_BASE_URL}static_entries/content?group=arogya_premier_insured_details_family_individual"; // Applicable for both family floater and family individual since both have same members
  static const SUM_INSURED_AROGYA_PREMIER_URL = "${_BASE_URL}healthproducts/suminsured?policy=arogya_premier";
  static const CALCULATE_PREMIUM_AROGYA_PREMIER_URL = "${_BASE_URL}newjourney/quotecalculate?policy=arogya_premier";
  static const CALCULATE_PREMIUM_AROGYA_PREMIER_FAMILY_FLOATER_URL = "${_BASE_URL}newjourney/quotecalculate?policy=arogya_premier&type=familyfloater";
  static const HEALTH_QUESTION_AROGYA_PREMIER_URL = "${_BASE_URL}static_entries/content?group=arogya_premier_health_questionnaire";
  static const QUICK_QUOTE_AROGYA_PREMIER_INDIVIDUAL_URL = "${_BASE_URL}healthproducts/quickquote?type=individual";
  static const QUICK_QUOTE_AROGYA_PREMIER_URL = "${_BASE_URL}healthproducts/quickquote";
  static const FULL_QUOTE_AROGYA_PREMIER_INDIVIDUAL_URL = "${_BASE_URL}healthproducts/fullquote?type=individual";
  static const FULL_QUOTE_AROGYA_PREMIER_URL = "${_BASE_URL}healthproducts/fullquote";
  static const PAYMENT_PROCESS_AROGYA_PREMIER_URL = "${_BASE_URL}healthproducts/insurance";
  //Arogya top up
  static const PRODUCT_INFO_AROGYA_TOP_UP_URL = "${_BASE_URL}static_entries/content?group=arogya_topup";
  static const COVER_MEMBER_AROGYA_TOP_UP_INDIVIDUAL_URL = "${_BASE_URL}static_entries/content?group=arogya_topup_insured_details_individual";
  static const COVER_MEMBER_AROGYA_TOP_UP_FAMILY_URL = "${_BASE_URL}static_entries/content?group=arogya_topup_insured_details_family_individual"; // Applicable for both family floater and family individual since both have same members
  static const SUM_INSURED_AROGYA_TOP_UP_URL = "${_BASE_URL}api/healthproducts/suminsured?policy=arogya_topup";
  static const CALCULATE_PREMIUM_AROGYA_TOP_UP_URL = "${_BASE_URL}newjourney/quotecalculate?policy=arogya_topup";
  static const CALCULATE_PREMIUM_AROGYA_TOP_UP_FAMILY_FLOATER_URL = "${_BASE_URL}newjourney/quotecalculate?policy=arogya_topup&type=familyfloater";
  static const HEALTH_QUESTION_AROGYA_TOP_UP_URL = "${_BASE_URL}static_entries/content?group=arogya_topup_health_questionnaire";
  static const QUICK_QUOTE_AROGYA_TOP_UP_INDIVIDUAL_URL = "${_BASE_URL}healthproducts/quickquote?type=individual";
  static const QUICK_QUOTE_AROGYA_TOP_UP_URL = "${_BASE_URL}healthproducts/quickquote";
  static const FULL_QUOTE_AROGYA_TOP_UP_INDIVIDUAL_URL = "${_BASE_URL}healthproducts/fullquote?type=individual";
  static const FULL_QUOTE_AROGYA_TOP_UP_URL = "${_BASE_URL}healthproducts/fullquote";
  static const PAYMENT_PROCESS_AROGYA_TOP_UP_URL = "${_BASE_URL}healthproducts/insurance";



  //Claim Intimation
  static const CITY = "${_BASE_URL}city";
  static const PRODUCT = "${_BASE_URL}products";
  static const CLAIM_INTIMATION = "${_BASE_URL}claim/intimate";

  //Network Hospitals
  static const HOSPITAL_LIST = "${_BASE_URL}hospitalnetwork";
  static const HOSPITAL_LIST_NEW = "${_BASE_URL}hospitalnetwork";
  static const HOSPITAL_LIST_SUGGESTION = "${_BASE_URL}network_hospital_archive/suggestions";

  static const PARTNER_UI_SIGN_IN = "${_BASE_URL}users/login_register";

  //WebView URLS
  static const TERMS_N_CONDITIONS_WEBVIEW_URL = '${URL}/webcore/arogya_plus_terms_conditions';
  static const TAX_BENEFIT_WEBVIEW_URL = '${URL}/webcore/arogya_plus_tax_benefit';
  static const AROGYA_PLUS_OPD_BENEFIT_WEBVIEW_URL = '${URL}/webcore/arogya_plus_opd_table';
  static const AROGYA_PLUS_PRIVACY_POLICY_WEBVIEW_URL = '${URL}/webcore/arogya_plus_privacy_policy';
  static const TERMS_OF_USE_WEBVIEW_URL = '${URL}/webcore/arogya_plus_terms_of_use';

  //Login
  static const LOGIN_GET_POLICY_DETAILS_URL = "${_BASE_URL}login";
  static const GET_POLICY_TYPES_URL = "${_BASE_URL}static_entries/content?group=policy_types";
  static const LOGIN_OTP_VERIFICATION_URL = "${_BASE_URL}verify";
  static const REGISTER_URL = "${_BASE_URL}register";
  static const VALIDATE_POLICY_DATA_URL = "${_BASE_URL}validate";
  static const GET_LOGIN_OTP = "${_BASE_URL}login";

  //Renewals
  static const RENEWAL_POLICY_DETAILS_URL = '${_BASE_URL}renewals/getdetails';
  static const RENEWAL_UPDATE_POLICY_DETAILS_URL = '${_BASE_URL}renewals/journey';
  static const RENEWAL_PAYMENT_ID_GENERATION = '${_BASE_URL}newjourney/paymentidgeneration';
  static const RENEWAL_PAYMENT_VERIFICATION = '${_BASE_URL}renewals/status';
  static const RENEWAL_STORE_EIA = '${_BASE_URL}renewals/store_EIA';

  //Home & Service tabs
  static const GET_POLICY_SERVICE_DETAILS_URL = "${_BASE_URL}homeapi";
  static const GET_POLICY_MEMBER_DETAILS_URL = "${_BASE_URL}home_policy_details";

  // Health Claim Intimation
  static const HEALTH_CLAIM_INTIMATION = "${_BASE_URL}claims/intimateclaims?claim=health";
  static const CITIES = "${_BASE_URL}claims/cities";
  static const HOSPITAL_LIST_BY_CITY = "${_BASE_URL}network_hospital_archive/gethospitalbycity";
  static const POLICY_HEALTH_DETAILS_BY_POLICY_NO = "${_BASE_URL}claims/policydetails?claim=health";
  static const TRACK_HEALTH_CLAIM_INTIMATION = "${_BASE_URL}claims/claimdetails?claim=health";

  // Motor Claim Intimation
  static const POLICY_MOTOR_DETAILS_BY_POLICY_NO = "${_BASE_URL}claims/policydetails?claim=motor";
  static const CITIESMOTOR = "${_BASE_URL}claims/cities/claim=motor";
  static const STATEMOTOR = "${_BASE_URL}claims/states";
  static const GARAGE_BY_CITY = "${_BASE_URL}motors/garage_locator";
  static const MOTOR_CLAIM_INTIMATION = "${_BASE_URL}claims/intimateclaims?claim=motors";
  static const TRACK_MOTOR_CLAIM_INTIMATION = "${_BASE_URL}claims/claimdetails?claim=motors";
}