import 'package:get/get.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/dashboard/tabBar/tabbar_controller.dart';

class TabbarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabbarController());
    Get.lazyPut(() => DashboardController());
  }
}
