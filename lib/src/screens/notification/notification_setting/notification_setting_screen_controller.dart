import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/models/notification_setting_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../app_routes/app_routes.dart';
import '../../../utils/global_constants.dart';

class NotificationSettingController extends GetxController {
  RxList<NotificationSettingModel> notificationSettingItems = RxList<NotificationSettingModel>();
  String? token;
  RxBool notificationEnabled = false.obs;

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationEnabled.value = prefs.getString(PreferenceConstants.notification_setting_status) == "1" ? true : false;
  }

  void getNotificationSettingList() async {
    String? userId;

    userId = await SharedPref.getString(PreferenceConstants.userId);

    try {
      await TalatService().notificationSettingListApi({
        ConstantStrings.userTypeKey: 1,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.isChecked: notificationEnabled.value ? 1 : 0,
      }).then((response) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (response.data['code'].toString() == "200") {
          await prefs.setString(PreferenceConstants.notification_setting_status, notificationEnabled.value ? "1" : "0");
          debugPrint("======>${prefs.getString(PreferenceConstants.notification_setting_status)}");
          // update();
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
          // showLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
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
      });
    } on DioError catch (e) {
      debugPrint("authenticateUser-error dio error >>>> ${e.toString()}");
    }
    update();
  }
}
