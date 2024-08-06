import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/edit_profile_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../utils/global_constants.dart';

class RegistrationController extends GetxController {
  final registrationFormKey = GlobalKey<FormState>();
  RxInt genderValue = 0.obs;
  RxBool isSecuretext = true.obs;
  Rx<bool> isShowPassword = false.obs;

  RxBool showLoader = false.obs;
  RxBool isUserRegister = false.obs;
  String? token;
  String? isRegister;
  String? userType;
  String? userId;
  String? countryCode;
  var selected = 'male'.obs;

  var password;
  var isName;
  var dob;
  var gendarValue;

  String emetytext = "US";

  void select(String gender) {
    selected.value = gender;
    update(); // update the selected option
  }

  List<String> supportlist = [];

  toggle() {
    isSecuretext.value = !isSecuretext.value;
  }

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    userType = await SharedPref.getString(PreferenceConstants.userType);
    countryCode = await SharedPref.getString(PreferenceConstants.contryCodeKey);

    update();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController showDobController = TextEditingController();

  ///Signup  Api calling
  void signupApiCalling() async {
    String? errorMessage;
    if (fullNameController.value.text.trim().isEmpty) {
      errorMessage = "enter_full_name";
    } else if (emailController.value.text.trim().isEmpty) {
      errorMessage = "enetr_email_address";
    } else if (!GetUtils.isEmail(emailController.value.text.trim())) {
      errorMessage = "enter_valid_email_address";
    } else if (passwordController.value.text.trim().isEmpty) {
      errorMessage = "please_enter_password";
    } else if (passwordController.value.text.trim().length < 8) {
      errorMessage = "password_length_error";
    } else if (dobController.value.text.trim().isEmpty) {
      errorMessage = "please_sect_dateofbirth";
    }

    if (errorMessage != null && errorMessage.isNotEmpty) {
      CommonWidgets().customSnackBar("Error", errorMessage);
    } else {
      showLoader.value = true;
      try {
        await TalatService().editProfileApi({
          ConstantStrings.userTypeKey: userType,
          ConstantStrings.deviceTokenKey: token,
          ConstantStrings.deviceTypeKey: '1',
          ConstantStrings.userIdKey: userId,
          ConstantStrings.passwordKey: passwordController.text,
          ConstantStrings.nameKey: fullNameController.text,
          ConstantStrings.emailKey: emailController.text,
          ConstantStrings.dobKey: dobController.text,
          ConstantStrings.languageIdKey: 1,
          ConstantStrings.genderKey: selected.value,
          ConstantStrings.countryCodeKey: ConstantStrings.countryCodeKuwait,
        }).then((response) async {
          if (response.data["code"] == "1") {
            var userDetail = EditProfileMode.fromJson(response.data);
            var dobDates = userDetail.user?.dateOfBirth;

            //   password=userDetail.user.pa;
            //    isRegister=response.data['result'][0]['is_register'];
            var isUseerName = userDetail.user?.name;
            password = await SharedPref.setString(
                PreferenceConstants.savePassword, passwordController.text);
            await SharedPref.setString(
                PreferenceConstants.email, userDetail.user?.email);
            await SharedPref.setString(
                PreferenceConstants.name, userDetail.user?.name);

            await SharedPref.setString(
                PreferenceConstants.genderKey, userDetail.user?.gender);
            await SharedPref.setString(
                PreferenceConstants.dobKey, userDetail.user?.dateOfBirth);
            showLoader.value = false;

            CommonWidgets().showToastMessage(
                ConstantsLabelKeys.user_registered_successfully);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
          } else if (response.data["code"] == "-1") {
            showLoader.value = false;
            update();

            CommonWidgets().showToastMessage("email_already_register");
          } else if (response.data["code"] == "-7") {
            CommonWidgets().showToastMessage('user_login_other_device');
            language =
                await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(
                PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
            update();
          } else if (response.data["code"] == "-1" &&
              response.data["message"] == "inactive_account") {
            CommonWidgets().showToastMessage('inactive_account');
            language =
                await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(
                PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
            update();
            showLoader(false);
          } else if (response.data["code"] == "-4" &&
              response.data["message"] == "delete_account") {
            showLoader.value = false;
            CommonWidgets().showToastMessage(response.data["message"]);
            language =
                await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(
                PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
            update();
          }
        }).catchError((error) {
          debugPrint(error.toString());
          CommonWidgets()
              .customSnackBar('Talat', 'User Not Register Successfully');

          showLoader.value = false;
          // Get.back();
        });
      } on DioError catch (e) {
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
        showLoader.value = false;
        Get.back();
      }
    }
  }
}
