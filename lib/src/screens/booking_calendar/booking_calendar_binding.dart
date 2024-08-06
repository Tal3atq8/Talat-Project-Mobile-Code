import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:talat/src/screens/booking_calendar/booking_calendar_controller.dart';

class BookingCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingCalendarController());
  }
}
