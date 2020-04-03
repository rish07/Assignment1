import 'package:flutter/material.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_city_product_screen.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_policy_screen.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_remark_screen.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/health_claim_intimation/health_claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/health_claim_intimation/track_health_claim_status_screen.dart';
import 'package:sbig_app/src/ui/screens/common/site_under_maintenance_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/arogya_plus_product_info_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insuree_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/otp_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/ped_questions_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_covered_required_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_summery_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/sum_insured_and_premium_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/time_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_eia_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_health_question.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_individual_member_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_insurance_buyer_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_insure_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_policy_summary_page.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_sum_insured_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_time_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_eia_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_health_question_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_individual_member_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_insure_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_policy_period.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_policy_summary.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_time_period.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_topup_premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_topup_sum_insured_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_health_question_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_illness_insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/common_buy_journey/prdoduct_info.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_insure_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_insure_member_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_policy_summary_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_premium_break_up_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_sum_insured_new_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_sum_insured_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_time_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/eia_number_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/gross_income_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/multi_other_critical_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/othetr_critical_illness_question_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/policy_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_list_screen.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_screen_phase1.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/pin_code_screen.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_eia_number_screen.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_policy_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_policy_summery_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/contact_sbig_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/faqs_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/my_downloads_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/whats_covered_screen.dart';
import 'package:sbig_app/src/ui/screens/log_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/link_register_policy_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/onboarding_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/select_policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/ui/screens/partner/sign_in_screen.dart';
import 'package:sbig_app/src/ui/screens/web_content.dart';
import 'package:sbig_app/src/ui/screens/web_post_content.dart';
import 'package:sbig_app/src/ui/widgets/common/custom_material_page_route.dart';

class Routes {
  static onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LogScreen.ROUTE_NAME:
        return _navigate(LogScreen(), settings);
      case WelcomeScreen.ROUTE_NAME:
        return _navigate(WelcomeScreen(), settings);
      case LinkRegisterPolicyScreen.ROUTE_NAME:
        return _navigate(LinkRegisterPolicyScreen(), settings);
      case SignupSigninScreen.ROUTE_NAME:
        return _navigate(SignupSigninScreen(settings.arguments), settings);

      case HomeScreen.ROUTE_NAME:
        return _navigate(HomeScreen(), settings);
      case ArogyaPlusProductInfoScreen.ROUTE_NAME:
        return _navigate(ArogyaPlusProductInfoScreen(), settings);
      case PersonalDetailsScreen.ROUTE_NAME:
        return _navigate(PersonalDetailsScreen(settings.arguments), settings);
      case PolicyTypeScreen.ROUTE_NAME:
        return _navigate(PolicyTypeScreen(settings.arguments), settings);
      case PolicyCoveredRequiredScreen.ROUTE_NAME:
        return _navigate(
            PolicyCoveredRequiredScreen(settings.arguments), settings);
      case SumInsuredAndPremiumScreen.ROUTE_NAME:
        return _navigate(
            SumInsuredAndPremiumScreen(settings.arguments), settings);
      case TimePeriodScreen.ROUTE_NAME:
        return _navigate(TimePeriodScreen(settings.arguments), settings);
      case PremiumBreakupScreen.ROUTE_NAME:
        return _navigate(PremiumBreakupScreen(settings.arguments), settings);
      case PolicyPeriodScreen.ROUTE_NAME:
        return _navigate(PolicyPeriodScreen(settings.arguments), settings);
      case InsureeDetailsScreen.ROUTE_NAME:
        return _navigate(InsureeDetailsScreen(settings.arguments), settings);
      case PedQuestionsScreen.ROUTE_NAME:
        return _navigate(PedQuestionsScreen(settings.arguments), settings);
      case InsuranceBuyerDetailsScreen.ROUTE_NAME:
        return _navigate(
            InsuranceBuyerDetailsScreen(settings.arguments), settings);
      case PolicySummeryScreen.ROUTE_NAME:
        return _navigate(PolicySummeryScreen(settings.arguments), settings);
      case OTPScreen.ROUTE_NAME:
        return _navigate(OTPScreen(settings.arguments), settings);
      case ClaimIntimationScreen.ROUTE_NAME:
        return _navigate(ClaimIntimationScreen(), settings);
      case ClaimCityProductScreen.ROUTE_NAME:
        return _navigate(ClaimCityProductScreen(settings.arguments), settings);
      case ClaimIntimationRemarkScreen.ROUTE_NAME:
        return _navigate(
            ClaimIntimationRemarkScreen(settings.arguments), settings);
      case ClaimPolicyNumberScreen.ROUTE_NAME:
        return _navigate(ClaimPolicyNumberScreen(settings.arguments), settings);
      case NetworkHospitalPinCodeScreen.routeName:
        return _navigate(NetworkHospitalPinCodeScreen(), settings);
      case NetworkHospitalListScreen.ROUTE_NAME:
        return _navigate(
            NetworkHospitalListScreen(settings.arguments), settings);
      case NetworkHospitalScreen.ROUTE_NAME:
        return _navigate(NetworkHospitalScreen(), settings);
      case PartnerUiSignInScreen.routeName:
        return _navigate(PartnerUiSignInScreen(), settings);
      case WebContent.ROUTE_NAME:
        return _navigate(WebContent(settings.arguments), settings);
      case WebPostContent.routeName:
        return _navigate(WebPostContent(settings.arguments), settings);
      case OnboardingScreen.routeName:
        return _navigate(OnboardingScreen(), settings);
      case SiteUnderMaintenanceScreen.route_name:
        return _navigate(SiteUnderMaintenanceScreen(), settings);
      case GrossIncomeScreen.ROUTE_NAME:
        return _navigate(GrossIncomeScreen(settings.arguments), settings);
      case PolicyCoverMemberScreen.ROUTE_NAME:
        return _navigate(PolicyCoverMemberScreen(settings.arguments), settings);

