import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/models/my_booking_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';

class MyBookingScreenController extends GetxController {
  RxList<MyBookingModel> bookingItems = RxList<MyBookingModel>();

  final bookingItem = MyBookingModel().obs;
  String? token;
  String? userId;
  String? name;
  RxBool showLoader = false.obs;
  RxString myBookingId = "".obs;

  final RefreshController bookingRefreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    name = await SharedPref.getString(PreferenceConstants.providerName);
    bookingItem.value = MyBookingModel();
    getBookingList();

    //fetchBookingList();
  }

  /// Get BookingList api Calling
  void getBookingList({bool? isRefresh}) async {
    if (isRefresh == null || (isRefresh != null && !isRefresh)) {
      showLoader.value = true;
    }
    try {
      await TalatService().bookingListApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.languageId: language ?? "1",
      }).then((response) async {
        if (response.data['code'] == 200) {
          bookingItem.value = MyBookingModel.fromJson(response.data);

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
        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUser-error dio error >>>> ${e.toString()}");
    }
    bookingRefreshController.refreshCompleted();
    showLoader.value = false;
  }
}
