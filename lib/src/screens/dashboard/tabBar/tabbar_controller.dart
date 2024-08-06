import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/main.dart';
import 'package:talat/src/models/label_model.dart';
import 'package:talat/src/screens/dashboard/tabBar/bottom_navigation.dart/tab_navigator.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/widgets/changeLanguage/localization.dart';

class TabbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };

  static TabbarController get to => Get.isRegistered<TabbarController>() ? Get.find() : Get.put(TabbarController());
  @override
  void onInit() async {
    super.onInit();

    TalatService().getLabels().then((response) async {
      if (response.data['code'] == "1") {
        label.value = LabelModel.fromJson(response.data);

        labelResult.value = label.value.result!;
        // debugPrint(label.value);
        WorldLanguage().addLabelKeyToModel();
      }
    });
  }

  void selectTab(var index) {
    currentIndex.value = index.value;
  }

  Widget buildOffstageNavigator(int tabItem) {
    return Offstage(
      offstage: currentIndex.value != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentIndex.value]!,
        index: currentIndex.value,
      ),
    );
  }
}
