import 'package:get/get.dart';
import 'package:talat/src/screens/cms/cms_screen_controller.dart';

class CmsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CmsController());
  }
}
