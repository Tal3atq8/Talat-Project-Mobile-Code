import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/network/network_binding.dart';
import 'package:talat/src/network/not_network_connectivity.dart';
import 'package:talat/src/screens/%20favorite/favorite_list_screen.dart';
import 'package:talat/src/screens/%20favorite/favorite_list_screen_binding.dart';
import 'package:talat/src/screens/activite/activite_list_screen.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_binding.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_screen.dart';
import 'package:talat/src/screens/auth/forgot_password/forgot_password_page_bindings.dart';
import 'package:talat/src/screens/auth/login/login_screen.dart';
import 'package:talat/src/screens/auth/login/login_screen_binding.dart';
import 'package:talat/src/screens/auth/otp/otp_screen.dart';
import 'package:talat/src/screens/auth/otp/otp_screen_binding.dart';
import 'package:talat/src/screens/auth/partner_registration/partner_registration_screen.dart';
import 'package:talat/src/screens/auth/partner_registration/partner_registration_screen_binding.dart';
import 'package:talat/src/screens/auth/registration/registration_screen.dart';
import 'package:talat/src/screens/auth/registration/registration_screen_binding.dart';
import 'package:talat/src/screens/booking_calendar/booking_calendar_binding.dart';
import 'package:talat/src/screens/booking_calendar/booking_calendar_screen.dart';
import 'package:talat/src/screens/booking_calendar/confirmBooking_screen.dart';
import 'package:talat/src/screens/booking_calendar/payemntFailedScreen.dart';
import 'package:talat/src/screens/change_language/change_language_screen.dart';
import 'package:talat/src/screens/change_password_screen/change_password_screen.dart';
import 'package:talat/src/screens/change_password_screen/change_password_screen_binding.dart';
import 'package:talat/src/screens/cms/cms_screen.dart';
import 'package:talat/src/screens/cms/cms_screen_binding.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_binding.dart';
import 'package:talat/src/screens/dashboard/tabBar/bottom_navigation.dart/bottom_navigation.dart';
import 'package:talat/src/screens/dashboard/tabBar/tabbar_binding.dart';
import 'package:talat/src/screens/extra_activity/extra_activity_detail_binding.dart';
import 'package:talat/src/screens/extra_activity/extra_activity_screen.dart';
import 'package:talat/src/screens/filter/filter_binding.dart';
import 'package:talat/src/screens/map/map_binding.dart';
import 'package:talat/src/screens/map/map_screen.dart';
import 'package:talat/src/screens/more_about/more_about_screen.dart';
import 'package:talat/src/screens/my_booking/confirm_booking_screen.dart';
import 'package:talat/src/screens/my_booking/my_booking_detail/my_booking_detail_binding.dart';
import 'package:talat/src/screens/my_booking/my_booking_screen.dart';
import 'package:talat/src/screens/my_booking/my_booking_screen_binding.dart';
import 'package:talat/src/screens/notification/notification_list/notification_binding.dart';
import 'package:talat/src/screens/notification/notification_list/notification_screen.dart';
import 'package:talat/src/screens/notification/notification_setting/notification_setting_screen.dart';
import 'package:talat/src/screens/notification/notification_setting/notification_setting_screen_binding.dart';
import 'package:talat/src/screens/payment/upay_dilug.dart';
import 'package:talat/src/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:talat/src/screens/profile/edit_profile/edit_profile_screen_binding.dart';
import 'package:talat/src/screens/profile/profile_screen.dart';
import 'package:talat/src/screens/profile/profile_screen_binding.dart';
import 'package:talat/src/screens/seeAll_activity/search_screen.dart';
import 'package:talat/src/screens/seeAll_activity/see_all_activity_binding.dart';
import 'package:talat/src/screens/seeAll_activity/see_all_browse_activities.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/screens/service_provider/review_list.dart';
import 'package:talat/src/screens/service_provider/service_provider_activity_list.dart';
import 'package:talat/src/screens/service_provider/service_provider_binding.dart';
import 'package:talat/src/screens/service_provider/service_provider_screen.dart';
import 'package:talat/src/screens/splash_screen.dart';
import 'package:talat/src/screens/user_guide/user_guide_binging.dart';
import 'package:talat/src/screens/user_guide/user_guide_screen.dart';

import '../screens/activite/activity_list_binding.dart';
import '../screens/auth/forgot_password/forgot_password_view.dart';
import '../screens/booking_calendar/booking_checkout_screenV2.dart';
import '../screens/change_language/change_language_screen_binding.dart';
import '../screens/filter/filter_screenv2.dart';

