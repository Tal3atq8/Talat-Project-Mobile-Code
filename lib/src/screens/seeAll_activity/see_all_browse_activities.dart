import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';

import '../../app_routes/app_routes.dart';
import '../../theme/color_constants.dart';
import '../../theme/constant_strings.dart';
import '../../utils/common_widgets.dart';
import '../../utils/global_constants.dart';
import '../../utils/size_utils.dart';
import '../../widgets/search_textform_filed.dart';
import '../dashboard/dashboard_screen_controller.dart';
import '../filter/filter_binding.dart';

class SeeAllBrowseActivities extends StatelessWidget {
  SeeAllBrowseActivities({super.key});

  final dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.find<DashboardController>().initLimit.value = 5;
        Get.find<DashboardController>().page.value = 1;
        Get.find<DashboardController>().getBrowseActivityList();
        Get.back();
        return Future.delayed(const Duration(milliseconds: 100));
      },
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: AppBar(
          toolbarHeight: 60,
          elevation: 0,
          leadingWidth: 34,
          leading: InkWell(
              onTap: () {
                Get.find<DashboardController>().initLimit.value = 5;
                Get.find<DashboardController>().page.value = 1;
                Get.find<DashboardController>().getBrowseActivityList();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstant.appThemeColor,
                  size: 20,
                  weight: 50,
                ),
              )),
          title: SearchTextFormField(
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
        ),
        body: Obx(() => (dashboardController.showBrowseLoader.value)
            ? Center(
                child: CircularProgressIndicator(
                color: ColorConstant.appThemeColor,
              ))
            : (dashboardController.browseListData.value.isNotEmpty)
                ? SmartRefresher(
                    enablePullUp: true,
                    enablePullDown: true,
                    controller:
                        dashboardController.seeAllBrowseRefreshController,
                    header: MaterialClassicHeader(
                      backgroundColor: ColorConstant.appThemeColor,
                      color: ColorConstant.whiteBackgroundColor,
                    ),
                    onLoading: () {
                      dashboardController.page.value =
                          dashboardController.page.value + 1;
                      dashboardController.initLimit.value = 20;
                      dashboardController.getBrowseActivityList(
                          isRefresh: true);
                    },
                    onRefresh: () {
                      dashboardController.page.value = 1;
                      dashboardController.initLimit.value = 20;
                      dashboardController.getBrowseActivityList(
                          isRefresh: true);
                    },
                    footer: customFooterSmartRefresh(),
                    child: GridView.builder(
                      padding:
                          const EdgeInsets.only(top: 16, right: 8, left: 8),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: Get.width * .33,
                        mainAxisExtent: 150,
                        childAspectRatio: 3,
                      ),
                      itemCount: dashboardController.browseListData.length,
                      itemBuilder: (context, index) {
                        var browseActivities =
                            dashboardController.browseListData[index];
                        return GestureDetector(
                          onTap: () {
                            activityID.value = browseActivities.id ?? '';
                            activityName.value =
                                browseActivities.activityName ?? '';
                            FilterBinding().dependencies();
                            Get.toNamed(
                                AppRouteNameConstant.activityListScreen);

                            print(browseActivities.id);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      browseActivities.activityImage ?? '',
                                  placeholder: (context, url) {
                                    return const PlaceholderImage();
                                  },
                                  errorWidget: (context, url, error) {
                                    return const PlaceholderImage();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Center(
                                  child: Text(
                                "${browseActivities.activityName}",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: txtStyleNormalGray12(),
                              )),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const CommonNoDataFound()),
      ),
    );
  }
}
