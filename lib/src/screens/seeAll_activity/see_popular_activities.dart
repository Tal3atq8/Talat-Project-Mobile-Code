import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_controller.dart';
import 'package:talat/src/utils/utility.dart';

import '../../app_routes/app_routes.dart';
import '../../theme/color_constants.dart';
import '../../theme/constant_label.dart';
import '../../utils/acivity_item_widget.dart';
import '../../utils/common_widgets.dart';
import '../../utils/global_constants.dart';
import '../activite/activity_detail/activity_detail_binding.dart';
import '../dashboard/dashboard_screen_controller.dart';

class SeeAllPopularActivities extends StatelessWidget {
  SeeAllPopularActivities({super.key});

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(
        title: toLabelValue(ConstantsLabelKeys.popularActivitiesText),
      ),
      body: Obx(() => Stack(
            children: [
              IgnorePointer(
                  ignoring: dashboardController.showPopularItemsLoader.value ? true : false,
                  child: (dashboardController.popularActivityItemList.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: SmartRefresher(
                            enablePullUp: true,
                            enablePullDown: true,
                            controller: dashboardController.popularRefreshController,
                            header: MaterialClassicHeader(
                              backgroundColor: ColorConstant.appThemeColor,
                              color: ColorConstant.whiteBackgroundColor,
                            ),
                            footer: customFooterSmartRefresh(),
                            onLoading: () {
                              dashboardController.popularPage.value = dashboardController.popularPage.value + 1;
                              dashboardController.popularLimit.value = 5;
                              dashboardController.getPopularActivityList();
                            },
                            onRefresh: () {
                              dashboardController.popularPage.value = 1;
                              dashboardController.popularLimit.value = 5;
                              dashboardController.getPopularActivityList(isRefresh: true);
                            },
                            child: ListView.builder(
                              // physics: const BouncingScrollPhysics(),
                              itemCount: dashboardController.popularActivityItemList.length,
                              itemBuilder: (context, index) {
                                var popularListData = dashboardController.popularActivityItemList[index];
                                return Obx(() {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ActivityItemWidget(
                                      onBannerTap: () {
                                        providerID.value = popularListData.providerId ?? '';
                                        itemID.value = popularListData.id ?? '';
                                        ActivityDetailBinding().dependencies();

                                        Get.find<ActivityDetailController>().categoryActivityDetail();

                                        dashboardController.update();
                                        Get.toNamed(
                                          AppRouteNameConstant.activityDetailScreen,
                                        );
                                      },
                                      isIconDisplay: (dashboardController.name?.isNotEmpty == true &&
                                          dashboardController.name != null),
                                      favShowLoader: dashboardController.favShowLoader,
                                      onFavIconTap: () {
                                        dashboardController.selectedIndex.value = index;

                                        (!dashboardController.popularActivityItemListFav.contains(popularListData.id))
                                            ? dashboardController.addFavouriteItem(popularListData.id)
                                            : dashboardController.deleteFavouriteItem(popularListData.id);
                                      },
                                      isNotFav:
                                          !dashboardController.popularActivityItemListFav.contains(popularListData.id),
                                      itemImageUrl: popularListData.itemImage ?? '',
                                      serviceProviderImageUrl: popularListData.serviceProviderImage,
                                      serviceProviderName: popularListData.activityName,
                                      serviceProviderAddress: popularListData.providerName.toString(),
                                      serviceProviderDistance: popularListData.distance.toString(),
                                      isCurrentIndex: index,
                                      isSelectedIndex: dashboardController.selectedIndex,
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        )
                      : const CommonNoDataFound()),
            ],
          )),
    );
  }
}

class CommonLoading extends StatelessWidget {
  const CommonLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: ColorConstant.appThemeColor,
    ));
  }
}
