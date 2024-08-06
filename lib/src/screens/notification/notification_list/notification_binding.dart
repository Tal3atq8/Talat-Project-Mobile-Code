import 'package:get/get.dart';
import 'package:talat/src/screens/notification/notification_list/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
