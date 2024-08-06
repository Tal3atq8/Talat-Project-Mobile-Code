import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';

import '../../theme/constant_label.dart';
import '../../utils/acivity_item_widget.dart';
import '../../utils/common_widgets.dart';
import '../activite/activity_detail/activity_detail_binding.dart';
import '../activite/activity_detail/activity_detail_controller.dart';
import 'favorite_list_screen_controller.dart';

class FavoriteList extends StatelessWidget {
  final controller = Get.put(FavoriteListController());

  FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: CustomAppbarNoSearchBar(
            title: toLabelValue('favourite_label'), hideBackIcon: true),
        backgroundColor: Colors.white,
        body: Obx(() => SafeArea(
              child: (controller.userId == null || controller.userId == "")
                  ? Center(
                      child: Text(
                          toLabelValue(ConstantsLabelKeys.user_not_logged_in)))
                  : Stack(
                      children: [
                        IgnorePointer(
                          ignoring:
                              controller.myshowLoader.value ? true : false,
                          child: controller.resultFavList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 28, left: 8, right: 8),
                                  child: SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp:
                                        (controller.resultFavList.isNotEmpty)
                                            ? true
                                            : false,
                                    header: MaterialClassicHeader(
                                      backgroundColor:
                                          ColorConstant.appThemeColor,
                                      color: ColorConstant.whiteBackgroundColor,
                                    ),
                                    footer: customFooterSmartRefresh(),
                                    controller: controller.refreshController,
                                    onRefresh: () async {
                                      controller.myshowLoader(false);

                                      await Future.delayed(
                                          const Duration(milliseconds: 1000));
                                      controller.pageIndex(1);
                                      controller.getFavouriteList();
                                      controller.refreshController
                                          .refreshCompleted();
                                    },
                                    onLoading: () async {
                                      if (controller.resultFavList.length <
                                          controller.favoriteItems.value.result!
                                              .total!
                                              .toInt()) {
                                        await Future.delayed(
                                            const Duration(milliseconds: 1000));

                                        controller.pageIndex.value += 1;
                                        controller.myshowLoader(false);
                                        controller.getFavouriteList();
                                        controller.refreshController
                                            .loadComplete();
                                      } else {
                                        controller.refreshController
                                            .loadNoData();
                                      }
                                    },
                                    child: ListView.builder(
                                        itemCount:
                                            controller.resultFavList.length,
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          var favoriteListData =
                                              controller.resultFavList[index];

                                          return ActivityItemWidget(
                                            onBannerTap: () {
                                              providerID.value =
                                                  favoriteListData.providerId ??
                                                      "";
                                              itemID.value =
                                                  favoriteListData.itemId ?? "";

                                              ActivityDetailBinding()
                                                  .dependencies();
                                              Get.find<
                                                      ActivityDetailController>()
                                                  .categoryActivityDetail();
                                              Get.toNamed(AppRouteNameConstant
                                                  .activityDetailScreen);
                                            },
                                            isIconDisplay:
                                                (controller.token?.isNotEmpty ==
                                                        true &&
                                                    controller.token != null),
                                            favShowLoader:
                                                controller.favShowLoader,
                                            onFavIconTap: () {
                                              controller.selectedIndex.value =
                                                  index;

                                              controller.deleteFavouriteItem(
                                                  favoriteListData.itemId);
                                            },
                                            isNotFav: false,
                                            itemImageUrl:
                                                favoriteListData.itemImage ??
                                                    '',
                                            serviceProviderImageUrl:
                                                favoriteListData
                                                    .serviceProviderImage,
                                            serviceProviderName:
                                                favoriteListData.itemName,
                                            serviceProviderAddress:
                                                favoriteListData.providerName
                                                    .toString(),
                                            serviceProviderDistance:
                                                favoriteListData.distance,
                                            isCurrentIndex: index,
                                            isSelectedIndex:
                                                controller.selectedIndex,
                                          );
                                        }),
                                  ),
                                  // ),
                                )
                              : (controller.myshowLoader.value ||
                                      controller.favShowLoader.isTrue)
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                "assets/images/favorite_list_empty_icon.png",
                                                height: 120,
                                                width: 120),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                                toLabelValue(
                                                    "your_fav_list_empty"),
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                  toLabelValue(
                                                      "explore_more_fav"),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayBorderColor),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                        ),
                        if (controller.myshowLoader.value)
                          Center(
                            child: CircularProgressIndicator(
                              color: ColorConstant.appThemeColor,
                            ),
                          ),
                      ],
                    ),
            )),
      ),
    );
  }
}
