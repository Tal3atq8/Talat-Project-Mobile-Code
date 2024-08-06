import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_controller.dart';
import 'package:talat/src/screens/booking_calendar/booking_calendar_binding.dart';
import 'package:talat/src/screens/booking_calendar/booking_calendar_controller.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/my_booking/confirm_booking_screen.dart';
import 'package:talat/src/screens/service_provider/service_provider_binding.dart';
import 'package:talat/src/screens/service_provider/service_provider_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_button_widget.dart';
import 'package:talat/src/widgets/common_map_widget.dart';

import '../../../models/get_category_activity_detail_model.dart';
import '../../../utils/global_constants.dart';
import '../../../widgets/common_text_style.dart';

final ScrollController _scrollController = ScrollController();
const double descriptionSpacing = 8;

class ActivityDetailScreen extends StatelessWidget {
  ActivityDetailScreen({super.key});

  final controller = Get.find<ActivityDetailController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        color: ColorConstant.appThemeColor,
        child: Scaffold(
            bottomSheet: Obx(() {
              if (controller.categoryActivityDetailModel.value.result != null && controller.showLoader.value == false) {
                return Container(
                  height: Get.width * .18,
                  width: Get.width,
                  alignment: Alignment.centerLeft,
                  color: ColorConstant.appThemeColor,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            (controller.categoryActivityDetailModel.value.result?.activityDetailItem?.discountedPrice !=
                                        null &&
                                    controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                            ?.discountedPrice
                                            .toString() !=
                                        '0')
                                ? '${generalSetting?.result?[0].currency ?? ''} ${controller.categoryActivityDetailModel.value.result?.activityDetailItem?.discountedPrice?.toStringAsFixed(3)}'
                                : (controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                ?.initialPrice !=
                                            null &&
                                        controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                ?.initialPrice
                                                .toString() !=
                                            '0')
                                    ? '${generalSetting?.result?[0].currency ?? ''} ${controller.categoryActivityDetailModel.value.result?.activityDetailItem?.initialPrice?.toStringAsFixed(3)}'
                                    : toLabelValue(ConstantsLabelKeys.label_free),
                            style: txtStyleTitleBoldBlack16(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          if (controller
                                      .categoryActivityDetailModel.value.result?.activityDetailItem?.discountedPrice !=
                                  null &&
                              controller.categoryActivityDetailModel.value.result?.activityDetailItem?.discountedPrice
                                      .toString() !=
                                  '0')
                            Text(
                              '(${generalSetting?.result?[0].currency ?? ''} ${controller.categoryActivityDetailModel.value.result?.activityDetailItem?.initialPrice?.toStringAsFixed(3)})',
                              style: txtStyleTitleBoldBlack14(
                                  color: Colors.white, textDecoration: TextDecoration.lineThrough),
                            ),
                        ],
                      ),
                    ),
                    trailing: ButtonWidget(
                        title: toLabelValue(ConstantsLabelKeys.book_now_label),
                        onPressed: () {
                          BookingCalendarBinding().dependencies();
                          if (activityDetailItem.value.typeOfActivity == "Time") {
                            if (activityDetailItem.value.discountedPrice == 0) {
                              Get.find<BookingCalendarController>().totalAmount.value =
                                  activityDetailItem.value.initialPrice.toString();
                            } else {
                              Get.find<BookingCalendarController>().totalAmount.value =
                                  activityDetailItem.value.discountedPrice.toString();
                            }
                          }
                          if (controller.userId != null && controller.userId != "") {
                            isNotLoggedIn.value = "0";
                            serviceProviderName.value = controller.categoryActivityDetailModel.value.result
                                    ?.serviceProviderInfo?.serviceProviderName ??
                                "";
                            serviceProviderNumber.value = controller.categoryActivityDetailModel.value.result
                                    ?.serviceProviderInfo?.serviceProviderNumber
                                    .toString() ??
                                "";
                            BookingCalendarBinding().dependencies();
                            Get.find<BookingCalendarController>().showContainer.value = false;
                            Get.find<BookingCalendarController>().onInit();

                            Get.find<BookingCalendarController>().selectedname.value = controller.selectedname.value;
                            Get.find<BookingCalendarController>().timeType = activityDetailItem.value.typeOfActivity;
                            Get.find<BookingCalendarController>().startDateStr = "";
                            Get.find<BookingCalendarController>().endDateStr = "";
                            activityDetailItem.value =
                                controller.categoryActivityDetailModel.value.result?.activityDetailItem ??
                                    ActivityDetailItem();

                            if (controller.categoryActivityDetailModel.value.result?.categories != null &&
                                controller.categoryActivityDetailModel.value.result!.categories!.isNotEmpty) {
                              for (var element in controller.categoryActivityDetailModel.value.result!.categories!) {
                                if (categoryID.value.isNotEmpty && !categoryID.value.contains(element.id.toString())) {
                                  categoryID.value = '${categoryID.value},${element.id}';
                                } else {
                                  categoryID.value = '${element.id}';
                                }
                              }
                            }
                            debugPrint(categoryID.value);
                            providerID.value = controller
                                    .categoryActivityDetailModel.value.result?.serviceProviderInfo?.serviceProviderId
                                    .toString() ??
                                '';
                            specialInstruction.value = controller
                                    .categoryActivityDetailModel.value.result?.activityDetailItem?.specialInstruction ??
                                "";

                            providerName.value = controller.providerName.value;
                            Get.toNamed(
                              AppRouteNameConstant.bookingCalendarScreen,
                            )?.then((value) {});
                          } else {
                            isNotLoggedIn.value = "1";
                            Get.toNamed(AppRouteNameConstant.loginScreen);
                          }
                        },
                        btnColor: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        txtColor: ColorConstant.appThemeColor),
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
            backgroundColor: Colors.white,
            body: GetBuilder<ActivityDetailController>(
              builder: (controller) {
                return controller.showLoader.value
                    ? Center(
                        child: CircularProgressIndicator(
                        color: ColorConstant.appThemeColor,
                      ))
                    : Obx(() {
                        return (controller.categoryActivityDetailModel.value.result != null)
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        CarouselSlider(
                                          items: controller
                                              .categoryActivityDetailModel.value.result!.activityDetailItem!.images!
                                              .map((item) => ClipRRect(
                                                      child: CachedNetworkImage(
                                                    width: Get.width,
                                                    imageUrl: item.imageUrl ?? '',
                                                    height: Get.height * 0.4,
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) {
                                                      return const PlaceholderImage();
                                                    },
                                                    placeholder: (context, url) {
                                                      return const PlaceholderImage();
                                                    },
                                                  )))
                                              .toList(),
                                          carouselController: controller.slideControllers,
                                          options: CarouselOptions(
                                              scrollPhysics: controller.categoryActivityDetailModel.value.result!
                                                          .activityDetailItem!.images!.length >
                                                      1
                                                  ? const AlwaysScrollableScrollPhysics()
                                                  : const NeverScrollableScrollPhysics(),
                                              viewportFraction: 1.0,
                                              autoPlay: false,
                                              height: Get.height * 0.4,
                                              enlargeCenterPage: false,
                                              aspectRatio: 1.0,
                                              onPageChanged: (index, reason) {
                                                controller.current.value = index;
                                              }),
                                        ),
                                        Positioned(
                                          top: 50,
                                          child: Transform.scale(
                                            scaleX: language == '2' ? -1 : 1,
                                            child: Container(
                                              margin: EdgeInsets.only(
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
                                        if (controller.categoryActivityDetailModel.value.result!.activityDetailItem!
                                                .images!.length >
                                            1)
                                          Positioned(
                                            // top: 0.0,
                                            bottom: 40.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: controller
                                                  .categoryActivityDetailModel.value.result!.activityDetailItem!.images!
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                                return Obx(() {
                                                  return GestureDetector(
                                                    onTap: () => controller.slideControllers.animateToPage(entry.key),
                                                    child: Container(
                                                        width: 12,
                                                        height: 12,
                                                        margin:
                                                            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: controller.current == entry.key
                                                                ? ColorConstant.appThemeColor
                                                                : ColorConstant.lightGrayColor)),
                                                  );
                                                });
                                              }).toList(),
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 0.0,
                                          left: 0.0,
                                          right: 0.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.4),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
                                            child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                    imageUrl: controller.categoryActivityDetailModel.value.result
                                                            ?.serviceProviderInfo?.serviceProviderImage ??
                                                        '',
                                                    height: 38,
                                                    width: 38,
                                                    errorWidget: (context, url, error) {
                                                      return const PlaceholderImage();
                                                    },
                                                    placeholder: (context, url) {
                                                      return const PlaceholderImage();
                                                    },
                                                    fit: BoxFit.cover),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: Text(
                                                  controller.categoryActivityDetailModel.value.result
                                                          ?.serviceProviderInfo?.serviceProviderName ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: ColorConstant.whiteColor,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: GestureDetector(
                                                  behavior: HitTestBehavior.translucent,
                                                  onTap: () {
                                                    ServiceProviderBinding().dependencies();
                                                    Get.find<ServiceProviderController>().servicesProviderId.value =
                                                        controller.categoryActivityDetailModel.value.result!
                                                            .serviceProviderInfo!.serviceProviderId!;
                                                    Get.find<ServiceProviderController>().providerData();
                                                    Get.toNamed(AppRouteNameConstant.serviceProviderScreen);
                                                  },
                                                  child: Wrap(spacing: 10, children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 4.0),
                                                      child: Text(
                                                        toLabelValue("more_info"),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: ColorConstant.whiteColor,
                                                            fontWeight: FontWeight.normal),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_down_rounded,
                                                      color: ColorConstant.whiteColor,
                                                    ),
                                                  ]),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: SizedBox(
                                            width: Get.width * 0.46,
                                            child: Text(
                                              "${controller.categoryActivityDetailModel.value.result?.activityDetailItem?.itemName}",
                                              style: txtStyleTitleBoldBlack18(),
                                            ),
                                          ),
                                        ),
                                        if (controller.categoryActivityDetailModel.value.result?.categories?.length ==
                                            1)
                                          Flexible(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: descriptionSpacing),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: ColorConstant.appThemeColor,
                                              ),
                                              child: Text(
                                                controller.categoryActivityDetailModel.value.result?.categories?.first
                                                        .name ??
                                                    "",
                                                style: const TextStyle(color: Colors.white),
                                                textAlign: TextAlign.center,
                                                // overflow: TextOverflow.ellipsis,  // This handles the overflow
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (controller.categoryActivityDetailModel.value.result?.categories != null &&
                                        controller.categoryActivityDetailModel.value.result!.categories!.length > 1)
                                      const SizedBox(height: 16),
                                    if (controller.categoryActivityDetailModel.value.result?.categories != null &&
                                        controller.categoryActivityDetailModel.value.result!.categories!.length > 1)
                                      SizedBox(
                                        height: 53,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              controller.categoryActivityDetailModel.value.result!.categories!.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              // width: Get.width *0.2,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: descriptionSpacing),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: ColorConstant.appThemeColor),
                                              child: Text(
                                                  controller.categoryActivityDetailModel.value.result!
                                                          .categories![index].name ??
                                                      "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        toLabelValue("description"),
                                        style: txtStyleTitleBoldBlack18(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: descriptionSpacing,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                          controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                  ?.description ??
                                              "",
                                          style: txtStyleNormalGray14()),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child:
                                          Text(toLabelValue("special_instruction"), style: txtStyleTitleBoldBlack18()),
                                    ),
                                    const SizedBox(
                                      height: descriptionSpacing,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                          controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                  ?.specialInstruction ??
                                              "",
                                          style: txtStyleNormalGray14()),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        toLabelValue("address"),
                                        style: txtStyleTitleBoldBlack18(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: descriptionSpacing,
                                    ),
                                    controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                    ?.is_location ==
                                                0 ||
                                            controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                    ?.is_location ==
                                                ""
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: RichText(
                                                        maxLines: 50,
                                                        text: TextSpan(children: [
                                                          TextSpan(
                                                            text:
                                                                "${controller.categoryActivityDetailModel.value.result?.serviceProviderInfo?.serviceProviderName.toString().capitalizeFirst ?? ""} ",
                                                            style: txtStyleNormalGray14(color: Colors.red),
                                                          ),
                                                          TextSpan(
                                                            text: " ${toLabelValue('no_location')} ",
                                                            style: txtStyleNormalGray14(),
                                                          ),
                                                        ]))),
                                              ],
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: GestureDetector(
                                              onTap: () async {
                                                var lat = controller.categoryActivityDetailModel.value.result!
                                                    .activityDetailItem!.latitude
                                                    .toString();
                                                var lng = controller.categoryActivityDetailModel.value.result!
                                                    .activityDetailItem!.longitude
                                                    .toString();
                                                MapUtils.openMap(double.parse(lat), double.parse(lng));
                                              },
                                              child: Text(
                                                  controller.categoryActivityDetailModel.value.result
                                                          ?.activityDetailItem?.address ??
                                                      "",
                                                  style: txtStyleNormalGray14()),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: descriptionSpacing * 2,
                                    ),
                                    controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                    ?.is_location ==
                                                0 ||
                                            controller.categoryActivityDetailModel.value.result?.activityDetailItem
                                                    ?.is_location ==
                                                ""
                                        ? Container()
                                        : CommonMapWidget(
                                            latitude: double.parse(controller
                                                .categoryActivityDetailModel.value.result!.activityDetailItem!.latitude
                                                .toString()),
                                            longitude: double.parse(controller
                                                .categoryActivityDetailModel.value.result!.activityDetailItem!.longitude
                                                .toString()),
                                            markers: {
                                              Marker(
                                                markerId: MarkerId(
                                                    '${controller.categoryActivityDetailModel.value.result!.activityDetailItem!.itemName}'),
                                                position: LatLng(
                                                    double.parse(controller.categoryActivityDetailModel.value.result!
                                                        .activityDetailItem!.latitude
                                                        .toString()),
                                                    double.parse(controller.categoryActivityDetailModel.value.result!
                                                        .activityDetailItem!.longitude
                                                        .toString())),
                                                onTap: () async {
                                                  MapUtils.openMap(
                                                      double.parse(controller.categoryActivityDetailModel.value.result!
                                                          .activityDetailItem!.latitude
                                                          .toString()),
                                                      double.parse(controller.categoryActivityDetailModel.value.result!
                                                          .activityDetailItem!.longitude
                                                          .toString()));
                                                },
                                              )
                                            },
                                          ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              )
                            : const CommonNoDataFound();
                      });
              },
            )),
      ),
    );
  }
}
