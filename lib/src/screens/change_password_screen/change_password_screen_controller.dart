import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

class ChangePasswordController extends GetxController {
  RxInt genderValue = 0.obs;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool showLoader = false.obs;
  Rx<bool> isShowPassword = false.obs;
  Rx<bool> isNewShowPassword = false.obs;
  Rx<bool> isConfirmShowPassword = false.obs;
  String? userId;
  String? token;

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    update();
  }

  ///Log Out Api calling
  void onChangePasswordTap() async {
    showLoader.value = true;
    try {
      await TalatService().changePasswordApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.currentPasswordKey: passwordController.text,
        ConstantStrings.newPasswordKey: newPasswordController.text,
      }).then((response) async {
        if (response.data["code"] == "1") {
          CommonWidgets()
              .showToastMessage("password_has_been_changed".toString());
          Get.back();
          Get.back();
          // Get.offNamed(AppRouteNameConstant.tabScreen);
        } else if (response.data["code"] == "0") {
          showLoader.value = false;
          Get.back();
          CommonWidgets().showToastMessage(response.data['message'].toString());
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language =
              await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" &&
            response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language =
              await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
        } else if (response.data["code"] == "-4" &&
            response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language =
              await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader.value = false;
        // Get.back();
      });
    } on DioError catch (e) {
      showLoader.value = false;
      // Get.back();
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
  }
}
