import 'package:get/get.dart';
import 'package:talat/src/screens/auth/registration/registration_screen_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationController());
  }
}
