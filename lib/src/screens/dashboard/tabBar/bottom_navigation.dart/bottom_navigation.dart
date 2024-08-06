import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/network/netwrok_manager_controller.dart';
import 'package:talat/src/screens/%20favorite/favorite_list_screen_controller.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_binding.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/dashboard/tabBar/tabbar_controller.dart';
import 'package:talat/src/screens/notification/notification_list/notification_controller.dart';
import 'package:talat/src/screens/profile/profile_screen_binding.dart';
import 'package:talat/src/screens/profile/profile_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/utility.dart';

class TabBar extends StatelessWidget {
  TabBar({Key? key}) : super(key: key);
  final networkController = Get.put(GetXNetworkManager());

  final tabController = Get.find<TabbarController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Obx(
          () => Scaffold(
            backgroundColor: Colors.white,
            body: tabController.buildOffstageNavigator(tabController.currentIndex.value),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: ColorConstant.whiteColor,
              selectedItemColor: ColorConstant.appThemeColor,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: tabController.currentIndex.value,
              unselectedItemColor: ColorConstant.grayColor,
              showSelectedLabels: true,
              onTap: (value) {
                tabController.currentIndex.value = value;
                if (value == 0) {
                  DashboardBinding().dependencies();
                  Get.find<DashboardController>().page.value = 1;
                  Get.find<DashboardController>().initLimit.value = 5;
                  Get.find<DashboardController>().showLoader.value = true;
                  Get.find<DashboardController>().getData();
                  // Get.find<DashboardController>().onInit();
                  Get.find<DashboardController>().getPopularActivityList();

                  Get.find<DashboardController>().getBannerList();
                  Get.find<DashboardController>().getBrowseActivityList();
                  Get.find<DashboardController>().update();
                }
                if (value == 1) {
                  Get.find<FavoriteListController>().myshowLoader.value = true;
                  Get.find<FavoriteListController>().limit.value = 10;
                  Get.find<FavoriteListController>().pageIndex.value = 1;
                  Get.find<FavoriteListController>().onInit();
                  Get.find<FavoriteListController>().getFavouriteList();
                  Get.find<FavoriteListController>().update();
                }
                if (value == 2) {
                  Get.find<NotificationController>().onInit();
                  Get.find<NotificationController>().getNotificationList();
                }
                if (value == 3) {
                  ProfileBinding().dependencies();
                  Get.find<ProfileController>().viewProfileApi();
                  Get.find<ProfileController>().onInit();
                  Get.find<ProfileController>().update();
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(ImageConstant.talatLogo,
                      height: 26,
                      width: 26,
                      color: tabController.currentIndex.value == 0
                          ? ColorConstant.appThemeColor
                          : ColorConstant.grayColor),
                  label: toLabelValue(ConstantsLabelKeys.talatTitle).toString(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  // ImageIcon(
                  //   AssetImage(ImageConstant.dashBoardFavIcon)),
                  label: toLabelValue(ConstantsLabelKeys.saved).toString(),
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage(ImageConstant.dashBoardNotificationIcon)),
                  label: toLabelValue(ConstantsLabelKeys.notifications).toString(),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(ImageConstant.dashBoardProfileIcon,
                      height: 26,
                      width: 26,
                      color: tabController.currentIndex.value == 3
                          ? ColorConstant.appThemeColor
                          : ColorConstant.grayColor),
                  label: toLabelValue(ConstantsLabelKeys.account).toString(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
