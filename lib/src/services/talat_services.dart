import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_binding.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/services/network_services.dart';
import 'package:talat/src/theme/constant_strings.dart';

class TalatService {
  NetworkService networkService = NetworkService();

  getFormattedHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Map<String, String>.from({
      "Authorization": 'Bearer ${prefs.getString('chatSessionId')}',
    });
  }

  getGeneralSettingsHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Map<String, String>.from({"username": "talat", "password": "Admin@123"});
  }

  Future<Response> generalSettings() async {
    return await networkService.post(
      '${ConstantStrings.baseUrl}general',
      headers: await getGeneralSettingsHeaders(),
    );
  }

  Future<Response> getLabels() async {
    return await networkService.post('${ConstantStrings.baseUrl}label', headers: await getGeneralSettingsHeaders());
  }

  Future<Response> login(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}login',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> verifyOtp(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}verifyOtp',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> forgotPassword(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}forgot-password',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> reSendOtp(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}resendOtp',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> cms(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}cms',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> logOutApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}logout',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> changePasswordApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}changePassword',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> viewProfileApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}viewProfile',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> editProfileApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}editProfile',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> updateProfileApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}updateProfile',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> deleteAccount(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}delete-account',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> serviceProviderApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}service-provider-detail',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> activityDetailApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}activity-details',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> categoryActivityDetailApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}get-category-activity-details',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> serviceProviderActivityList(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}service-provider-activity-list',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> seeAllActivityApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}seeAllActivities',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> searchApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}search',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> signupApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}signup',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> signupAsPartnerApi(data) async {
    print(data);
    return await networkService.post('${ConstantStrings.baseUrl}signupPartner',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> favoriteListApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}favoriteList',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> notificationListApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}notificationList',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> notificationSettingListApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}notificationSetting',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> bookingListApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}bookingList',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> bookingDetailApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}booking-details',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> bookingCancelApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}bookingCancel',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> serviceListApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}serviceList',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> bannerApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}BannerAdvertisement',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> browseActivityApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}browseActivityList',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> reviewList(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}ratingReviewList',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> addReviewApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}ratingReview',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> addFavApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}addFavActivity',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> removeFavApi(data) async {
    Response favResponse = await networkService.post('${ConstantStrings.baseUrl}addRemoveFavActivity',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
    DashboardBinding().dependencies();
    Get.find<DashboardController>().getPopularActivityList(isRefresh: true);
    return favResponse;
  }

  Future<Response> popularActivityApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}popularActivites',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> categoryListApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}category-item',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> bookingConfirmApi(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}booking-confirm',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> checkAvailableBookingSlot(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}check-available-booking-slot',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> payNow(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}pay-now',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> searchPlace(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}searchLocation',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> getTimeSlot(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}get-time-slot',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> getAvailableDate(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}available-days',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> checkSlotAvailability(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}check-booking-availabilty',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }

  Future<Response> serviceProviderList(data) async {
    return await networkService.post('${ConstantStrings.baseUrl}service-provider-list',
        headers: await getGeneralSettingsHeaders(), body: jsonEncode(data));
  }
}
