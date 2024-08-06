import 'package:get/get.dart';
import 'package:talat/src/screens/map/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MapScreenController());
  }
}
