import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:talat/src/models/cms_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';
import '../../utils/preference/preference_keys.dart';

class CmsController extends GetxController {
  final cms = CmsModel().obs;

  RxString cmsData = "".obs;
  RxInt cmsDataIndex = 0.obs;
  RxBool showLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    // cmsType = Get.arguments;
    cms.value = CmsModel();
    getCmsData();
    update();
  }

  ///CMS api calling
  void getCmsData() async {
    showLoader.value = true;

    await TalatService().cms({
      ConstantStrings.languageId: language ?? "1",
    }).then((response) async {
      if (response.data['code'] == "1") {
        cms.value = CmsModel.fromJson(response.data);
        for (var cms in cms.value.result!) {
          if (cms.cmsTitle!.toLowerCase().replaceAll(" ", "") == describeEnum(Get.arguments).toString()) {
            cmsData.value = cms.cmsDescription!;
          } else {
            debugPrint(cms.cmsTitle!.toLowerCase().replaceAll(" ", ""));
          }
        }
        showLoader.value = false;
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
    showLoader.value = false;
    update();
  }
}
