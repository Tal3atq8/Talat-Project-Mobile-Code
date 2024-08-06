import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/resend_otp_model.dart';
import 'package:talat/src/models/user_deati_model.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_controller.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_binding.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

class OtpController extends GetxController {
  RxInt start = 120.obs;
  final otpFormKey = GlobalKey<FormState>();
  RxBool showLoader = false.obs;
  RxBool otpshowLoader = false.obs;
  RxString hintOtp = "".obs;
  String phoneNo = "";
  String email = "";
  RxString countryCode = "".obs;
  Rxn<Timer> timer = Rxn<Timer>();
  RxBool isLoading = false.obs;
  String? userType;
  String? token;
  String? userId;
  String? countryCodes;

  RxString otpCode = "".obs;
  TextEditingController otpController = TextEditingController();

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    userType = await SharedPref.getString(PreferenceConstants.userType);

    listenOtp();
    Timer(
      Duration(seconds: start.value),
      resend,
    );
    startTimer();
  }

  void resend() {
    print(timer.value);
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    timer.value = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          isLoading = false.obs;
        } else {
          start.value--;
        }
      },
    );
  }

  void listenOtp() async {
    SmsAutoFill().listenForCode();
    print("OTP Listen is called");
  }

  ///Otp Api Calling
  void onOtpTap() async {
    showLoader.value = true;
    if (otpCode.value.isNotEmpty && otpCode.value.length == 6) {
      try {
        await TalatService().verifyOtp({
          ConstantStrings.userTypeKey: userType,
          ConstantStrings.deviceTypeKey: '1',
          ConstantStrings.otpKey: otpCode.value,
          ConstantStrings.userIdKey: userId,
          ConstantStrings.deviceTokenKey: token,
        }).then((response) async {
          print(response);
          if (response.data["code"] == "1") {
            await SharedPref.removeSharedPref(PreferenceConstants.token);
            DashboardBinding().dependencies();

            Get.find<DashboardController>().popularActivityItems();
            Get.find<DashboardController>().update();
            var userDetail = UserDetailModel.fromJson(response.data);
            await SharedPref.setString(
                PreferenceConstants.token, userDetail.result?[0].token);
            await SharedPref.setString(PreferenceConstants.isMobileVerifiedKey,
                userDetail.result?[0].isMobileVerified);
            timer.value?.cancel();

            if (userDetail.result?[0].name!.isNotEmpty == true) {
              if (isNotLoggedIn.value == "1") {
                Get.find<ActivityDetailController>().onInit();
                Get.back();
              } else {
                Get.offAllNamed(AppRouteNameConstant.tabScreen);
              }
            } else {
              if (isNotLoggedIn.value == "1") {
                Get.toNamed(AppRouteNameConstant.registrationScreen);
              } else {
                Get.offAndToNamed(AppRouteNameConstant.registrationScreen);
              }
            }
          } else if (response.data["code"] == "-4" &&
              response.data["message"] == "delete_account") {
            CommonWidgets().showToastMessage("${response.data["message"]}");
          }
        }).catchError((error) {
          debugPrint(error.toString());
          Get.back();
          showLoader(false);
        });
      } on DioError catch (e) {
        Get.back();
        showLoader(false);
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      }
      showLoader(false);
    } else if (otpCode.isEmpty) {
      showLoader(false);
      CommonWidgets().customSnackBar("", "otp_empty");
    } else if (otpCode.value.length != 6) {
      showLoader(false);
      CommonWidgets().customSnackBar("", "otp_less_than_6_digit");
    }
  }

  ///ResendOtp Api Calling
  void onReSendOtpTap() async {
    otpCode.value = "";
    hintOtp.value = "";

    try {
      await TalatService().reSendOtp({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
      }).then((response) async {
        print(response.data['message']);
        if (response.data["code"] == "1") {
          var resendModel = ResendOtpModel.fromJson(response.data);

          hintOtp.value = resendModel.result!.first.otp!;
          CommonWidgets().showToastMessage("otp_sent");
        } else if (response.data["code"] == "-4") {
          Get.snackbar('Error', 'Please Enter otp number',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: ColorConstant.blackColor,
              colorText: ColorConstant.whiteColor);
        }
      }).catchError((error) {
        debugPrint(error.toString());
      });
    } on DioError catch (e) {
      Get.back();

      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
  }
}
