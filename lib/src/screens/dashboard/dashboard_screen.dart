import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/utils/base_server.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/network/netwrok_manager_controller.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_controller.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';

import '../../models/get_category_activity_detail_model.dart';
import '../../utils/acivity_item_widget.dart';
import '../../utils/common_widgets.dart';
import '../../widgets/search_textform_filed.dart';
import '../activite/activity_detail/activity_detail_binding.dart';
import '../filter/filter_binding.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final networkController = Get.put(GetXNetworkManager());
  final controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: AppBar(
          leadingWidth: 16.0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.whiteColor,
          elevation: 0.0,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ImageConstant.dashboardTalatIcon,
                height: getVerticalSize(37.00),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 14,
                onPressed: () {
                  Get.toNamed(AppRouteNameConstant.mapScreen);
                },
                icon: Image.asset(
                  ImageConstant.talatLogo,
                  height: getVerticalSize(27.00),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 0.0),
            //   child: IconButton(
            //     padding: EdgeInsets.zero,
            //     iconSize: 14,
            //     onPressed: () {
            //       showBaseUrlDialog(context);
            //     },
            //     icon: Image.asset(
            //       ImageConstant.aboutUsIcon,
            //       height: getVerticalSize(27.00),
            //     ),
            //   ),
            // ),
          ],
        ),
        body: Obx(() => (controller.showLoader.value ||
                controller.showPopularItemsLoader.value ||
                controller.showBrowseLoader.value)
            ? Center(
                child: CircularProgressIndicator(
                color: ColorConstant.appThemeColor,
              ))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SmartRefresher(
                  header: MaterialClassicHeader(
                    backgroundColor: ColorConstant.appThemeColor,
                    color: ColorConstant.whiteBackgroundColor,
                  ),
                  controller: controller.refreshController,
                  onRefresh: () {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () {
                        controller.page.value = 1;
                        controller.popularPage.value = 1;
                        controller.initLimit.value = 5;
                        controller.popularLimit.value = 5;

                        controller.getBannerList();
                        controller.getBrowseActivityList();
                        controller.getPopularActivityList();
                      },
                    );
                  },
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SearchTextFormField(
                        width: double.infinity,
                        onTap: () {
                          Get.toNamed(AppRouteNameConstant.searchScreen);
                        },
                        readOnly: true,
                        hintText: toLabelValue(ConstantStrings.searchHintText),
                        onChanged: (value) {},
                        textInputType: TextInputType.text,
                        margin: getMargin(
                          top: 4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      controller.showLoader.value
                          ? const CommonProgressIndicator()
                          : (controller.bannerItems.value.result?.bannerData == null ||
                                  controller.bannerItems.value.result!.bannerData!.isEmpty)
                              ? const SizedBox()
                              : bannerCarouselSlider(),

                      /// check if categories is empty then only display banners
                      if (controller.dashBoardBrowseListData.value.isNotEmpty)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    toLabelValue(ConstantsLabelKeys.browseCategoryText).toString() ?? '',
                                    style: txtStyleTitleNormalBlack16(),
                                  ),
                                  if (controller.dashBoardBrowseListData.value.length > 3)
                                    TextButton(
                                        onPressed: () {
                                          controller.initLimit.value = 20;
                                          controller.getBrowseActivityList();
                                          Get.toNamed(AppRouteNameConstant.seeAllBrowseActivitiesScreen);
                                        },
                                        child: Text(
                                          toLabelValue((ConstantsLabelKeys.seeAllText)),
                                          style: txtStyleNormalBlack10(),
                                        ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SizedBox(
                                height: 150,
                                child: Obx(
                                  () => browseCategoryListView(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (controller.popularActivityItems.value.result != null &&
                          controller.popularActivityItems.value.result!.popularList!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                toLabelValue(ConstantsLabelKeys.popularActivitiesText).toString() ?? '',
                                style: txtStyleTitleNormalBlack16(),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.getPopularActivityList();
                                  Get.toNamed(AppRouteNameConstant.seeAllPopularActivitiesScreen);
                                },
                                child: Text(
                                  toLabelValue((ConstantsLabelKeys.seeAllText)),
                                  style: txtStyleNormalBlack10(),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (controller.popularActivityItems.value.result != null &&
                          controller.popularActivityItems.value.result!.popularList!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            // width: 420.w,
                            child: popularItemsListView(),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              )),
      ),
    );
  }

  Widget popularItemsListView() {
    return Obx(() {
      print(controller.favShowLoader.value);
      return ListView.builder(
          itemCount: controller.popularActivityItemList.length >= 5 ? 5 : controller.popularActivityItemList.length,
          scrollDirection: Axis.horizontal,
          physics: (controller.popularActivityItemList.length > 1)
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var popularListData = controller.popularActivityItemList[index];
            return ActivityItemWidget(
              fullWidth: (controller.popularActivityItems.value.result!.popularList!.length == 1),
              onBannerTap: () {
                providerID.value = popularListData.providerId ?? "".toString();
                itemID.value = popularListData.id.toString() ?? "";
                activityDetailItem.value = ActivityDetailItem();
                ActivityDetailBinding().dependencies();
                Get.find<ActivityDetailController>().selectItemIndexId.value = "";
                Get.find<ActivityDetailController>().isOpenBottomSheet.value = false;

                Get.find<ActivityDetailController>().categoryActivityDetail();
                Get.toNamed(AppRouteNameConstant.activityDetailScreen);
              },
              isIconDisplay: ((controller.name?.isNotEmpty == true && controller.name != null)),
              favShowLoader: controller.favShowLoader,
              onFavIconTap: () {
                controller.selectedIndex.value = index;

                (!controller.popularActivityItemListFav.contains(popularListData.id))
                    ? controller.addFavouriteItem(popularListData.id)
                    : controller.deleteFavouriteItem(popularListData.id);
              },
              isNotFav: !controller.popularActivityItemListFav.contains(popularListData.id),
              itemImageUrl: popularListData.itemImage ?? '',
              serviceProviderImageUrl: popularListData.serviceProviderImage ?? "",
              serviceProviderName: popularListData.activityName ?? "",
              serviceProviderAddress: popularListData.providerName ?? "",
              serviceProviderDistance:
                  (userLat.value == "" && userLong.value == "") ? "" : popularListData.distance.toString() ?? "",
              isCurrentIndex: index,
              isSelectedIndex: controller.selectedIndex,
            );
          });
    });
  }

  ListView browseCategoryListView() {
    return ListView.builder(
        itemCount: controller.dashBoardBrowseListData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var browseItems = controller.dashBoardBrowseListData.value[index];
          return SizedBox(
            width: Get.width * .3,
            child: GestureDetector(
              onTap: () {
                activityID.value = browseItems.id ?? '';
                activityName.value = browseItems.activityName ?? '';
                FilterBinding().dependencies();
                Get.toNamed(AppRouteNameConstant.activityListScreen);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstant.appThemeColor, width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: browseItems.activityImage ?? '',
                          errorWidget: (context, url, error) {
                            return const PlaceholderImage();
                          },
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                          placeholder: (context, url) {
                            return const PlaceholderImage();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        browseItems.activityName ?? "",
                        style: txtStyleNormalBlack14(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  SizedBox bannerCarouselSlider() {
    double bannerHeight = 260;
    return SizedBox(
      height: bannerHeight,
      child: Column(
        children: [
          Expanded(
            child: CarouselSlider(
              items: controller.bannerItems.value.result?.bannerData!
                  .map((imageUrl) => Center(
                        child: SizedBox(
                          height: bannerHeight,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              child: GestureDetector(
                                onTap: () {
                                  if (imageUrl.advertisementType == "Extra advertisement") {
                                    // ExtraActivityDetailBinding()
                                    //     .dependencies();
                                    print(imageUrl.extraAdvertisementData);
                                    extraAdvertisementData.value = imageUrl.extraAdvertisementData!;

                                    Get.toNamed(AppRouteNameConstant.extraActivityScreen);
                                  } else {
                                    providerID.value = imageUrl.partner_id.toString();
                                    itemID.value = imageUrl.itemId.toString() ?? "";
                                    activityDetailItem.value = ActivityDetailItem();
                                    ActivityDetailBinding().dependencies();

                                    Get.find<ActivityDetailController>().categoryActivityDetail();
                                    Get.toNamed(AppRouteNameConstant.activityDetailScreen);
                                  }
                                },
                                child: (imageUrl.bannerImage != null && imageUrl.bannerImage!.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          width: Get.width * .9,
                                          imageUrl: imageUrl.bannerImage ?? '',
                                          errorWidget: (context, url, error) {
                                            return const PlaceholderImage();
                                          },
                                          placeholder: (context, url) {
                                            return const PlaceholderImage();
                                          },
                                        ),
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                      ))
                  .toList(),
              carouselController: controller.slideControllers,
              options: CarouselOptions(
                  viewportFraction: 1.0,
                  autoPlay: controller.bannerItems.value.result?.bannerData?.length == 1 ? false : true,
                  enlargeCenterPage: false,
                  aspectRatio: 2.0,
                  scrollPhysics: controller.bannerItems.value.result?.bannerData?.length == 1
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  onPageChanged: (index, reason) {
                    controller.current.value = index;
                  }),
            ),
          ),
          Obx(() => (controller.bannerItems.value.result?.bannerData != null &&
                  controller.bannerItems.value.result!.bannerData!.isNotEmpty)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.bannerItems.value.result!.bannerData!.asMap().entries.map((entry) {
                    // children: controller.imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () {
                        controller.slideControllers.animateToPage(entry.key);
                      },
                      child: Container(
                          width: 17.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              color: controller.current.value == entry.key
                                  ? ColorConstant.appThemeColor
                                  : ColorConstant.lightGrayColor)),
                    );
                  }).toList(),
                )
              : const SizedBox()),
        ],
      ),
    );
  }
}
