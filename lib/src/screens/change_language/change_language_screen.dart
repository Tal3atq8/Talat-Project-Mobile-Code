import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';

import '../../theme/constant_label.dart';
import '../../utils/common_widgets.dart';
import 'change_language_screen_controller.dart';

class ChangeLanguage extends GetWidget<ChangeLanguageController> {
  ChangeLanguage({Key? key}) : super(key: key);
  final ServiceProvidercontroller = Get.put(ChangeLanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(
        title: toLabelValue(ConstantsLabelKeys.changeLanguageText).toString(),
      ),
      body: GetBuilder<ChangeLanguageController>(builder: (controller) {
        return Column(
          children: [
            InkWell(
              onTap: () async {
                controller.setOrderType("1");
                controller.isEnglishselected.value = true;
                var locale = const Locale('en', 'US');

                await SharedPref.setString(PreferenceConstants.laguagecode, '1');
                Get.find<DashboardController>().update();
                Get.find<DashboardController>().onInit();
                language = "1";
                Get.updateLocale(locale);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(toLabelValue("english")),
                    Radio(
                      value: '1',
                      groupValue: language,
                      // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (String? value) async {
                        controller.setOrderType(value!);
                        controller.isEnglishselected.value = true;
                        var locale = const Locale('en', 'US');
                        // SharedPref.removeSharedPref(
                        //     PreferenceConstants.laguagecode);
                        await SharedPref.setString(PreferenceConstants.laguagecode, '1');
                        Get.find<DashboardController>().update();
                        Get.find<DashboardController>().onInit();
                        language = "1";
                        controller.update();
                        // globals.language = describeEnum(SelectLanguage.en);
                        Get.updateLocale(locale);
                        debugPrint('${SharedPref.getString(PreferenceConstants.laguagecode)}');
                      },
                      activeColor: ColorConstant.appThemeColor,
                    ),
                  ],
                ),
              ),
            ),
            Divider(thickness: 1, height: 1, color: ColorConstant.lightGrayColor),
            InkWell(
              onTap: () async {
                controller.setOrderType("2");
                controller.isEnglishselected.value = true;
                var locale = const Locale('ar', 'AR');
                // SharedPref.removeSharedPref(
                //     PreferenceConstants.laguagecode);
                await SharedPref.setString(PreferenceConstants.laguagecode, '2');
                Get.find<DashboardController>().update();
                Get.find<DashboardController>().onInit();
                language = "2";
                // globals.language = describeEnum(SelectLanguage.ar);
                debugPrint('${SharedPref.getString(PreferenceConstants.laguagecode)}');
                controller.update();
                Get.updateLocale(locale);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(toLabelValue("arabic")),
                    Radio(
                      value: '2',
                      groupValue: language,
                      onChanged: (String? value) async {
                        controller.setOrderType(value!);
                        controller.isEnglishselected.value = true;
                        var locale = const Locale('ar', 'AR');
                        await SharedPref.setString(PreferenceConstants.laguagecode, '2');
                        Get.find<DashboardController>().update();
                        Get.find<DashboardController>().onInit();
                        language = "2";
                        // globals.language = describeEnum(SelectLanguage.ar);
                        Get.updateLocale(locale);
                      },
                      activeColor: ColorConstant.appThemeColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
