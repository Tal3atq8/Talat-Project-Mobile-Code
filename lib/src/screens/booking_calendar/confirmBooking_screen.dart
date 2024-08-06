import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/booking_success_model.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';

import '../../widgets/common_text_style.dart';
import '../dashboard/dashboard_screen_binding.dart';
import '../dashboard/tabBar/tabbar_binding.dart';
import '../my_booking/my_booking_detail/my_booking_detail_binding.dart';
import '../my_booking/my_booking_detail/my_booking_detail_controller.dart';

class ConfirmBooking extends StatefulWidget {
  const ConfirmBooking({Key? key}) : super(key: key);

  @override
  State<ConfirmBooking> createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  final intl.DateFormat formatter = intl.DateFormat('dd MMM yyyy');

  BookingSuccessModel? bookingSuccessModel;

  @override
  Widget build(BuildContext context) {
    bookingSuccessModel = Get.arguments;
    return WillPopScope(
      onWillPop: () {
        TabbarBinding().dependencies();
        DashboardBinding().dependencies();
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        return Future(() => true);
      },
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 78.0, right: 78, bottom: 40, top: Get.height * 0.22),
              child: Image.asset(ImageConstant.myBookingEmptyImage),
            ),
            Text(
              toLabelValue(ConstantStrings.bookingConfirmText),
              style: txtStyleTitleBoldBlack18(),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectedEndDate.value != "")
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${toLabelValue("your_booking_from")} ',
                                textAlign: TextAlign.center,
                                style: txtStyleNormalBlack14()),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                  formatter.format(
                                      DateTime.parse(selectedStartDate.value)),
                                  textAlign: TextAlign.center,
                                  style: txtStyleNormalBlack14()),
                            ),
                            Text(' ${toLabelValue("to_date_label")} ',
                                textAlign: TextAlign.center,
                                style: txtStyleNormalBlack14()),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                  formatter.format(
                                      DateTime.parse(selectedEndDate.value)),
                                  textAlign: TextAlign.center,
                                  style: txtStyleNormalBlack14()),
                            ),
                          ],
                        ),
                        Text(
                            "\n${"${toLabelValue("with_label")}" " ${serviceProviderName.value}"}.",
                            textAlign: TextAlign.center,
                            style: txtStyleNormalBlack14()),
                      ],
                    ),
                  if (selectedEndDate.value == null &&
                      selectedEndDate.value == "")
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          formatter
                              .format(DateTime.parse(selectedStartDate.value)),
                          style: txtStyleNormalBlack14()),
                    ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.appThemeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    // Get.toNamed(AppRouteNameConstant.myBookingScreen);
                    BookingDetailBinding().dependencies();
                    bookingID.value =
                        bookingSuccessModel?.result?.bookingId.toString() ?? '';
                    Get.find<BookingDetailController>().bookingDetail();

                    Get.offAndToNamed(AppRouteNameConstant.confirmBookingScreen,
                        arguments: bookingID.value);
                  },
                  child: Text(
                    toLabelValue(ConstantStrings.checkDetailText),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
