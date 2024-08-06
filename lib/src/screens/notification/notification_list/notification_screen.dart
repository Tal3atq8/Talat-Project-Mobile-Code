import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/screens/notification/notification_list/notification_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/utility.dart';

import '../../../app_routes/app_routes.dart';
import '../../../utils/global_constants.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          backgroundColor: ColorConstant.whiteColor,
          appBar: CustomAppbarNoSearchBar(
            title: toLabelValue(ConstantsLabelKeys.notifications).toString(),
            hideBackIcon: true,
          ),
          body: Obx(
            () => (controller.userId == null || controller.userId == "")
                ? Center(child: Text(toLabelValue(ConstantsLabelKeys.user_not_logged_in)))
                : SafeArea(
                    child: Stack(
                      children: [
                        controller.notificationList.isNotEmpty
                            ? SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: (controller.notificationList.isNotEmpty) ? true : false,
                                header: MaterialClassicHeader(
                                  backgroundColor: ColorConstant.appThemeColor,
                                  color: ColorConstant.whiteBackgroundColor,
                                ),
                                footer: CustomFooter(
                                  builder: (BuildContext context, LoadStatus? mode) {
                                    Widget body;
                                    if (mode == LoadStatus.loading) {
                                      body = const CupertinoActivityIndicator();
                                    } else if (mode == LoadStatus.noMore) {
                                      body = const Text("", textScaleFactor: 1.0);
                                    } else {
                                      body = const Text("", textScaleFactor: 1.0);
                                    }
                                    return SizedBox(
                                      height: 55.0,
                                      child: Center(child: body),
                                    );
                                  },
                                ),
                                controller: controller.refreshController,
                                onRefresh: () async {
                                  await Future.delayed(const Duration(milliseconds: 1000));
                                  controller.pageIndex(1);
                                  controller.showLoader(false);
                                  controller.getNotificationList();
                                  controller.refreshController.refreshCompleted();
                                },
                                onLoading: () async {
                                  await Future.delayed(const Duration(milliseconds: 1000));

                                  controller.pageIndex.value += 1;
                                  controller.showLoader(false);
                                  controller.getNotificationList();
                                  controller.refreshController.loadComplete();
                                },
                                child: ListView.builder(
                                    itemCount: controller.notificationList.length,
                                    shrinkWrap: true,
                                    // physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var notificationData = controller.notificationList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          bookingID.value = controller.notificationList[index].bookingId ?? "";
                                          Get.toNamed(AppRouteNameConstant.confirmBookingScreen);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: ColorConstant.grayBorderColor),
                                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0, right: 8.0, top: 12),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        ImageConstant.notificationCalendarIcon,
                                                        height: 46,
                                                        width: 46,
                                                      ),
                                                      Row(
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  // color: Colors.black,
                                                                  width: Get.width * 0.7,
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        notificationData.notificationTitle ==
                                                                                "Booking Cancel"
                                                                            ? toLabelValue(ConstantsLabelKeys
                                                                                .booking_cancelled_noti)
                                                                            : notificationData.notificationTitle ==
                                                                                    "Booking Confirm"
                                                                                ? toLabelValue(ConstantsLabelKeys
                                                                                    .your_booking_confrimed)
                                                                                : toLabelValue(ConstantsLabelKeys
                                                                                    .completed_booking),
                                                                        style: TextStyle(
                                                                            color: ColorConstant.blackColor,
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.normal),
                                                                      ),
                                                                      Text(
                                                                        '${generalSetting?.result?.first.currency ?? ''} ${notificationData.notificationAmount?.toStringAsFixed(3) ?? "0"}',
                                                                        style: TextStyle(
                                                                            //color: notificationData.title=='Booking Cancelled'?ColorConstant.appThemeColor:ColorConstant.greenColor,
                                                                            color: notificationData.notificationType ==
                                                                                    "1"
                                                                                ? ColorConstant.appThemeColor
                                                                                : notificationData.notificationType ==
                                                                                        "2"
                                                                                    ? ColorConstant.greenColor
                                                                                    : ColorConstant.blackColor,
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 4),
                                                                  child: SizedBox(
                                                                    width: Get.width * 0.7,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          DateTime.parse(
                                                                                  notificationData.notificationDate ??
                                                                                      "")
                                                                              .toLocal()
                                                                              .timeAgo(numericDates: false),
                                                                          style: TextStyle(
                                                                              color: ColorConstant.grayListDataColor,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.normal),
                                                                        ),
                                                                        Text(
                                                                          '#${notificationData.bookingId ?? ""}',
                                                                          style: TextStyle(
                                                                              //color: notificationData.title=='Booking Cancelled'?ColorConstant.appThemeColor:ColorConstant.greenColor,
                                                                              color: ColorConstant.blackColor,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(top: 10),
                                                                  child: Text(notificationData.activityName ?? "",
                                                                      style: const TextStyle(fontSize: 12)),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 20.0, left: 10, bottom: 18, right: 10),
                                                    child: Text(
                                                      notificationData.notificationType == "1"
                                                          ? toLabelValue(
                                                              ConstantsLabelKeys.your_booking_has_been_cancelled)
                                                          : toLabelValue(
                                                              ConstantsLabelKeys.your_booking_confrimed_noti),
                                                      style: TextStyle(
                                                          //  color: notificationData.title=='Booking Cancelled'?ColorConstant.appThemeColor:ColorConstant.greenColor,
                                                          color: notificationData.notificationType == "1"
                                                              ? ColorConstant.appThemeColor
                                                              : notificationData.notificationType == "2"
                                                                  ? ColorConstant.greenColor
                                                                  : ColorConstant.blackColor,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : controller.showLoader.value
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 40.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/notification_empty_image.png",
                                            height: 150,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Center(
                                            child: Text(toLabelValue(ConstantsLabelKeys.no_notification_yet),
                                                style: const TextStyle(
                                                  fontSize: 22,
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(toLabelValue(ConstantsLabelKeys.stay_tuned),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16, color: ColorConstant.grayBorderColor)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                        if (controller.showLoader.value)
                          Center(
                            child: CircularProgressIndicator(
                              color: ColorConstant.appThemeColor,
                            ),
                          ),
                      ],
                    ),
                  ),
          )),
    );
  }
}
