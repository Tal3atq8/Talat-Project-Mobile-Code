import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talat/src/models/service_list_model.dart';
import 'package:talat/src/models/user_deati_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../app_routes/app_routes.dart';

class PartnerRegistrationController extends GetxController {
  final serviceItems = ServiceList().obs;
  RxString selectedCountryCode = ConstantStrings.countryCodeKuwait.obs;

  RxBool showLoader = false.obs;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController selectServicesController = TextEditingController();
  TextEditingController providerNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  Rxn<ServicesList> selectedServicesList = Rxn<ServicesList>();
  RxString selectedService = "".obs;
  RxList<ServicesList> serviceList = <ServicesList>[].obs;
  String? userId;

  @override
  void onInit() async {
    super.onInit();
    userId = await SharedPref.getString(PreferenceConstants.userId);
    update();
  }

  clearFields() {
    phoneNumberController.clear();
    providerNameController.clear();
    emailController.clear();
    businessController.clear();
    selectedServicesList = Rxn<ServicesList>();
  }

  ///Signup  Api calling
  void onSignupTap() async {
    if (providerNameController.value.text.trim().isEmpty) {
      CommonWidgets().customSnackBar("", "enter_provider_name");
    } else if (emailController.value.text.trim().isEmpty) {
      CommonWidgets().customSnackBar("", "enetr_email_address");
    } else if (!GetUtils.isEmail(emailController.text.toString().trim())) {
      CommonWidgets().customSnackBar("", "enter_valid_email");
    } else if (phoneNumberController.value.text.trim().isEmpty) {
      CommonWidgets().customSnackBar("", "enter_phone");
    } else if (phoneNumberController.value.text.trim().length < 8) {
      CommonWidgets().customSnackBar("", "please_enter_valid_number");
    } else if (businessController.value.text.trim().isEmpty) {
      CommonWidgets().customSnackBar("", "enter_description");
    } else {
      showLoader(true);

      try {
        await TalatService().signupAsPartnerApi({
          "user_type": '1',
          "language_id": language ?? "1",
          "mobile": phoneNumberController.text,
          "provider_name": providerNameController.text,
          "email": emailController.text,
          "business": businessController.text,
          "country_code": selectedCountryCode.value,
          "services":
              selectedService.value.isNotEmpty ? selectedService.value : "0",
          "user_id": userId,
        }).then((response) async {
          if (response.data["code"] == "1") {
            var userDetail = UserDetailModel.fromJson(response.data);

            Get.back();
            showLoader.value = false;
            if (response.data["message"] == "success") {
              CommonWidgets()
                  .showToastMessage("successfully_registered_as_partner");
            } else {
              CommonWidgets().showToastMessage(response.data["message"]);
              Get.back();
            }
          } else if (response.data["code"] == "-1") {
            showLoader.value = false;
            Get.back();
            CommonWidgets().customSnackBar("Error", response.data["message"]);
          } else if (response.data["code"] == "-4") {
            CommonWidgets().customSnackBar("Error", "enter_phone");
            Get.back();
            showLoader(false);
          } else if (response.data["code"] == "-7") {
            // Get.back();
            CommonWidgets().showToastMessage('user_login_other_device');
            language =
                await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(
                PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
            // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
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
            // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
            showLoader(false);
            update();
          } else if (response.data["code"] == "0") {
            CommonWidgets().showToastMessage('${response.data["message"]}');
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
            // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
            update();
          }
        }).catchError((error) {
          debugPrint(error.toString());
          // CommonWidgets().showToastMessage('${response.data["message"]}');
          clearFields();
          showLoader(false);
          Get.back();
        });
      } on DioError catch (e) {
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
        showLoader(false);
        clearFields();
        Get.back();
      }
    }
  }

  /// Get ServiceList api Calling
  void getServiceList() async {
    try {
      await TalatService().serviceListApi({
        ConstantStrings.languageId: language ?? "1",
      }).then((response) async {
        if (response.data['code'] == "1") {
          serviceList.value =
              ServiceList.fromJson(response.data).result!.servicesList!;
          if (serviceList.isNotEmpty) {
            String categoryId =
                await SharedPref.getString(ConstantStrings.emailText);
            if (categoryId.isNotEmpty) {
              selectedServicesList.value = serviceList
                  .where((element) => (element.id ?? "") == categoryId)
                  .toList()
                  .first;
            } else {
              serviceList.value = serviceList.value;
            }
          } else {
            serviceList.value = [];
          }
          print("quotesId ${response.data}");
          serviceItems.value = ServiceList.fromJson(response.data);
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

  void onCategorySelect(ServicesList? value) async {
    selectedServicesList.value = value;

    update();
  }
}
