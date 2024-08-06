import 'package:get/get.dart';
import 'package:talat/src/screens/auth/login/login_screen_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
