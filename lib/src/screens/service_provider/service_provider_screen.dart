import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/providerDeatail_model.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';

import '../../utils/common_widgets.dart';
import '../../utils/global_constants.dart';
import 'service_provider_controller.dart';

class ServiceProvider extends StatelessWidget {
  ServiceProvider({Key? key}) : super(key: key);
  @override
  final serviceProviderController = Get.find<ServiceProviderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        body: Obx(
          () => serviceProviderController.showLoader.value
              ? const CommonProgressIndicator()
              : serviceProviderController.providerDetailModel.value.result != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              // controller.providerDetailModel.value.result.
                              CachedNetworkImage(
                                imageUrl:
                                    serviceProviderController.providerDetailModel.value.result?.activityImage ?? '',
                                height: Get.height * 0.45,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return const PlaceholderImage();
                                },
                                placeholder: (context, url) {
                                  return Container(
                                    color: Colors.red,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Image.asset(
                                      ImageConstant.appLogo,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 50,
                                child: Transform.scale(
                                  scaleX: language == '2' ? -1 : 1,
                                  // transform: language == '1'
                                  //     ? Matrix4.rotationY(0)
                                  //     : Matrix4.rotationY(pi),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: ColorConstant.appThemeColor),
                                      color: Colors.white, // border color

                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      // or ClipRRect if you need to clip the content
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,

                                        /// inner circle color
                                      ),
                                      child: Center(
                                        child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: ImageIcon(
                                              AssetImage(
                                                ImageConstant.backArrowIcon,
                                              ),
                                              size: 28,
                                              color: ColorConstant.appThemeColor,
                                            )),
                                      ), // inner content
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(
                              serviceProviderController.providerDetailModel.value.result?.serviceProviderName ?? "",
                              style: txtStyleTitleBoldBlack20(),
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 12, right: 16),
                            child: Text(
                              toLabelValue("contact_information_label"),
                              style: txtStyleTitleBoldBlack20(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  serviceProviderController.providerDetailModel.value.result?.serviceProviderEmail ??
                                      "",
                                  style: txtStyleNormalGray14(),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/icons8-whatsapp.svg",
                                      height: 24,
                                      width: 24,
                                    ),
                                    Text(
                                        "${ConstantStrings.countryCodeKuwait} ${serviceProviderController.providerDetailModel.value.result!.serviceProviderPhone.toString()}"),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 12, right: 16),
                            child: Text(
                              toLabelValue(ConstantsLabelKeys.business_info),
                              style: txtStyleTitleBoldBlack20(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              serviceProviderController.providerDetailModel.value.result?.aboutBusiness ?? "",
                              style: txtStyleNormalGray14(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 12, right: 16),
                            child: Text(
                              toLabelValue(ConstantsLabelKeys.rating_review),
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (serviceProviderController.providerDetailModel.value.result?.review == null ||
                              serviceProviderController.providerDetailModel.value.result!.review!.isNotEmpty)
                            SizedBox(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListView.separated(
                                itemCount:
                                    serviceProviderController.providerDetailModel.value.result!.review!.length > 1
                                        ? 2
                                        : 1,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                itemBuilder: (context, index) {
                                  var reviewItems =
                                      serviceProviderController.providerDetailModel.value.result?.review?[index];

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ratingWidget(reviewItems),
                                    ],
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 2),
                              ),
                            )),
                          const SizedBox(height: 40),
                          ((serviceProviderController.providerDetailModel.value.result?.review?.length ?? 0) > 2)
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 78.0, right: 78),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorConstant.appThemeColor,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        textStyle: txtStyleTitleBoldBlack18()),
                                    onPressed: () {
                                      Get.toNamed(AppRouteNameConstant.reviewListScreen);
                                    },
                                    child: Center(
                                      child: Text(
                                        ConstantStrings.viewMoreText,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                              : ((serviceProviderController.providerDetailModel.value.result?.review?.length ?? 0) == 0)
                                  ? SizedBox(
                                      height: Get.height * .25,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ClipOval(
                                            child: Material(
                                              color: ColorConstant.appThemeColor.withOpacity(.1),
                                              child: SizedBox(
                                                  width: 80,
                                                  height: 80,
                                                  child: Icon(
                                                    Icons.star_rate_outlined,
                                                    color: ColorConstant.appThemeColor,
                                                    size: 38,
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Text(toLabelValue("no_reviews_added"),
                                                style: txtStyleTitleBoldBlack18()),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                  : const CommonNoDataFound(),
        ));
  }

  ListTile ratingWidget(Review? reviewItems) {
    return ListTile(
      title: Text(
        reviewItems?.customerName.toString() ?? "",
        style: txtStyleTitleBoldBlack16(),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 4),
          //
          const SizedBox(
            height: 6,
          ),
          // const SizedBox(height: 2),
          Text(
            DateTime.parse(reviewItems?.createdAt ?? "").timeAgo(numericDates: false),
            style: txtStyleNormalBlack14(),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            reviewItems?.review ?? "",
            style: txtStyleNormalBlack14(),
          ),
        ],
      ),
      trailing: SizedBox(
        width: Get.width * 0.3,
        child: Row(
          children: [
            Text(
              " ${reviewItems?.ratings!.toStringAsFixed(1)}",
              style: txtStyleNormalBlack10(),
            ),
            const SizedBox(width: 2),
            RatingBar.builder(
              initialRating: reviewItems?.ratings?.toDouble() ?? 0.0,
              ignoreGestures: true,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 18,
              itemPadding: EdgeInsets.zero,
              // itemCount: 2.,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                size: 1,
                color: ColorConstant.appThemeColor,
              ),
              onRatingUpdate: (rating) {
                debugPrint('$rating');
              },
            ),
          ],
        ),
      ),
    );
  }
}