      //Critical Illness  Class

      case OtherCriticalIllnessQuestionScreen.ROUTE_NAME:
        return _navigate(
            OtherCriticalIllnessQuestionScreen(settings.arguments), settings);
      case EIANumberScreen.ROUTE_NAME:
        return _navigate(EIANumberScreen(settings.arguments), settings);
      case CriticalIllnessPolicyPeriodScreen.ROUTE_NAME:
        return _navigate(
            CriticalIllnessPolicyPeriodScreen(settings.arguments), settings);
      case CriticalInsureDetailsScreen.ROUTE_NAME:
        return _navigate(
            CriticalInsureDetailsScreen(settings.arguments), settings);
      case CriticalSumInsuredScreen.ROUTE_NAME:
        return _navigate(
            CriticalSumInsuredScreen(settings.arguments), settings);
        case CriticalSumInsuredScreenNew.ROUTE_NAME:
        return _navigate(
            CriticalSumInsuredScreenNew(settings.arguments), settings);
      case CriticalIllnessInsuranceBuyerDetailsScreen.ROUTE_NAME:
        return _navigate(
            CriticalIllnessInsuranceBuyerDetailsScreen(settings.arguments),
            settings);
      case CriticalTimePeriodScreen.ROUTE_NAME:
        return _navigate(
            CriticalTimePeriodScreen(settings.arguments), settings);
      case CriticalPremiumBreakupScreen.ROUTE_NAME:
        return _navigate(
            CriticalPremiumBreakupScreen(settings.arguments), settings);
      case CriticalPolicySummeryScreen.ROUTE_NAME:
        return _navigate(
            CriticalPolicySummeryScreen(settings.arguments), settings);
      case ProductInfoScreen.ROUTE_NAME:
        return _navigate(
            ProductInfoScreen(settings.arguments), settings);
      case CriticalHealthQuestionsScreen.ROUTE_NAME:
        return _navigate(
            CriticalHealthQuestionsScreen(settings.arguments), settings);
      case MultiOtherCriticalInsuranceDetailsScreen.ROUTE_NAME:
        return _navigate(
            MultiOtherCriticalInsuranceDetailsScreen(settings.arguments),
            settings);
      case CriticalInsureMemberDetailsScreen.ROUTE_NAME:
        return _navigate(
            CriticalInsureMemberDetailsScreen(settings.arguments), settings);

