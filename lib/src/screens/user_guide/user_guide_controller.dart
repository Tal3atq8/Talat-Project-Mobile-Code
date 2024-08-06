import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talat/src/models/slider_model.dart';

class UserGuideController extends GetxController {
  RxList<SliderModel> mySlides = <SliderModel>[].obs;

  RxInt slideIndex = 0.obs;
  RxBool isCurrentPage = false.obs;

  RxInt slideTextIndex = 0.obs;
  PageController? imageController;
  PageController? textController;
  @override
  void onInit() {
    super.onInit();
    mySlides.value = getSlides();
    imageController = PageController();
    textController = PageController();
    update();
  }
}
