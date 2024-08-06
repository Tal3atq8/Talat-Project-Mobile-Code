

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:talat/src/screens/seeAll_activity/see_all_activity_controller.dart';

class SeeAllActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SeeALLActivityController());
  }
}