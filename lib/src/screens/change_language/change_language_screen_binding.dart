import 'package:get/get.dart';
import 'package:talat/src/screens/change_language/change_language_screen_controller.dart';

class ChangeLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeLanguageController());
  }
}
