import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talat/src/models/edit_profile_model.dart';
import 'package:talat/src/models/user_deati_model.dart';
import 'package:talat/src/screens/profile/profile_screen_binding.dart';
import 'package:talat/src/screens/profile/profile_screen_controller.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../app_routes/app_routes.dart';

class EditProfileController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController showDobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  var selected = ''.obs;
  DateTime? userDateOFBirth;

  RxBool showLoader = false.obs;
  RxBool showDeleteLoader = false.obs;

  String? password;

  var userType;

  String? phone;

  DateTime? newDateTime;

  String? initialCountryCode;

  void select(String gender) {
    selected.value = gender;
    update(); // update the selected option
  }

  late bool isViewed;
  String? token;
  String? userId;
  String? name;
  String? dob;
  String? email;
  String? gender;
  String? countryes;
  RxString countryCodes = "".obs;
  String? showDate;
  UserDetailModel? viewProfile;

  final RxBool? selectedGender = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getPhoneNumber();
    viewProfile = UserDetailModel();

    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    name = await SharedPref.getString(PreferenceConstants.name);
    dob = await SharedPref.getString(PreferenceConstants.dobKey);
    password = await SharedPref.getString(PreferenceConstants.savePassword);
    // gender = await SharedPref.getString(PreferenceConstants.genderKey);
    phone = await SharedPref.getString(PreferenceConstants.mobileKey);
    countryes = await SharedPref.getString(PreferenceConstants.contryCodeKey);
    email = await SharedPref.getString(PreferenceConstants.email);
    userType = await SharedPref.getString(PreferenceConstants.userType);
    DateTime tempDate = DateFormat("yyyy-MM-dd").parse(dob!);

    showDate = DateFormat(ConstantStrings.constDateFormat).format(tempDate);
    viewProfile = UserDetailModel();
    showLoader.value = true;
    viewProfileApi();
    update();
  }

  void getPhoneNumber() async {
    countryCodes.value = await SharedPref.getString(PreferenceConstants.contryCodeKey);
  }

  ///View Profile Api calling
  viewProfileApi() async {
    showLoader.value = true;
    viewProfile = null;
    try {
      await TalatService().viewProfileApi({
        ConstantStrings.userTypeKey: 1,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
      }).then((response) async {
        if (response.data["code"] == "1") {
          showLoader.value = false;
          viewProfile = UserDetailModel.fromJson(response.data);
          fullNameController.text = viewProfile!.result![0].name!;
          emailController.text = viewProfile!.result![0].email!;
          countryCodes.value = viewProfile!.result![0].countryCode!;
          phoneNumberController.text = viewProfile!.result![0].mobileNo!;
          if (viewProfile?.result?[0].dob != null && viewProfile!.result![0].dob != '0000-00-00') {
            dobController.text = DateFormat('yyyy-MM-dd').format(DateTime.parse(viewProfile?.result?[0].dob));
            showDobController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(viewProfile?.result?[0].dob));
          } else {
            showDobController.text = toLabelValue(ConstantStrings.dateOfBirthText);
          }
          selected.value = viewProfile!.result![0].gender!;
          if (viewProfile!.result![0].dob != null && viewProfile!.result![0].dob != '0000-00-00') {
            userDateOFBirth = DateTime.parse(viewProfile!.result![0].dob.toString());
          }
          name = response.data['result'][0]['name'];
          email = response.data['result'][0]['email'];
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
        showLoader(false);
        // Get.back();
      });
    } on DioError catch (e) {
      showLoader(false);
      // Get.back();
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
  }

  editProfile() async {
    String? errorMsg;

    if ((phoneNumberController.value.text != phone) ||
        (fullNameController.value.text != name) ||
        (emailController.value.text != email) ||
        (dobController.text != dob) ||
        (selected.value != viewProfile!.result![0].gender!)) {
      if (phoneNumberController.value.text.trim().isEmpty) {
        errorMsg = "enter_number";
      } else if (phoneNumberController.text.isNotEmpty && phoneNumberController.text.length < 8) {
        errorMsg = "password_length_error";
      } else if (fullNameController.value.text.trim().isEmpty) {
        errorMsg = "enter_full_name";
      } else if (fullNameController.value.text.trim().length < 3) {
        errorMsg = "full_name_length";
      } else if (emailController.value.text.trim().isEmpty) {
        errorMsg = "enetr_email_address";
      } else if (!GetUtils.isEmail(emailController.value.text.trim())) {
        errorMsg = "enter_valid_email_address";
      }
      if (errorMsg == null) {
        showLoader.value = true;
        try {
          await TalatService().updateProfileApi({
            ConstantStrings.userTypeKey: userType,
            ConstantStrings.deviceTokenKey: token,
            ConstantStrings.deviceTypeKey: '1',
            ConstantStrings.userIdKey: userId,
            ConstantStrings.nameKey: fullNameController.text,
            ConstantStrings.emailKey: emailController.text,
            ConstantStrings.passwordKey: password,
            ConstantStrings.dobKey: dobController.text,
            ConstantStrings.languageIdKey: 1,
            ConstantStrings.countryCodeKey: generalSetting?.result![0].countryCode ?? ConstantStrings.countryCodeKuwait,
            ConstantStrings.genderKey: selected.value,
          }).then((response) async {
            if (response.data["code"] == "1") {
              debugPrint("${response.data["message"]}");

              ProfileBinding().dependencies();
              showLoader(false);
              Get.find<ProfileController>().viewProfileApi();
              Get.find<ProfileController>().update();
              Get.back();
              // Get.offNamed(AppRouteNameConstant.tabScreen);
              CommonWidgets().showToastMessage('profile_update');
            } else if (response.data["code"] == "-1") {
              showLoader(false);
              CommonWidgets().showToastMessage(response.data["message"]);
              // Get.back();
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
            // Get.back();
          });
        } on DioError catch (e) {
          debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
          showLoader.value = false;
          // Get.back();
        }
      } else {
        showLoader.value = false;
        CommonWidgets().customSnackBar("title", errorMsg);
      }
    } else {
      showLoader(false);
      Get.back();
      Get.find<ProfileController>().viewProfileApi();
    }
    showLoader.value = false;
  }

  void openDialog() {
    Get.dialog(
      AlertDialog(
        // title: const Text(""),
        content: Text(toLabelValue("delete_account_message")),
        actions: [
          TextButton(
              child: Text(toLabelValue(ConstantStrings.no), style: TextStyle(color: ColorConstant.appThemeColor)),
              onPressed: () {
                Get.back();
              }),
          TextButton(
              child: Text(toLabelValue(ConstantStrings.yes),
                  style: TextStyle(
                    color: ColorConstant.appThemeColor,
                  )),
              onPressed: () {
                Get.back();
                showLoader.value = true;
                update();
                deleteAccount();
              }),
        ],
      ),
    );
  }

  deleteAccount() {
    TalatService().deleteAccount({
      "device_token": token,
      "user_id": userId,
      "user_type": userType,
      "language_id": "1",
      "device_type": "1",
    }).then((value) async {
      try {
        debugPrint('$value');
        if ((value.statusCode.toString() == "1" || value.statusCode.toString() == "200") &&
            value.data["message"] == "account_delete") {
          ProfileBinding().dependencies();
          CommonWidgets().showToastMessage(value.data["message"]);
          Future.delayed(const Duration(seconds: 2), () async {
            CommonWidgets().showToastMessage('account_delete');

            await SharedPref.clearSharedPref();

            Get.back();

            update();
          });
          showLoader.value = false;
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);

          update();
        } else {
          CommonWidgets().showToastMessage(value.data["message"]);
        }
      } catch (e) {
        Get.back();
        showLoader.value = false;
        update();
        debugPrint(e.toString());
      }
    });
  }
}
