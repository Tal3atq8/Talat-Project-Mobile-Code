import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_binding.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_controller.dart';
import 'package:talat/src/screens/activite/activity_list_controller.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/size_utils.dart';

import '../../models/get_category_activity_detail_model.dart';
import '../../theme/color_constants.dart';
import '../../utils/acivity_item_widget.dart';
import '../../utils/global_constants.dart';
import '../../utils/preference/preference_keys.dart';

class ActivityList extends StatelessWidget {
  ActivityList({super.key});
  final controller = Get.find<ActivityListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(
        title: activityName.value,
        onBackPressed: () async {
          await SharedPref.removeSharedPref(PreferenceConstants.apply);
        },
        actionItems: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 14,
              onPressed: () {
                Get.toNamed(AppRouteNameConstant.filterScreen);
              },
              icon: Image.asset(
                ImageConstant.filterIcon,
                height: getVerticalSize(18.00),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.myshowLoader.value
            ? Center(
                child: CircularProgressIndicator(
                color: ColorConstant.appThemeColor,
              ))
            : (controller.categoryItem.value.result?.itemList?.data != null &&
                    controller.categoryItem.value.result!.itemList!.data!.isNotEmpty)
                ? Obx(() {
                    return Stack(
                      children: [
                        IgnorePointer(
                          ignoring: controller.myshowLoader.value ? true : false,
                          child: SmartRefresher(
                            header: MaterialClassicHeader(
                              backgroundColor: ColorConstant.appThemeColor,
                              color: ColorConstant.whiteBackgroundColor,
                            ),
                            onRefresh: () {
                              controller.fetchActivityItemList();
                            },
                            // footer: ,
                            controller: controller.activityRefreshController,
                            child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                itemCount: controller.categoryItem.value.result?.itemList?.data?.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var favoriteListData = controller.categoryItem.value.result?.itemList?.data?[index];
                                  return ActivityItemWidget(
                                    onBannerTap: () {
                                      activityDetailItem.value = ActivityDetailItem();
                                      ActivityDetailBinding().dependencies();
                                      Get.find<ActivityDetailController>().selectItemIndexId.value = "";
                                      Get.find<ActivityDetailController>().isOpenBottomSheet.value = false;

                                      if (favoriteListData?.serviceProviderId != null) {
                                        providerID.value = favoriteListData!.serviceProviderId.toString();
                                      }
                                      itemID.value = favoriteListData?.id.toString() ?? "";
                                      Get.find<ActivityDetailController>().categoryActivityDetail();
                                      Get.toNamed(AppRouteNameConstant.activityDetailScreen);
                                    },
                                    isIconDisplay: (controller.name?.isNotEmpty == true && controller.name != null),
                                    favShowLoader: controller.favLoader,
                                    onFavIconTap: () {
                                      controller.isSelected.value = index;
                                      favoriteListData?.isFav == 0
                                          ? controller.addFavouriteItem(favoriteListData?.id.toString())
                                          : controller.deleteFavouriteItem(favoriteListData?.id.toString());
                                    },
                                    isNotFav: favoriteListData?.isFav == 0,
                                    itemImageUrl: favoriteListData?.main_image ?? '',
                                    serviceProviderImageUrl: favoriteListData?.serviceProviderImage,
                                    serviceProviderName: favoriteListData?.categoryName,
                                    serviceProviderAddress: favoriteListData?.serviceProviderName,
                                    serviceProviderDistance:
                                        (userLat.value == "") ? "" : favoriteListData?.categoryDistance,
                                    isCurrentIndex: index,
                                    isSelectedIndex: controller.isSelected,
                                  );
                                }),
                          ),
                        ),
                        if (controller.myshowLoader.value)
                          Center(
                            child: CircularProgressIndicator(
                              color: ColorConstant.appThemeColor,
                            ),
                          ),
                      ],
                    );
                  })
                : Center(child: SizedBox(width: Get.width, height: Get.height * 0.5, child: const CommonNoDataFound())),
      ),
    );
  }
}
