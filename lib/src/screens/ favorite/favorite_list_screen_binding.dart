import 'package:get/get.dart';
import 'package:talat/src/screens/%20favorite/favorite_list_screen_controller.dart';

class FavoriteListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteListController());
  }
}
