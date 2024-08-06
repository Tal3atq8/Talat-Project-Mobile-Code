import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/screens/service_provider/service_provider_controller.dart';
import 'package:talat/src/utils/common_widgets.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';
import '../activite/activity_detail/activity_detail_binding.dart';
import '../activite/activity_detail/activity_detail_controller.dart';

class ServiceProviderList extends StatelessWidget {
  ServiceProviderList({super.key});

  final serviceProviderController = Get.find<ServiceProviderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Obx(() {
          return CustomAppbarNoSearchBar(
              title: serviceProviderController.serviceProviderListResult.value.result?.category?.categoryName ?? "");
        }),
      ),
      body: Obx(() => serviceProviderController.showLoader.value
          ? const Center(child: CommonLoading())
          : (serviceProviderController.serviceProviderListResult.value.result?.provider?.data != null &&
                  serviceProviderController.serviceProviderListResult.value.result!.provider!.data!.isNotEmpty)
              ? ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      serviceProviderController.serviceProviderListResult.value.result?.provider?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    var providerList =
                        serviceProviderController.serviceProviderListResult.value.result?.provider?.data?[index];
                    return GestureDetector(
                      onTap: () {
                        providerID.value = providerList?.serviceProviderId.toString() ?? '';

                        // providerID.value =
                        //     popularListData?.providerId ?? '';
                        ActivityDetailBinding().dependencies();
                        Get.find<ActivityDetailController>().selectCategoryIndex = 0.obs;
                        Get.find<ActivityDetailController>().myTabs = [];

                        // Get.find<ActivityDetailController>()
                        //     .activityDetailData();

                        // dashboardController.update();
                        Get.toNamed(
                          AppRouteNameConstant.activityDetailScreen,
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                              child: CachedNetworkImage(
                                height: Get.height * 0.19,
                                width: Get.width,
                                fit: BoxFit.cover,
                                imageUrl: serviceProviderController
                                        .serviceProviderListResult.value.result?.category?.categoryImage ??
                                    "",
                                errorWidget: (context, url, error) {
                                  return const PlaceholderImage();
                                },
                                // errorWidget: (context, url, error) {
                                //   return Image.asset(ImageConstant.nightCampingImage);
                                // },
                                placeholder: (context, url) {
                                  return const PlaceholderImage();
                                },
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.only(top: 10, left: 16, bottom: 18),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: CachedNetworkImage(
                                  imageUrl: providerList?.serviceProviderImage ?? "",
                                  height: 46,
                                  width: 46,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return const PlaceholderImage();
                                  },
                                  // errorWidget: (context, url, error) {
                                  //   return Image.asset(ImageConstant.nightCampingImage);
                                  // },
                                  placeholder: (context, url) {
                                    return const PlaceholderImage();
                                  },
                                ),
                              ),
                              title: Text(providerList?.serviceProviderName ?? ""),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: Get.width * 0.6,
                                      child: Text(
                                        providerList?.serviceProviderAddress ?? "",
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Text("${providerList?.serviceProviderDistance} away" ?? ""),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: CommonNoDataFound())),
    );
  }
}
