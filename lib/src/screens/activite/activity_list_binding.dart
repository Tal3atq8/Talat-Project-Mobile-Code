import 'package:get/get.dart';
import 'package:talat/src/screens/activite/activity_list_controller.dart';

class ActivityListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityListController());
  }
}
