import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:talat/src/screens/extra_activity/extra_activity_detail_controller.dart';

class ExtraActivityDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExtraActivityDetailController());
  }
}
