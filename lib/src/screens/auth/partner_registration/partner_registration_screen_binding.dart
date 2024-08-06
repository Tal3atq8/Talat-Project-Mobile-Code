import 'package:get/get.dart';
import 'package:talat/src/screens/auth/partner_registration/partner_registration_screen_controller.dart';

class PartnerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PartnerRegistrationController());
  }
}