appRoutes() => [
      GetPage(
        name: AppRouteNameConstant.dashboardScreen,
        page: () => DashBoard(),
        binding: DashboardBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.splashScreen,
        page: () => const SplashScreen(),
        binding: NetworkBinding(),
      ),
      GetPage(
          name: AppRouteNameConstant.tabScreen,
          page: () => TabBar(),
          bindings: [
            TabbarBinding(),
            DashboardBinding(),
            NetworkBinding()
            // FavoriteListBinding(),
            // NotificationBinding()
          ]),
      GetPage(
        name: AppRouteNameConstant.networkScreen,
        page: () => NoNetworkConnectivity(),
        binding: NetworkBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.userGuideScreen,
        page: () => const UserGuide(),
        binding: UserGuideBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.profileScreen,
        page: () => ProfileScreen(),
        binding: ProfileBinding(),
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 200),
      ),
      GetPage(
        name: AppRouteNameConstant.cmsScreen,
        page: () => CmsScreen(),
        binding: CmsBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.moreAboutScreen,
        page: () => const MoreAbout(),
      ),
      GetPage(
        name: AppRouteNameConstant.changePasswordScreen,
        page: () => ChangePassword(),
        binding: ChangePasswordBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.loginScreen,
        page: () => const LoginScreen(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.forgotPasswordScreen,
        page: () => const ForgotPassword(),
        binding: ForgotPasswordPageBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.otpScreen,
        page: () => Otp(),
        binding: OtpBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.registrationScreen,
        page: () => Registration(),
        binding: RegistrationBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.partnerRegistrationScreen,
        page: () => PartnerRegistration(),
        binding: PartnerRegistrationBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.notificationSettingScreen,
        page: () => NotificationSetting(),
        binding: NotificationSettingBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.changeLanguageScreen,
        page: () => ChangeLanguage(),
        binding: ChangeLanguageBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.editProfileScreen,
        page: () => EditProfile(),
        binding: EditProfileBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.myBookingScreen,
        page: () => MyBooking(),
        binding: MyBookingBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.networkScreen,
        page: () => NotificationScreen(),
        binding: NotificationBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.favoriteListScreen,
        page: () => FavoriteList(),
        binding: FavoriteListBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.activityListScreen,
        page: () => ActivityList(),
        binding: ActivityListBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.activityDetailScreen,
        page: () => ActivityDetailScreen(),
        binding: ActivityDetailBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.searchScreen,
        page: () => SearchScreen(),
        binding: SeeAllActivityBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.mapScreen,
        page: () => const MapScreen(),
        binding: MapBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.bookingCalendarScreen,
        page: () => BookingCalendar(),
        binding: BookingCalendarBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.checkoutBookingScreen,
        // page: () => const BookingCheckoutScreen(),

        /// For Knet V2 integration with Apple pay
        page: () => const BookingCheckoutScreenV2(),
        // binding: BookingCalendarBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.bookingConfirmScreen,
        page: () => const ConfirmBooking(),
      ),
      GetPage(
        name: AppRouteNameConstant.confirmBookingScreen,
        page: () => BookingConfirmDetail(),
        binding: BookingDetailBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.filterScreen,
        page: () => FilterV2(),
        binding: FilterBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.serviceProviderScreen,
        page: () => ServiceProvider(),
        binding: ServiceProviderBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.paymentLinkScreen,
        page: () => UpayDialogs(),
      ),
      GetPage(
        name: AppRouteNameConstant.paymentFailScreen,
        page: () => const PaymentFailedScreen(),
      ),
      GetPage(
        name: AppRouteNameConstant.reviewListScreen,
        page: () => ReviewListScreen(),
        binding: ServiceProviderBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.extraActivityScreen,
        page: () => ExtraActivity(),
        binding: ExtraActivityDetailBinding(),
      ),
      GetPage(
        name: AppRouteNameConstant.seeAllBrowseActivitiesScreen,
        page: () => SeeAllBrowseActivities(),
        // binding: (),
      ),
      GetPage(
        name: AppRouteNameConstant.seeAllPopularActivitiesScreen,
        page: () => SeeAllPopularActivities(),
        // binding: (),
      ),
      GetPage(
        name: AppRouteNameConstant.serviceProviderActivityListScreen,
        binding: ServiceProviderBinding(),
        page: () => ServiceProviderActivityList(),
        // binding: (),
      ),
    ];
