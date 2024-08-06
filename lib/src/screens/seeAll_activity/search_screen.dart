import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/search_model.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_binding.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_controller.dart';
import 'package:talat/src/screens/activite/activity_list_binding.dart';
import 'package:talat/src/screens/activite/activity_list_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_all_activity_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/screens/service_provider/service_provider_binding.dart';
import 'package:talat/src/screens/service_provider/service_provider_controller.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';
import 'package:talat/src/widgets/search_textform_filed.dart';

import '../../theme/color_constants.dart';
import '../../theme/constant_strings.dart';
import '../../utils/acivity_item_widget.dart';
import '../../utils/common_widgets.dart';
import '../filter/filter_binding.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final controller = Get.find<SeeALLActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: Padding(
        padding: EdgeInsets.only(right: language == '2' ? 16.0 : 0),
        child: Scaffold(
          backgroundColor: ColorConstant.whiteColor,
          appBar: AppBar(
            toolbarHeight: 60,
            elevation: 0,
            titleSpacing: 0,
            // leadingWidth: 42,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstant.appThemeColor,
                )),
            title: Padding(
              padding: EdgeInsets.only(right: language == "2" ? 0 : 16.0, left: language == "1" ? 0 : 16.0),
              child: SearchTextFormField(
                width: double.infinity,
                focusNode: controller.searchFocusNode,
                controller: controller.searchController,
                hintText: toLabelValue(ConstantStrings.searchHintText),
                onChanged: (value) {
                  controller.searchData(value);
                  controller.textValue.value = value;
                },
                textInputType: TextInputType.text,
                margin: getMargin(
                  top: 4,
                ),
                suffix: Obx(
                  () {
                    if (controller.textValue.value.isEmpty) {
                      return const SizedBox.shrink(); // Hide suffix icon when text is empty
                    } else {
                      return IconButton(
                        icon: Icon(Icons.clear, color: ColorConstant.grayTextFormFieldTextColor),
                        onPressed: () {
                          controller.searchData("");
                          controller.clearText(); // Clear the text field
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          body: GetBuilder<SeeALLActivityController>(builder: (controller) {
            var providerList =
                controller.searchListModel.value.result?.where((item) => item.type!.contains("provider")).toList();
            var itemList =
                controller.searchListModel.value.result?.where((item) => item.type!.contains("activity")).toList();
            var myItemList =
                controller.searchListModel.value.result?.where((item) => item.type!.contains("item")).toList();

            return Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  controller.showLoader.value
                      ? Expanded(
                          child: Center(
                              child: SizedBox(
                            height: Get.height * 0.5,
                            child: const CommonLoading(),
                          )),
                        )
                      : Expanded(
                          child: (controller.searchListModel.value.result?.isNotEmpty == true &&
                                  controller.searchController.text.isNotEmpty)
                              ? SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (providerList?.isNotEmpty == true)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 18.0, top: 20, right: 16),
                                          child: Text(
                                            toLabelValue(ConstantStrings.activityProviderText),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                        ),
                                      if (providerList?.isNotEmpty == true)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            top: 10,
                                          ),
                                          child: SizedBox(
                                            height: 90,
                                            child: providerListView(providerList),
                                          ),
                                        ),
                                      if (itemList?.isNotEmpty == true)
                                        Divider(
                                          thickness: 8,
                                          color: ColorConstant.grayTextFormFieldColor,
                                        ),
                                      if (itemList?.isNotEmpty == true)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 20, right: 16, bottom: 8),
                                          child: Text(
                                            toLabelValue(ConstantStrings.allPopularText),
                                            style: txtStyleTitleBoldBlack12(),
                                          ),
                                        ),
                                      if (itemList?.isNotEmpty == true) popularActivitiesGridView(itemList),
                                      if (myItemList?.isNotEmpty == true)
                                        Divider(
                                          thickness: 8,
                                          color: ColorConstant.grayTextFormFieldColor,
                                        ),
                                      if (myItemList?.isNotEmpty == true)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 16, right: 16, bottom: 8),
                                          child: Text(
                                            toLabelValue("all_popular_activities"),
                                            style: txtStyleTitleBoldBlack12(),
                                          ),
                                        ),
                                      if (myItemList?.isNotEmpty == true)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 14.0, top: 8, right: 12),
                                          child: SizedBox(
                                            height: Get.height * 0.3,
                                            // width: 420.w,
                                            child: categoryItemListView(myItemList),
                                          ),
                                        ),
                                      // const SizedBox(height: 20),
                                    ],
                                  ),
                                )
                              : searchHistory.isNotEmpty == true || providerSearchHistory.isNotEmpty == true
                                  ? SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            if (providerSearchHistory.value.isNotEmpty == true)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 18.0, top: 20),
                                                child: Text(
                                                  toLabelValue("activities_providers"),
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                ),
                                              ),
                                            if (providerSearchHistory.value.isNotEmpty == true)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  top: 10,
                                                ),
                                                child: SizedBox(
                                                  height: 90,
                                                  child: ListView.builder(
                                                      itemCount: providerSearchHistory.value == null
                                                          ? 5
                                                          : (providerSearchHistory.value.length),
                                                      //  itemCount: controller.seeAllActivityDetailModel.value.result?.providerData?.links?.length,
                                                      scrollDirection: Axis.horizontal,
                                                      shrinkWrap: true,
                                                      itemBuilder: (context, index) {
                                                        var browseItems = providerSearchHistory[index];
                                                        return GestureDetector(
                                                          onTap: () {
                                                            ActivityListBinding().dependencies();
                                                            Get.find<ActivityListController>().id.value =
                                                                browseItems.id.toString();
                                                            Get.find<ActivityListController>().fetchActivityItemList();
                                                            Get.find<ActivityListController>().activityName.value =
                                                                browseItems.name ?? '';
                                                            Get.toNamed(AppRouteNameConstant.activityDetailScreen);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(left: 10.0, right: 10.0, top: 4),
                                                            child: Column(
                                                              children: [
                                                                // browseItems?.url==null||browseItems?.url=="https://talat.dev.vrinsoft.in/api/v1/seeAllActivities?page=1" ?
                                                                Container(
                                                                  height: 56,
                                                                  width: 56,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    image: DecorationImage(
                                                                        image: AssetImage(
                                                                          ImageConstant.imagePlaceholder,
                                                                        ),
                                                                        fit: BoxFit.cover),
                                                                  ),
                                                                ),

                                                                const SizedBox(height: 8),
                                                                Text(
                                                                  browseItems.name ?? "",
                                                                  style: const TextStyle(
                                                                      fontSize: 12, fontWeight: FontWeight.normal),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                            if (providerSearchHistory.value.isNotEmpty == true)
                                              Divider(
                                                thickness: 8,
                                                color: ColorConstant.grayTextFormFieldColor,
                                              ),
                                            if (searchHistory.value.isNotEmpty == true)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 18.0, top: 20),
                                                child: Text(
                                                  ConstantStrings.allPopularText,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                ),
                                              ),
                                          ]),
                                    )
                                  : controller.searchController.text.isEmpty
                                      ? const SizedBox()
                                      : Center(
                                          child: SizedBox(
                                          height: Get.height * 0.2,
                                          child: Column(
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 0.0, left: 10, right: 10),
                                                child: Text(
                                                  toLabelValue("no_data_available"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: ColorConstant.blackColor,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                        ),
                ],
              );
            });
          }),
        ),
      ),
    );
  }

  ListView categoryItemListView(List<SearchModelResult>? myItemList) {
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: myItemList?.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var popularListData = myItemList?[index];

          return ActivityItemWidget(
            fullWidth: myItemList?.length == 1,
            onBannerTap: () {
              providerID.value = popularListData?.userId.toString() ?? "";

              itemID.value = popularListData?.id.toString() ?? '';
              ActivityDetailBinding().dependencies();
              Get.find<ActivityDetailController>().selectCategoryIndex = 0.obs;
              Get.find<ActivityDetailController>().myTabs = [];

              Get.find<ActivityDetailController>().categoryActivityDetail();

              // dashboardController.update();
              Get.toNamed(
                AppRouteNameConstant.activityDetailScreen,
              );
            },
            isIconDisplay: false,
            onFavIconTap: null,
            isNotFav: false,
            itemImageUrl: popularListData?.itemImage,
            serviceProviderImageUrl: popularListData?.providerPhoto,
            serviceProviderName: popularListData?.name ?? '',
            serviceProviderAddress: popularListData?.userName,
            serviceProviderDistance: '',
            isCurrentIndex: index,
          );
        });
  }

  ListView providerListView(List<SearchModelResult>? providerList) {
    return ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemCount: providerList?.length ?? 0,
        //  itemCount: controller.seeAllActivityDetailModel.value.result?.providerData?.links?.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var browseItems = providerList?[index];
          return GestureDetector(
            onTap: () {
              providerID.value = browseItems!.id.toString();
              providerName.value = browseItems.name ?? "";
              ServiceProviderBinding().dependencies();
              Get.find<ServiceProviderController>().serviceProviderActivityList();
              Get.toNamed(AppRouteNameConstant.serviceProviderActivityListScreen);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 4),
              child: Column(
                children: [
                  // browseItems?.url==null||browseItems?.url=="https://talat.dev.vrinsoft.in/api/v1/seeAllActivities?page=1" ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: CachedNetworkImage(
                      imageUrl: browseItems?.profilePhoto ?? '',
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return const PlaceholderImage();
                      },
                      placeholder: (context, url) {
                        return const PlaceholderImage();
                      },
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    browseItems?.name.toString() ?? "",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          );
        });
  }

  GridView popularActivitiesGridView(List<SearchModelResult>? itemList) {
    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: Get.width * .34,
        mainAxisExtent: Get.width * .32,
        childAspectRatio: 3,
      ),
      itemCount: itemList?.length ?? 0,
      itemBuilder: (BuildContext ctx, index) {
        var activityList = itemList?[index];
        return GestureDetector(
          onTap: () {
            activityID.value = activityList!.id.toString();

            // activityID.value = browseItems.id ?? '';
            activityName.value = activityList.name ?? '';
            FilterBinding().dependencies();
            Get.toNamed(AppRouteNameConstant.activityListScreen);
            // Get.toNamed(AppRouteNameConstant.serviceProviderListScreen);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0, top: 12),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: activityList?.profilePhoto ?? '',
                    height: 80,
                    width: 90,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const PlaceholderImage();
                    },
                    placeholder: (context, url) {
                      return const PlaceholderImage();
                    },
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Flexible(
                  child: Text(
                    activityList?.name ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
