import 'package:get/get.dart';
import 'package:talat/src/screens/my_booking/my_booking_screen_controller.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyBookingScreenController());
  }
}
