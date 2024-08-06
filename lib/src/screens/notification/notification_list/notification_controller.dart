import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/models/notification_list_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';

import '../../../app_routes/app_routes.dart';
import '../../../utils/global_constants.dart';
import '../../../utils/preference/preference_keys.dart';
import '../../../utils/preference/preferences.dart';
import '../../../widgets/progress_dialog.dart';

class NotificationController extends GetxController {
  List<NotificationList> notificationList = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RxInt pageIndex = 1.obs;
  Rx<NotificationListModel> notificationListingsItems = NotificationListModel().obs;

  RxBool showLoader = false.obs;
  String? token;
  String? userId;

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);

    update();
  }

  /// Get NotificationList api Calling
  void getNotificationList() async {
    if (pageIndex.value == 1) {
      showLoader.value = true;
      notificationList = [];
    }
    // showLoader.value = true;
    if (userId != null && userId != "") {
      try {
        await TalatService().notificationListApi({
          ConstantStrings.userTypeKey: '1',
          ConstantStrings.deviceTypeKey: '1',
          ConstantStrings.userIdKey: userId,
          ConstantStrings.deviceTokenKey: token,
          ConstantStrings.languageId: language ?? "1",
          ConstantStrings.limitKey: "10",
          ConstantStrings.pageKey: pageIndex.value.toString()
        }).then((response) async {
          if (response.data['code'] == "1") {
            notificationListingsItems.value = NotificationListModel.fromJson(response.data);

            notificationList.addAll(notificationListingsItems.value.result!.data!);
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
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      }
      showLoader.value = false;
      update();
    }
  }
}
