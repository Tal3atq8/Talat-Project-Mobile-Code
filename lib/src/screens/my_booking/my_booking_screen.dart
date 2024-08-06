import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/my_booking/my_booking_detail/my_booking_detail_binding.dart';
import 'package:talat/src/screens/my_booking/my_booking_detail/my_booking_detail_controller.dart';
import 'package:talat/src/screens/my_booking/my_booking_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/utility.dart';

import '../../utils/global_constants.dart';
import '../../widgets/common_text_style.dart';

class MyBooking extends StatelessWidget {
  MyBooking({Key? key}) : super(key: key);
  final controller = Get.put(MyBookingScreenController());
  DateTime? endDates;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFromCalendar.value == "0") {
          Get.back();
        } else {
          Get.find<DashboardController>().page.value = 1;
          Get.find<DashboardController>().initLimit.value = 5;
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          isFromCalendar.value = "0";
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: ColorConstant.whiteColor,
          appBar: CustomAppbarNoSearchBar(
            title: toLabelValue(ConstantsLabelKeys.myBookingText).toString(),
            onBackPressed: () {
              if (isFromCalendar.value == "0") {
                Get.back();
              } else {
                Get.find<DashboardController>().page.value = 1;
                Get.find<DashboardController>().initLimit.value = 5;
                Get.offAllNamed(AppRouteNameConstant.tabScreen);
                isFromCalendar.value = "0";
              }
            },
          ),
          body: Obx(
            () => Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IgnorePointer(
                    ignoring: controller.showLoader.value ? true : false,
                    child: controller.bookingItem.value.result == null
                        ? const SizedBox()
                        : ((controller.bookingItem.value.result!.activeBooking!.isNotEmpty) ||
                                (controller.bookingItem.value.result!.cancelBooking!.isNotEmpty) ||
                                (controller.bookingItem.value.result!.completedBooking!.isNotEmpty))
                            ? SmartRefresher(
                                header: MaterialClassicHeader(
                                  backgroundColor: ColorConstant.appThemeColor,
                                  color: ColorConstant.whiteBackgroundColor,
                                ),
                                onRefresh: () {
                                  controller.getBookingList(isRefresh: true);
                                },
                                controller: controller.bookingRefreshController,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (controller.bookingItem.value.result?.activeBooking?.isNotEmpty == true)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, top: 16, right: 20),
                                        child: Text(
                                          toLabelValue("active_booking"),
                                          style: txtStyleTitleBoldBlack14(),
                                        ),
                                      ),
                                    if (controller.bookingItem.value.result?.activeBooking?.isNotEmpty == true)
                                      activeBookingList(),
                                    if (controller.bookingItem.value.result?.completedBooking != null &&
                                        controller.bookingItem.value.result!.completedBooking!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18.0, top: 18, right: 20),
                                        child: Text(
                                          toLabelValue("completed_booking"),
                                          style: txtStyleTitleBoldBlack14(),
                                        ),
                                      ),
                                    if (controller.bookingItem.value.result?.completedBooking != null &&
                                        controller.bookingItem.value.result!.completedBooking!.isNotEmpty)
                                      completedBookingList(),
                                    if (controller.bookingItem.value.result?.cancelBooking?.isNotEmpty == true)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0, top: 18, right: 20),
                                        child: Text(
                                          toLabelValue("cancel_booking"),
                                          style: txtStyleTitleBoldBlack14(),
                                        ),
                                      ),
                                    if (controller.bookingItem.value.result?.cancelBooking?.isNotEmpty == true)
                                      cancelBookingList(),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              )
                            : controller.showLoader.value
                                ? const SizedBox()
                                : Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/my_booking_empty_image.png",
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Center(
                                        child: Text(toLabelValue("no_booking_yet"),
                                            style: const TextStyle(
                                              fontSize: 22,
                                            )),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Center(
                                          child: Text(toLabelValue("this_section_will_contain_status_booking"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16, color: ColorConstant.grayBorderColor)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                        child: SizedBox(
                                          height: 46,
                                          width: Get.width * .4,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: ColorConstant.appThemeColor,
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                              onPressed: () {
                                                Get.offAllNamed(AppRouteNameConstant.tabScreen);
                                              },
                                              child: Text(toLabelValue("start_booking"))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  )),
                if (controller.showLoader.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.appThemeColor,
                    ),
                  ),
              ],
            ),
          )),
    );
  }

  ListView cancelBookingList() {
    return ListView.builder(
        itemCount: controller.bookingItem.value.result?.cancelBooking?.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          var bookingData = controller.bookingItem.value.result?.cancelBooking?[index];
          return GestureDetector(
            onTap: () {
              BookingDetailBinding().dependencies();
              bookingID.value = bookingData!.bookingId.toString();
              Get.find<BookingDetailController>().bookingDetail();

              Get.toNamed(AppRouteNameConstant.confirmBookingScreen, arguments: bookingData.bookingId);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 18, right: 18),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.grayBorderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "# ${bookingData?.bookingId.toString() ?? ""}",
                            style:
                                TextStyle(color: ColorConstant.blackColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            bookingData?.bookingAmount != 0
                                ? '${generalSetting?.result?.first.currency ?? ''} ${bookingData?.bookingAmount!.toStringAsFixed(3)}'
                                : toLabelValue(ConstantsLabelKeys.label_free),
                            style: TextStyle(
                                color: ColorConstant.appThemeColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          bookingData?.serviceProviderInfo?.serviceProviderName ?? "",
                          style:
                              TextStyle(color: ColorConstant.blackColor, fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              toLabelValue("you_booking_cancelled"),
                              style: TextStyle(
                                  color: ColorConstant.appThemeColor, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  ListView completedBookingList() {
    return ListView.builder(
        itemCount: controller.bookingItem.value.result?.completedBooking?.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          var bookingData = controller.bookingItem.value.result?.completedBooking?[index];

          DateTime startDates = intl.DateFormat("yyyy-MM-dd").parse(bookingData?.bookingFromDate ?? '');
          // }
          if (bookingData?.bookingToDate != null &&
              bookingData!.bookingToDate != "" &&
              bookingData.bookingToDate != "0000-00-00") {
            endDates = intl.DateFormat("yyyy-MM-dd").parse(bookingData.bookingToDate!);
          }
          return GestureDetector(
            onTap: () {
              BookingDetailBinding().dependencies();
              bookingID.value = bookingData?.bookingId.toString() ?? '';
              Get.find<BookingDetailController>().bookingDetail();

              Get.toNamed(AppRouteNameConstant.confirmBookingScreen, arguments: bookingData?.bookingId);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 18, right: 18),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.grayBorderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "# ${bookingData?.bookingId.toString() ?? ""}",
                            style:
                                TextStyle(color: ColorConstant.blackColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${(bookingData?.bookingAmount != null && bookingData?.bookingAmount != 0) ? generalSetting?.result?.first.currency ?? '' : ''} ${bookingData?.bookingAmount != null ? bookingData?.bookingAmount != 0 ? bookingData?.bookingAmount!.toStringAsFixed(3) ?? '' : toLabelValue(ConstantsLabelKeys.label_free) : ''}',
                            style: TextStyle(
                                color: ColorConstant.grayLightListDataColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          bookingData?.serviceProviderInfo?.serviceProviderName ?? "",
                          style:
                              TextStyle(color: ColorConstant.blackColor, fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              "${toLabelValue("your_booking_date_was")}"
                              ":",
                              style: completeBookingTextStyle(),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            (bookingData?.bookingToDate != null && bookingData?.timeSlot == "")
                                ? (bookingData?.bookingToDate != bookingData?.bookingFromDate)
                                    ? Row(
                                        children: [
                                          Text(
                                            '${toLabelValue('from_date_label')} ',
                                            style: completeBookingTextStyle(),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              intl.DateFormat("d MMM yyyy").format(startDates),
                                              style: completeBookingTextStyle(),
                                            ),
                                          ),
                                          Text(
                                            ' ${toLabelValue("to_date_label")} ',
                                            style: completeBookingTextStyle(),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              intl.DateFormat('d MMM yyyy').format(endDates!),
                                              style: completeBookingTextStyle(),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Text(
                                          intl.DateFormat('d MMM yyyy').format(endDates!),
                                          style: completeBookingTextStyle(),
                                        ),
                                      )
                                : (bookingData?.timeSlot != "")
                                    ? Row(
                                        children: [
                                          Text(
                                              intl.DateFormat(
                                                "d MMM yyyy",
                                              ).format(startDates),
                                              style: completeBookingTextStyle()),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6),
                                            child: SizedBox(
                                              child: Text("-"),
                                            ),
                                          ),
                                          Text(bookingData?.timeSlot ?? "", style: completeBookingTextStyle()),
                                        ],
                                      )
                                    : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  TextStyle completeBookingTextStyle() {
    return const TextStyle(
        // color: ColorConstant
        //     .appThemeColor,
        fontSize: 12,
        fontWeight: FontWeight.normal);
  }

  ListView activeBookingList() {
    return ListView.builder(
        itemCount: controller.bookingItem.value.result?.activeBooking?.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          var bookingData = controller.bookingItem.value.result?.activeBooking![index];

          DateTime startDates = intl.DateFormat("yyyy-MM-dd").parse(bookingData!.bookingFromDate!);
          if (bookingData.bookingToDate != null && bookingData.bookingToDate != "") {
            endDates = intl.DateFormat("yyyy-MM-dd").parse(bookingData.bookingToDate!);
          }

          return GestureDetector(
            onTap: () {
              BookingDetailBinding().dependencies();
              bookingID.value = bookingData.bookingId.toString();
              Get.find<BookingDetailController>().providerName.value =
                  bookingData.serviceProviderInfo?.serviceProviderName ?? "";
              Get.find<BookingDetailController>().bookingDetail();
              Get.toNamed(AppRouteNameConstant.confirmBookingScreen);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 18, right: 18),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorConstant.grayBorderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#${bookingData.bookingId.toString()}",
                            style: txtStyleTitleBoldBlack16(),
                          ),
                          Text(
                            bookingData.bookingAmount != 0
                                ? '${generalSetting?.result?.first.currency ?? ''} ${bookingData.bookingAmount!}.00'
                                : toLabelValue(ConstantsLabelKeys.label_free),
                            style: txtStyleTitleBoldBlack14(color: ColorConstant.greenColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          bookingData.bookingName ?? "",
                          style:
                              TextStyle(color: ColorConstant.blackColor, fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                              '${toLabelValue("your_booking_date")} :',
                              style: txtStyleTitleBoldBlack12(color: ColorConstant.grayTextColor),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            if (bookingData.timeSlot != "")
                              Row(
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(intl.DateFormat('d MMM yyyy').format(startDates),
                                        style: txtStyleTextStyleGreen12()),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                    child: SizedBox(
                                      child: Text("-"),
                                    ),
                                  ),
                                  Text(bookingData.timeSlot ?? "", style: txtStyleTextStyleGreen12()),
                                ],
                              ),
                            if (bookingData.bookingToDate != null && bookingData.timeSlot == "")
                              // Text(
                              //   'From ${intl.DateFormat('d MMM yyyy').format(startDates)} To ${(bookingData.bookingToDate != null && bookingData.bookingToDate != "") ? intl.DateFormat('d MMM yyyy').format(endDates!) : ""}',
                              //
                              //   //'  From ${'28 April 2023'} To ${'29 April 2023'}',
                              //   style: txtStyleTextStyleGreen14(),
                              // ),
                              Row(
                                children: [
                                  Text(
                                    '${toLabelValue('from_date_label')} ',
                                    style: txtStyleTextStyleGreen12(),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      intl.DateFormat('d MMM yyyy').format(startDates),
                                      style: txtStyleTextStyleGreen12(),
                                    ),
                                  ),
                                  Text(
                                    ' ${toLabelValue('to_date_label')} ',
                                    style: txtStyleTextStyleGreen12(),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      (bookingData.bookingToDate != null && bookingData.bookingToDate != "")
                                          ? intl.DateFormat('d MMM yyyy').format(endDates!)
                                          : "",
                                      style: txtStyleTextStyleGreen12(),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
