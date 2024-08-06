import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:talat/main.dart';
import 'package:talat/src/screens/activite/activity_detail/activity_detail_screen.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/my_booking/my_booking_detail/my_booking_detail_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';
import 'package:talat/src/widgets/custom_textform_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_routes/app_routes.dart';
import '../../widgets/common_map_widget.dart';
import '../dashboard/dashboard_screen_binding.dart';
import '../dashboard/tabBar/tabbar_binding.dart';
import 'my_booking_screen_binding.dart';
import 'my_booking_screen_controller.dart';

class BookingConfirmDetail extends StatelessWidget {
  BuildContext? screencontext;

  BookingConfirmDetail({Key? key}) : super(key: key);
  final Set<Marker> markers = {};
  final controller = Get.find<BookingDetailController>();
  var dateInputFormat = DateFormat('d MMM yyyy hh:mm a');

  //location to show in map
  @override
  Widget build(BuildContext context) {
    screencontext = context;

    if (controller.bookingDetailModel.value.result?.bookingDetail?.bookingToDate != null &&
        controller.bookingDetailModel.value.result?.bookingDetail?.bookingToDate != "") {}

    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: Obx(() {
          return CustomAppbarNoSearchBar(
            title: controller.bookingDetailModel.value.result?.bookingDetail?.bookingId != null
                ? '#${controller.bookingDetailModel.value.result?.bookingDetail?.bookingId ?? ""}'
                : '',
            disableAutoBack: backgroundMessage != null,
            onBackPressed: () {
              if (backgroundMessage != null) {
                TabbarBinding().dependencies();
                DashboardBinding().dependencies();
                Get.offAllNamed(AppRouteNameConstant.tabScreen);
              } else {
                MyBookingBinding().dependencies();
                Get.find<MyBookingScreenController>().getBookingList();
              }
              // Get.back();
            },
          );
        }),
      ),
      body: Obx(
        () => controller.showLoader.value
            ? const Center(child: CommonLoading())
            : (controller.bookingDetailModel.value.result != null)
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0, left: 18, right: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.bookingDetailModel.value.result?.providerDetail?.serviceProviderName ?? "",
                                style: txtStyleTitleBoldBlack18(),
                              ),
                              // Text(
                              //   controller.bookingDetailModel.value.result?.itemDetail?.itemAmount == 0
                              //       ? toLabelValue(ConstantsLabelKeys.label_free)
                              //       : '${generalSetting?.result?.first.currency ?? ''} ${controller.bookingDetailModel.value.result?.itemDetail?.itemAmount.toStringAsFixed(3)}',
                              //   style: txtStyleTitleBoldBlack18(),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              Text(
                                '${toLabelValue("contact_label")} :',
                                style: txtStyleTitleBoldBlack14(),
                              ),
                              Text(
                                ' ${controller.bookingDetailModel.value.result?.providerDetail?.serviceProviderCountryCode ?? "${ConstantStrings.countryCodeKuwait}"} ${controller.bookingDetailModel.value.result?.providerDetail?.serviceProviderMobile} ',
                                style: TextStyle(
                                    color: ColorConstant.appThemeColor, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => controller.bookingDetailModel.value.result?.bookingDetail?.bookingType ==
                                  "active booking"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    color: const Color(0x00f21f0c).withOpacity(0.06),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageConstant.bookingCalendarIcon,
                                          height: 44,
                                          width: 44,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            toLabelValue(ConstantsLabelKeys.your_booking_on),
                                            style: TextStyle(
                                                color: ColorConstant.blackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        if (controller.bookingDetailModel.value.result?.bookingDetail?.timeSlot != "")
                                          Obx(() {
                                            debugPrint('${controller.showLoader.value}');
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    ' From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate ?? "2023-06-23"))}',
                                                    style: TextStyle(
                                                        color: ColorConstant.blackColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    '${controller.bookingDetailModel.value.result?.bookingDetail?.timeSlot}',
                                                    style: TextStyle(
                                                        color: ColorConstant.blackColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        if (controller.bookingDetailModel.value.result?.bookingDetail?.timeSlot == "")
                                          Obx(() {
                                            debugPrint('${controller.showLoader.value}');
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                (controller.bookingDetailModel.value.result?.bookingDetail
                                                            ?.bookingFromDate !=
                                                        controller.bookingDetailModel.value.result?.bookingDetail
                                                            ?.bookingToDate)
                                                    ? 'From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate ?? "2023-06-29"))} To ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingToDate ?? "2023-06-29"))}'
                                                    : ' ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("${controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate}"))}',
                                                style: TextStyle(
                                                    color: ColorConstant.blackColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                        controller.bookingDetailModel.value.result?.bookingDetail?.bookingType == "completed booking"
                            ? Container(
                                height: Get.height * 0.16,
                                width: double.infinity,
                                color: ColorConstant.greenColor.withOpacity(0.06),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 7.0),
                                      child: Image.asset(
                                        ImageConstant.bookingCalendarIcon,
                                        height: 44,
                                        width: 44,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        toLabelValue('your_booking_on'),
                                        style: TextStyle(
                                            color: ColorConstant.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),

                                    // with time
                                    if (controller.bookingDetailModel.value.result?.bookingDetail?.timeSlot != "")
                                      Obx(() {
                                        debugPrint('${controller.showLoader.value}');
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                (controller.bookingDetailModel.value.result?.bookingDetail
                                                            ?.bookingFromDate !=
                                                        controller.bookingDetailModel.value.result?.bookingDetail
                                                            ?.bookingToDate)
                                                    ? ' From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate ?? "2023-06-29"))} To ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingToDate ?? "2023-06-29"))}'
                                                    : ' ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("${controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate}"))}',
                                                style: TextStyle(
                                                    color: ColorConstant.blackColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${controller.bookingDetailModel.value.result?.bookingDetail?.timeSlot}',
                                                style: TextStyle(
                                                    color: ColorConstant.blackColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    if (controller.bookingDetailModel.value.result?.bookingDetail?.timeSlot == "")
                                      Obx(() {
                                        debugPrint('${controller.showLoader.value}');
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            (controller.bookingDetailModel.value.result?.bookingDetail
                                                        ?.bookingFromDate !=
                                                    controller
                                                        .bookingDetailModel.value.result?.bookingDetail?.bookingToDate)
                                                ? 'From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate ?? "2023-06-29"))} To ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.bookingDetailModel.value.result?.bookingDetail?.bookingToDate ?? "2023-06-29"))}'
                                                : ' ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("${controller.bookingDetailModel.value.result?.bookingDetail?.bookingFromDate}"))}',
                                            style: TextStyle(
                                                color: ColorConstant.blackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }),
                                  ],
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                          child: ListTile(
                            leading: Transform.scale(
                              scale: 1.4,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: CachedNetworkImage(
                                      imageUrl: controller.bookingDetailModel.value.result?.itemDetail?.itemImage ?? "",
                                      fit: BoxFit.fill,
                                      errorWidget: (context, url, error) {
                                        return const PlaceholderImage();
                                      },
                                      placeholder: (context, url) {
                                        return const PlaceholderImage();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    controller.bookingDetailModel.value.result?.itemDetail?.itemName ?? "",
                                    style: txtStyleTitleBoldBlack16(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  controller.bookingDetailModel.value.result?.itemDetail?.itemAmount == 0
                                      ? toLabelValue(ConstantsLabelKeys.label_free)
                                      : '${generalSetting?.result?.first.currency ?? ''} ${controller.bookingDetailModel.value.result?.itemDetail?.itemAmount.toStringAsFixed(3)}',
                                  style: txtStyleTitleBoldBlack14(color: ColorConstant.appThemeColor),
                                )
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.48,
                                    child: Text(
                                      controller.bookingDetailModel.value.result?.itemDetail?.itemAddress ?? "",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: txtStyleNormalGray14(),
                                      maxLines: 3,
                                    ),
                                  ),
                                  Text(
                                    DateTime.parse(controller
                                                .bookingDetailModel.value.result!.bookingDetail!.bookingScheduleDate ??
                                            '')
                                        .toLocal()
                                        .timeAgo(numericDates: false),
                                    style: TextStyle(
                                        color: ColorConstant.darkGrayColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(toLabelValue("special_instruction"), style: txtStyleTitleBoldBlack16()),
                              const SizedBox(height: 10),
                              Text(
                                controller.bookingDetailModel.value.result?.itemDetail?.itemInstructions ?? "",
                                style: txtStyleNormalGray14(),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 8.0, top: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                toLabelValue('payment_method'),
                                style: TextStyle(
                                    color: ColorConstant.blackColor, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset(
                                    ImageConstant.cardImage,
                                    height: 24,
                                    width: 37,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    toLabelValue(ConstantStrings.creditCardText),
                                    style: txtStyleNormalGray14(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${toLabelValue("transaction_id")} :",
                                    style: txtStyleTitleBoldBlack14(),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    controller.bookingDetailModel.value.result?.bookingDetail?.transactionId ?? "",
                                    style: txtStyleNormalGray14(),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        if (controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason != null &&
                            controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason != "")
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason !=
                                            null &&
                                        controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason != "")
                                      Text(
                                        toLabelValue('booking_cancel_reason'),
                                        style: txtStyleTitleBoldBlack16(),
                                      ),
                                    const SizedBox(height: descriptionSpacing),
                                    if (controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason !=
                                            null &&
                                        controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason != "")
                                      Text(
                                        controller.bookingDetailModel.value.result?.bookingDetail?.cancelReason ?? "-",
                                        style: txtStyleNormalGray14(),
                                      ),
                                    const SizedBox(
                                      height: descriptionSpacing * 2,
                                    ),
                                    Text(
                                      toLabelValue('cancelled_date'),
                                      style: txtStyleTitleBoldBlack16(),
                                    ),
                                    const SizedBox(
                                      height: descriptionSpacing,
                                    ),
                                    if (controller.bookingDetailModel.value.result?.bookingDetail?.cancelDate != null)
                                      Text(
                                        dateInputFormat.format(DateFormat("yyyy-MM-ddTHH:mm")
                                                .parse(
                                                    controller.bookingDetailModel.value.result?.bookingDetail
                                                            ?.cancelDate ??
                                                        "",
                                                    true)
                                                .toLocal()) ??
                                            "-",
                                        style: txtStyleNormalGray14(),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(toLabelValue(ConstantStrings.no_of_people), style: txtStyleTitleBoldBlack16()),
                              const SizedBox(height: 10),
                              Text(
                                controller.bookingDetailModel.value.result?.noOfPersons.toString() ?? '1',
                                style: txtStyleNormalGray14(),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            toLabelValue('sp_location'),
                            style:
                                TextStyle(color: ColorConstant.blackColor, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        controller.bookingDetailModel.value.result!.itemDetail!.is_location == 0 ||
                                controller.bookingDetailModel.value.result!.itemDetail!.is_location == ""
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: RichText(
                                            maxLines: 50,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text:
                                                    "${controller.bookingDetailModel.value.result?.providerDetail?.serviceProviderName ?? ""} ",
                                                style: txtStyleNormalGray14(color: Colors.red),
                                              ),
                                              TextSpan(
                                                text: "${toLabelValue('no_location')} ",
                                                style: txtStyleNormalGray14(),
                                              ),
                                            ]))),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  controller.bookingDetailModel.value.result?.providerDetail?.serviceProviderAddress ??
                                      "-",
                                  style: txtStyleNormalGray14(),
                                ),
                              ),
                        const SizedBox(height: 20),
                        controller.bookingDetailModel.value.result!.itemDetail!.is_location == 0 ||
                                controller.bookingDetailModel.value.result!.itemDetail!.is_location == ""
                            ? Container()
                            : CommonMapWidget(
                                latitude: double.parse(
                                    controller.bookingDetailModel.value.result!.itemDetail!.itemLatitude.toString()),
                                longitude: double.parse(
                                    controller.bookingDetailModel.value.result!.itemDetail!.itemLongitude.toString()),
                                markers: controller.markers.value,
                              ),
                        const SizedBox(height: 20),

                        /// TODO Cancel booking button is hidden as per client request Uncomment the code to display the button (Phase 2)
                        // if (controller.bookingDetailModel.value.result
                        //         ?.bookingDetail?.bookingType ==
                        //     "active booking")
                        //   Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 16),
                        //     child: SizedBox(
                        //       width: Get.width,
                        //       height: 52,
                        //       child: ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //               shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(10)),
                        //               side: BorderSide(
                        //                   color: ColorConstant.appThemeColor),
                        //               elevation: 0,
                        //               backgroundColor: Colors.white),
                        //           onPressed: () {
                        //             bookingID.value = controller
                        //                     .bookingDetailModel
                        //                     .value
                        //                     .result
                        //                     ?.bookingDetail
                        //                     ?.bookingId
                        //                     .toString() ??
                        //                 "";
                        //             controller.isButtonPressed.value = false;
                        //             controller.noteController.clear();
                        //             controller.updateBoolValues(0);
                        //             cancelBookingShowModalBottomSheet(context);
                        //           },
                        //           child: Text(
                        //             toLabelValue("cancel_booking"),
                        //             style: TextStyle(
                        //                 color: ColorConstant.appThemeColor,
                        //                 fontSize: 18),
                        //           )),
                        //     ),
                        //   ),

                        if (controller.bookingDetailModel.value.result?.bookingDetail?.bookingType ==
                                "completed booking" &&
                            controller.bookingDetailModel.value.result?.itemDetail?.rating == null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              width: Get.width,
                              // height: 42,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: ColorConstant.whiteColor,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: ColorConstant.appThemeColor),
                                        borderRadius: BorderRadius.circular(10.0)),
                                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                onPressed: () {
                                  giveRatingBottomSheet();
                                  //   Get.toNamed(AppRouteNameConstant.tabScreen);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    toLabelValue(ConstantStrings.rateText),
                                    style: TextStyle(color: ColorConstant.appThemeColor, fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : const Center(child: CommonNoDataFound()),
      ),
    );
  }

  void giveRatingBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 400,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            )),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    height: 5,
                    width: 80,
                    decoration: BoxDecoration(
                      color: ColorConstant.lightGrayColor,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Align(
                        alignment: language == '1' ? Alignment.topRight : Alignment.topLeft,
                        child: const Icon(
                          Icons.close_rounded,
                          size: 24,
                        ))),
                Obx(() {
                  return Center(
                    child: RatingBar.builder(
                      initialRating: controller.initialRating.value,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: ColorConstant.appThemeColor,
                      ),
                      onRatingUpdate: (rating) {
                        debugPrint('$rating');
                        controller.initialRating.value = rating;
                      },
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomTextFormField(
                    width: double.infinity,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[ a-zA-Z]")),
                    ],
                    controller: controller.textEditingController,
                    // focusNode: FocusNode(),
                    maxLines: 6,
                    hintText: toLabelValue(ConstantStrings.ratingText),
                    textInputType: TextInputType.text,
                    // onChanged: (value) {
                    //   controller.isTextFieldNotEmpty.value = value.isNotEmpty;
                    // },
                    margin: getMargin(
                      top: 10,
                    ),
                  ),
                ),
                Obx(() {
                  return Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: SizedBox(
                        width: Get.width,
                        child: controller.showButtonLoader.value
                            ? const Center(child: CommonLoading())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorConstant.appThemeColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                    padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 16),
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                onPressed: controller.textEditingController.value.text != null
                                    ? () {
                                        controller.addReview();
                                      }
                                    : null,
                                child: Text(
                                  toLabelValue(ConstantStrings.rateText),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                      ));
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> cancelBookingShowModalBottomSheet(BuildContext context) {
    BookingDetailController bController = Get.put(BookingDetailController());

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
                initialChildSize: 0.68,
                expand: true,
                builder: (context, scrollController) {
                  return GetBuilder<BookingDetailController>(builder: (bController) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          )),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: ListView(
                              shrinkWrap: true,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Center(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                    height: 5,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.lightGrayColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        '',
                                        style: txtStyleTitleBoldBlack16(),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: const Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 24,
                                            )))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    toLabelValue(ConstantStrings.booking_cancel_reason),
                                    style: txtStyleTitleBoldBlack16(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    toLabelValue(ConstantStrings.cancel_booking_charge_message),
                                    style: txtStyleNormalGray12(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Divider(
                                  thickness: 1,
                                ),
                                Obx(
                                  () => Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isButtonPressed.value = !controller.isButtonPressed.value;
                                          controller.updateBoolValues(1);
                                          if (controller.isButtonPressed.value == true) {
                                            controller.selectedvalue.value =
                                                toLabelValue(ConstantStrings.not_available_this_date);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: controller.isButtonPressed.value == false
                                                ? ColorConstant.whiteColor
                                                : ColorConstant.appThemeColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                                            child: Text(
                                              toLabelValue(ConstantStrings.not_available_this_date),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: controller.isButtonPressed.value == false
                                                    ? ColorConstant.blackColor
                                                    : ColorConstant.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                                Obx(
                                  () => Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isSecondButtonPressed.value =
                                              !controller.isSecondButtonPressed.value;
                                          controller.updateBoolValues(2);

                                          if (controller.isSecondButtonPressed.value == true) {
                                            controller.selectedvalue.value =
                                                toLabelValue(ConstantStrings.vender_misbehave);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: controller.isSecondButtonPressed.value == false
                                                ? ColorConstant.whiteColor
                                                : ColorConstant.appThemeColor,
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                                              child: Text(
                                                toLabelValue(ConstantStrings.vender_misbehave),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: controller.isSecondButtonPressed.value == false
                                                      ? ColorConstant.blackColor
                                                      : ColorConstant.whiteColor,
                                                ),
                                              )),
                                        ),
                                      )),
                                ),
                                Obx(
                                  () => Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.isThiredButtonPressed.value =
                                              !controller.isThiredButtonPressed.value;
                                          controller.updateBoolValues(3);

                                          if (controller.isThiredButtonPressed.value == true) {
                                            controller.selectedvalue.value =
                                                toLabelValue(ConstantStrings.service_terminate);
                                          }
                                        },
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: controller.isThiredButtonPressed.value == false
                                                ? ColorConstant.whiteColor
                                                : ColorConstant.appThemeColor,
                                          ),
                                          width: double.infinity,
                                          child: Padding(
                                              padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
                                              child: Text(
                                                toLabelValue(ConstantStrings.service_terminate),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: controller.isThiredButtonPressed.value == false
                                                      ? ColorConstant.blackColor
                                                      : ColorConstant.whiteColor,
                                                ),
                                              )),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: CustomTextFormField(
                                    width: double.infinity,
                                    controller: controller.noteController,
                                    maxLines: 6,
                                    hintText: toLabelValue(ConstantStrings.write_cancel_reason),
                                    textInputType: TextInputType.text,
                                    onChanged: (value) {
                                      // controller.noteController.text = value;
                                      bController.update();
                                    },
                                    margin: getMargin(
                                      top: 10,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Obx(
                                  () => controller.bookingDetailModel.value.result?.bookingDetail?.bookingType ==
                                          "active booking"
                                      ? bController.showLoader.value
                                          ? const CommonLoading()
                                          : Center(
                                              // key: globalKey,
                                              child: SizedBox(
                                                width: Get.width,
                                                height: 52,
                                                child: Obx(() {
                                                  return ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        backgroundColor: controller.noteController.text == ""
                                                            ? ColorConstant.grayTextFormFieldTextColor
                                                            : ColorConstant.appThemeColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0)),
                                                        textStyle: const TextStyle(
                                                            fontSize: 16, fontWeight: FontWeight.normal)),
                                                    onPressed: controller.noteController.text.isEmpty
                                                        ? null
                                                        : () {
                                                            bookingID.value = bController.bookingDetailModel.value
                                                                    .result?.bookingDetail?.bookingId
                                                                    .toString() ??
                                                                "";
                                                            controller.bookingCancel();
                                                            bController.update();
                                                            Get.back();
                                                          },
                                                    child: Text(
                                                      toLabelValue(ConstantStrings.cancel_booking),
                                                      style: const TextStyle(
                                                          color: Colors.white, fontWeight: FontWeight.w600),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            )
                                      : Container(),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }); //whatever you're returning, does not have to be a Container
                }),
          );
        });
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
