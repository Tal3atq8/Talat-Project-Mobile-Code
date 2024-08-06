import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_binding.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/screens/service_provider/service_provider_controller.dart';
import 'package:talat/src/utils/acivity_item_widget.dart';
import 'package:talat/src/utils/common_widgets.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';
import '../activite/activity_detail/activity_detail_controller.dart';

class ServiceProviderActivityList extends StatelessWidget {
  ServiceProviderActivityList({super.key});

  final serviceProviderController = Get.find<ServiceProviderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarNoSearchBar(
        title: providerName.value,
      ),
      body: Obx(() => (serviceProviderController.showLoader.value ||
              serviceProviderController.showProviderActivityLoader.value)
          ? const CommonLoading()
          : Stack(
              children: [
                IgnorePointer(
                    ignoring: serviceProviderController.showLoader.value
                        ? true
                        : false,
                    child: (serviceProviderController.providerActivityList.value
                                    .result?.itemList?.data !=
                                null &&
                            serviceProviderController.providerActivityList.value
                                .result!.itemList!.data!.isNotEmpty)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: SmartRefresher(
                              controller:
                                  serviceProviderController.refreshController,
                              onRefresh: () {
                                serviceProviderController
                                    .serviceProviderActivityList(
                                        isRefresh: true);
                              },
                              enablePullDown: true,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: serviceProviderController
                                        .providerActivityList
                                        .value
                                        .result
                                        ?.itemList
                                        ?.data
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  var popularListData =
                                      serviceProviderController
                                          .providerActivityList
                                          .value
                                          .result
                                          ?.itemList
                                          ?.data?[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ActivityItemWidget(
                                      onBannerTap: () {
                                        providerID.value = popularListData
                                                ?.serviceProviderId
                                                .toString() ??
                                            '';
                                        itemID.value =
                                            popularListData?.id.toString() ??
                                                '';
                                        ActivityDetailBinding().dependencies();
                                        Get.find<ActivityDetailController>()
                                            .selectCategoryIndex = 0.obs;
                                        Get.find<ActivityDetailController>()
                                            .myTabs = [];

                                        Get.find<ActivityDetailController>()
                                            .categoryActivityDetail();

                                        serviceProviderController.update();
                                        Get.toNamed(
                                          AppRouteNameConstant
                                              .activityDetailScreen,
                                        );
                                      },
                                      isIconDisplay: (serviceProviderController
                                                  .token?.isNotEmpty ==
                                              true &&
                                          serviceProviderController.token !=
                                              null),
                                      favShowLoader: serviceProviderController
                                          .favShowLoader,
                                      onFavIconTap: () {
                                        serviceProviderController
                                            .selectedIndex.value = index;
                                        popularListData?.isFav == 0
                                            ? serviceProviderController
                                                .addFavouriteItem(
                                                    popularListData?.id
                                                        .toString())
                                            : serviceProviderController
                                                .deleteFavouriteItem(
                                                    popularListData?.id
                                                        .toString());
                                      },
                                      isNotFav: popularListData?.isFav == 0,
                                      itemImageUrl:
                                          popularListData?.categoryImage ?? '',
                                      serviceProviderImageUrl:
                                          popularListData?.serviceProviderImage,
                                      serviceProviderName:
                                          popularListData?.categoryName,
                                      serviceProviderAddress:
                                          popularListData?.serviceProviderName,
                                      serviceProviderDistance:
                                          popularListData?.categoryDistance,
                                      isCurrentIndex: index,
                                      isSelectedIndex: serviceProviderController
                                          .selectedIndex,
                                    ),
                                  );
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
