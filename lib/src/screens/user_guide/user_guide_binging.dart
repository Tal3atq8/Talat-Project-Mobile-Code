import 'package:get/get.dart';
import 'package:talat/src/screens/user_guide/user_guide_controller.dart';

class UserGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserGuideController());
  }
}
