import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/models/providerDeatail_model.dart';
import 'package:talat/src/models/review%20Model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../models/service_provider_activity_list_model.dart';
import '../../models/service_provider_list_model.dart';
import '../dashboard/tabBar/tabbar_binding.dart';

class ServiceProviderController extends GetxController {
  RxList<ReviewModel> reviewListItems = RxList<ReviewModel>();
  RxList<ReviewListModel> moreReviewListItems = RxList<ReviewListModel>();
  Rx<ServiceProviderActivityListResponse> providerActivityList = ServiceProviderActivityListResponse().obs;
  final moreReviewListItem = ReviewListModel().obs;
  RxInt current = 0.obs;
  RxBool showLoader = false.obs;
  RxBool showProviderActivityLoader = false.obs;
  RxBool favShowLoader = false.obs;
  String? token;
  String? userId;
  Rx<ProviderDetailModel> providerDetailModel = ProviderDetailModel().obs;
  Rx<ServiceProviderListResponseModel> serviceProviderListResult = ServiceProviderListResponseModel().obs;
  RxInt servicesProviderId = 0.obs;
  RxInt limit = 10.obs;
  RxInt page = 1.obs;
  RxInt selectedIndex = 1.obs;
  final CarouselController slideControllers = CarouselController();

  RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    servicesProviderId.value;
    providerDetailModel.value = ProviderDetailModel();

    providerData();

    update();
    // fetchMoreReviewList();
  }

  ///Provider Api calling
  void providerData() async {
    showLoader.value = true;
    try {
      await TalatService().serviceProviderApi({
        ConstantStrings.providerKey: providerID.value,
        ConstantStrings.longitudeKey: userLong.value != "" ? userLong.value : "0.0",
        ConstantStrings.latitudKey: userLat.value != "" ? userLat.value : "0.0",
        ConstantStrings.languageId: language
      }).then((response) async {
        if (response.data['code'] == 200) {
          providerDetailModel.value = ProviderDetailModel.fromJson(response.data);
          showLoader.value = false;
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
        if (response.data['message'] == "service_provider_not_found") {
          showLoader.value = false;
          CommonWidgets().customSnackBar("Error", response.data['message']);
        }
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showLoader.value = false;
    update();
  }

  void providerListData() async {
    showLoader.value = true;
    if (userId == null || (userId != null && userId!.isEmpty)) {
      token = await SharedPref.getString(PreferenceConstants.token);
      userId = await SharedPref.getString(PreferenceConstants.userId);
    }
    await TalatService().serviceProviderList({
      "category_id": activityID.value,
      ConstantStrings.longitudeKey: userLong.value != "" ? userLong.value : "0.0",
      ConstantStrings.latitudKey: userLat.value != "" ? userLat.value : "0.0",
      "limit": limit.value,
      "page": page.value,
    }).then((value) {
      debugPrint(value.data);
      showLoader.value = false;
      serviceProviderListResult.value = ServiceProviderListResponseModel.fromJson(value.data);
    });
  }

  void serviceProviderActivityList({bool? isRefresh}) async {
    if (isRefresh == null || (!isRefresh)) {
      showProviderActivityLoader.value = true;
    }
    try {
      if (userId == null || (userId != null && userId!.isEmpty)) {
        token = await SharedPref.getString(PreferenceConstants.token);
        userId = await SharedPref.getString(PreferenceConstants.userId);
      }
      await TalatService().serviceProviderActivityList({
        "user_type": "1",
        ConstantStrings.userIdKey: userId,
        "device_type": "1",
        "service_provider_id": providerID.value,
        "language_id": language ?? "1",
        ConstantStrings.longitudeKey: userLong.value != "" ? userLong.value : "0.0",
        ConstantStrings.latitudKey: userLat.value != "" ? userLat.value : "0.0",
        "limit": limit.value,
      }).then((response) async {
        if (response.data['code'] == 200) {
          providerActivityList.value = ServiceProviderActivityListResponse.fromJson(response.data);
          // providerDetailModel.value =
          //     ProviderDetailModel.fromJson(response.data);
          showProviderActivityLoader.value = false;
          favShowLoader(false);
          update();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showProviderActivityLoader(false);
          favShowLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
        if (response.data['message'] == "service_provider_not_found") {
          showProviderActivityLoader.value = false;
          favShowLoader(false);
          CommonWidgets().customSnackBar("Error", response.data['message']);
        }
        // activityList.value = ServiceProviderActivityListResponse.fromJson(response.data);
      }).catchError((error) {
        debugPrint(error.toString());
        showProviderActivityLoader.value = false;
        favShowLoader(false);
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showProviderActivityLoader.value = false;
    favShowLoader(false);
    update();
  }

  /// Delete FavouriteItem api Calling
  void deleteFavouriteItem(String? activityId) async {
    favShowLoader.value = true;

    try {
      await TalatService().removeFavApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.activityIdKey: activityId,
        ConstantStrings.isFavKey: 0,
      }).then((response) async {
        if (response.data['code'] == "1") {
          update();
          serviceProviderActivityList(isRefresh: true);
          CommonWidgets().showToastMessage("removed_from_favourite");
        } else if (response.data["code"] == "-1") {
          favShowLoader.value = false;
          Get.back();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          TabbarBinding().dependencies();
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());

        favShowLoader.value = false;
        Get.back();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void addFavouriteItem(String? activityId) async {
    favShowLoader.value = true;

    try {
      await TalatService().removeFavApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.activityIdKey: activityId,
        ConstantStrings.isFavKey: 1,
      }).then((response) async {
        if (response.data['code'] == "1") {
          serviceProviderActivityList(isRefresh: true);
          // favShowLoader.value = false;
          CommonWidgets().showToastMessage("added_to_favorite");
          update();
        } else if (response.data["code"] == "-1") {
          favShowLoader.value = false;
          Get.back();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          TabbarBinding().dependencies();
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());

        favShowLoader.value = false;
        Get.back();
      });
    } catch (e) {
      debugPrint(e.toString());

      favShowLoader.value = false;
      Get.back();
    }
  }
}
