import 'package:get/get.dart';
import 'package:talat/src/screens/auth/otp/otp_screen_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
