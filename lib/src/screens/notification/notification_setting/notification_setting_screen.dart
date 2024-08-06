import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/notification/notification_setting/notification_setting_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/utility.dart';

class NotificationSetting extends StatelessWidget {
  NotificationSetting({Key? key}) : super(key: key);
  final ServiceProvidercontroller = Get.put(NotificationSettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(
        title: toLabelValue(ConstantStrings.notificationSettingText),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, left: 16),
                    child:
                        Text(toLabelValue("notification_setting_button_label")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(
                      height: 100,
                      width: 60,
                      child: Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: FlutterSwitch(
                            width: 51.0,
                            height: 28,
                            toggleSize: 23,
                            value: ServiceProvidercontroller
                                .notificationEnabled.value,
                            borderRadius: 20,
                            padding: 2.0,
                            activeColor: ColorConstant.appThemeColor,
                            inactiveColor: ColorConstant.lightTextGrayColor,
                            toggleColor: ColorConstant.whiteColor,
                            showOnOff: false,
                            onToggle: (val) {
                              ServiceProvidercontroller
                                  .notificationEnabled.value = val;
                              ServiceProvidercontroller.update();
                              ServiceProvidercontroller
                                  .getNotificationSettingList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              // Divider(
              //     thickness: 1, height: 1, color: ColorConstant.lightGrayColor),
            ],
          ),
        ),
      ),
    );
  }
}