     // Arogya Premier
      case ArogyaCoverMemberScreen.ROUTE_NAME:
        return _navigate(
            ArogyaCoverMemberScreen(settings.arguments), settings);
        case ArogyaPremierSumInsuredScreen.ROUTE_NAME:
        return _navigate(
            ArogyaPremierSumInsuredScreen(settings.arguments), settings);
        case ArogyaTimePeriodScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTimePeriodScreen(settings.arguments), settings);
        case ArogyaPremierPremiumBreakupScreen.ROUTE_NAME:
        return _navigate(
            ArogyaPremierPremiumBreakupScreen(settings.arguments), settings);
        case ArogyaPremierPolicyPeriodScreen.ROUTE_NAME:
        return _navigate(
            ArogyaPremierPolicyPeriodScreen(settings.arguments), settings);
      case ArogyaIndividualMemberDetailsScreen.ROUTE_NAME:
        return _navigate(
            ArogyaIndividualMemberDetailsScreen(settings.arguments), settings);
        case ArogyaInsureDetailsScreen.ROUTE_NAME:
        return _navigate(
            ArogyaInsureDetailsScreen(settings.arguments), settings);
        case ArogyaHealthQuestion.ROUTE_NAME:
        return _navigate(
            ArogyaHealthQuestion(settings.arguments), settings);
        case ArogyaPremierInsuranceBuyerDetailsScreen.ROUTE_NAME:
        return _navigate(
            ArogyaPremierInsuranceBuyerDetailsScreen(settings.arguments), settings);
        case ArogyaPremierEIANumberScreen.ROUTE_NAME:
        return _navigate(
            ArogyaPremierEIANumberScreen(settings.arguments), settings);
        case ArogyaPremierPolicySummeryScreen.ROUTE_NAME:
        return _navigate(
            ArogyaPremierPolicySummeryScreen(settings.arguments), settings);


        // Arogya Top upa
        case ArogyaTopUpCoverMemberScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpCoverMemberScreen(settings.arguments), settings);
        case ArogyaTopUpSumInsuredScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpSumInsuredScreen(settings.arguments), settings);
      case ArogyaTopUpTimePeriodScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpTimePeriodScreen(settings.arguments), settings);
      case ArogyaTopUpPremiumBreakupScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpPremiumBreakupScreen(settings.arguments), settings);
      case ArogyaTopUpPolicyPeriodScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpPolicyPeriodScreen(settings.arguments), settings);
      case ArogyaTopUpIndividualMemberDetailsScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpIndividualMemberDetailsScreen(settings.arguments), settings);
        case ArogyaTopUpInsureDetailsScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpInsureDetailsScreen(settings.arguments), settings);
        case ArogyaTopUpHealthQuestion.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpHealthQuestion(settings.arguments), settings);
        case ArogyaTopUpInsuranceBuyerDetailsScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpInsuranceBuyerDetailsScreen(settings.arguments), settings);
        case ArogyaTopUpEIANumberScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpEIANumberScreen(settings.arguments), settings);
      case ArogyaTopUpPolicySummeryScreen.ROUTE_NAME:
        return _navigate(
            ArogyaTopUpPolicySummeryScreen(settings.arguments), settings);

      case RenewalPolicyDetailsScreen.ROUTE_NAME:
        return _navigate(RenewalPolicyDetailsScreen(), settings);
      case RenewalPolicySummeryScreen.ROUTE_NAME:
        return _navigate(RenewalPolicySummeryScreen(settings.arguments), settings);
      case RenewalEIANumberScreen.ROUTE_NAME:
        return _navigate(RenewalEIANumberScreen(settings.arguments), settings);

      //Services
      case FaqsScreen.ROUTE_NAME:
        return _navigate(FaqsScreen(settings.arguments), settings);
      case WhatsCoveredScreen.ROUTE_NAME:
        return _navigate(WhatsCoveredScreen(settings.arguments), settings);
      case ContactSBIGScreen.ROUTE_NAME:
        return _navigate(ContactSBIGScreen(), settings);
      case MyDownloadsScreen.ROUTE_NAME:
        return _navigate(MyDownloadsScreen(settings.arguments), settings);

      // Health Claim
      case HealthClaimIntimationScreen.ROUTE_NAME:
        return _navigate(HealthClaimIntimationScreen(settings.arguments), settings);
      case HealthTrackClaimStatusScreen.ROUTE_NAME:
        return _navigate(HealthTrackClaimStatusScreen(settings.arguments), settings);

    }
    return null;
  }
}

_navigate(Widget child, RouteSettings settings) {
  return CustomMaterialPageRoute(
      settings: settings,
      builder: (context) {
        return child;
      });
}
