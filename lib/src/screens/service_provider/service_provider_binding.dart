import 'package:get/get.dart';
import 'package:talat/src/screens/service_provider/service_provider_controller.dart';

class ServiceProviderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ServiceProviderController());
  }
}
