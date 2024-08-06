import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/user_deati_model.dart';
import 'package:talat/src/screens/auth/otp/otp_screen_binding.dart';
import 'package:talat/src/screens/auth/otp/otp_screen_controller.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/dashboard/tabBar/tabbar_binding.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../utils/global_constants.dart';

class LoginController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isEmailRead = false.obs;
  Rx<bool> isShowPassword = false.obs;
  String? fcmToken;
  RxBool isMobileRead = false.obs;
  RxBool isPasswordRead = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  RxBool isLogin = false.obs;

  RxBool showLoader = false.obs;
  RxString selectedCountryCode = ''.obs;

  String? isRegister;
  RxBool isMobileEnable = true.obs;

  String? selecteddate;

  ///Login Api Calling
  void onLoginTap(String code) async {
    showLoader.value = true;
    try {
      String email = '';
      String password = '';
      await TalatService().login({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.countryCodeKey: selectedCountryCode.value,
        ConstantStrings.mobileNoKey: emailController.text.isNotEmpty == true
            ? ""
            : phoneNumberController.text,
        ConstantStrings.deviceTokenKey: '1',
        ConstantStrings.emailKey: phoneNumberController.text.isNotEmpty == true
            ? ""
            : emailController.text,
        ConstantStrings.firebaseTokenKey: firebaseToken.value,
        ConstantStrings.passwordKey:
            phoneNumberController.text.isNotEmpty == true
                ? ""
                : passwordController.text,
      }).then((response) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (response.data["code"] == "1") {
          var userDetail = UserDetailModel.fromJson(response.data);
          selecteddate = userDetail.result?[0].dob;

          if (userDetail.result?[0].notificationStatus == null) {
            TalatService().notificationSettingListApi({
              ConstantStrings.userTypeKey: userDetail.result?[0].userType ?? "",
              ConstantStrings.deviceTokenKey: userDetail.result?[0].token,
              ConstantStrings.deviceTypeKey: '1',
              ConstantStrings.userIdKey: userDetail.result?[0].userId,
              ConstantStrings.languageId: language ?? "1",
              ConstantStrings.isChecked: "1",
            });
          }
          await SharedPref.setString(
              PreferenceConstants.token, userDetail.result?[0].token);
          prefs.setString(PreferenceConstants.notification_setting_status,
              userDetail.result?[0].notificationStatus ?? "1");
          prefs.setString(PreferenceConstants.laguagecode,
              userDetail.result?[0].languageId ?? "1");
          await SharedPref.setString(PreferenceConstants.contryCodeKey,
              userDetail.result?[0].countryCode);
          await SharedPref.setString(
              PreferenceConstants.userType, userDetail.result?[0].userType);
          await SharedPref.setString(
              PreferenceConstants.userId, userDetail.result?[0].userId);
          await SharedPref.setString(PreferenceConstants.laguagecode,
              userDetail.result?[0].languageId);
          await SharedPref.setString(
              PreferenceConstants.name, userDetail.result?[0].name);
          await SharedPref.setString(
              PreferenceConstants.email, userDetail.result?[0].email);
          await SharedPref.setString(
              PreferenceConstants.mobileKey, userDetail.result?[0].mobileNo);
          await SharedPref.setString(
              PreferenceConstants.genderKey, userDetail.result?[0].gender);
          await SharedPref.setString(
              PreferenceConstants.dobKey, userDetail.result?[0].dob);

          await SharedPref.setString(
              PreferenceConstants.savePassword, userDetail.result?[0].password);

          TabbarBinding().dependencies();
          Get.find<DashboardController>().update();
          Get.find<DashboardController>().getPopularActivityList();

          OtpBinding().dependencies();
          Get.find<OtpController>().hintOtp.value =
              response.data['result'][0]['otp'];
          Get.find<OtpController>().phoneNo =
              response.data['result'][0]['mobile_no'];
          Get.find<OtpController>().countryCode.value =
              selectedCountryCode.value;
          response.data['result'][0]['otp'];

          if (phoneNumberController.text.isNotEmpty &&
              userDetail.result?[0].otp!.isNotEmpty == true) {
            if (isNotLoggedIn.value == "0") {
              Get.toNamed(AppRouteNameConstant.otpScreen);
            } else {
              Get.offAndToNamed(AppRouteNameConstant.otpScreen);
            }
          } else {
            if (isNotLoggedIn.value == "0") {
              Get.offAllNamed(AppRouteNameConstant.tabScreen);
            } else {
              Get.back();
            }
          }
        } else if (response.data["code"] == "-4" &&
            response.data["message"] == "delete_account") {
          showLoader.value = false;
          // Get.back();
          CommonWidgets().showToastMessage(response.data["message"]);
        } else if (response.data["code"] == "-1") {
          showLoader.value = false;
          // Get.back();
          CommonWidgets().showToastMessage(response.data["message"]);
        } else if (response.data["message"] == "incorrect_password") {
          showLoader.value = false;
          // Get.back();
          CommonWidgets().showToastMessage(response.data["message"]);
        }
      }).catchError((error) {
        debugPrint(error.toString());
        // Get.back();

        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showLoader.value = false;
  }

  ///Check Validation
  Future<void> isLogedIn(String value) async {
    fcmToken = await SharedPref.getString(PreferenceConstants.FCM_TOKEN);
    print(fcmToken);
    String? errorMessage;
    if (phoneNumberController.text.isEmpty &&
        emailController.text.isEmpty &&
        passwordController.text.isEmpty) {
      errorMessage = "please_enter_your_mobile_or_email";
    } else if (phoneNumberController.text.isNotEmpty &&
        phoneNumberController.text.length < 8) {
      errorMessage = "please_enter_valid_number";
    } else {
      if (phoneNumberController.text.isEmpty) {
        if ((emailController.text.isEmpty)) {
          errorMessage = "enetr_email_address";
        } else if (!GetUtils.isEmail(emailController.text.trim().toString())) {
          errorMessage = "enter_valid_email_address";
        } else if (passwordController.text.isEmpty) {
          errorMessage = "please_enter_password";
        } else if (passwordController.text.length < 8) {
          errorMessage = "password_length_error";
        }
      }
    }

    if (errorMessage != null && errorMessage.isNotEmpty) {
      CommonWidgets().customSnackBar("Error", errorMessage);
    } else {
      onLoginTap(value);
    }
  }
}
