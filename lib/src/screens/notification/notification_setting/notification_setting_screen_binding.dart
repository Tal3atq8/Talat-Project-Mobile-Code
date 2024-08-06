import 'package:get/get.dart';
import 'package:talat/src/screens/notification/notification_setting/notification_setting_screen_controller.dart';

class NotificationSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationSettingController());
  }
}
