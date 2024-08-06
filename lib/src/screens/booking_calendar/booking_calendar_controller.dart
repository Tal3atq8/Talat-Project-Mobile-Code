import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../models/available_day_model.dart';
import '../../models/booking_success_model.dart';
import '../../models/check_available_booking_slot_model.dart';
import '../../models/get_time_slots_model.dart';
import '../dashboard/tabBar/tabbar_controller.dart';

class BookingCalendarController extends GetxController {
  RxList<DateTime?> rangeDatePickerValue = <DateTime>[].obs;
  RxString hintOtp = "".obs;
  RxString amount = "".obs;
  RxString categoryitemiddata = "".obs;
  RxString selectedname = "".obs;
  RxString itmeid = "".obs;
  RxString providerName = "".obs;
  RxString instruction = "".obs;
  RxBool showLoader = false.obs;
  RxBool isCalenderLoading = false.obs;
  RxBool showTimepicker = false.obs;
  int diffrerence = 0;
  RxList<String> listOfDate = <String>[].obs;
  RxList<String> listOfDateNoSlotAvailable = <String>[].obs;
  RxString totalAmount = "".obs;
  TextEditingController timeController = TextEditingController();
  String bookingDateTime = "";
  RxBool showContainer = false.obs;
  RxBool isAllSlotAvailable = false.obs;
  RxBool isAllSlotLoading = false.obs;
  var ammount = Get.arguments;
  RxString dateSlotId = ''.obs;

  RxInt selectedPeopleNumber = 1.obs;

  String? token;
  String? userId;
  String startDateStr = "";
  String endDateStr = "";
  RxInt selectedTimeSlot = 0.obs;
  String? name;
  Rx<GetTimeSlotsResponseModel> getTimeSlotsResponseModel = GetTimeSlotsResponseModel().obs;
  String? timeType;
  RxList<DateTime> availableDays = <DateTime>[].obs;

  Rx<CheckAvailableBookingSlotModel> checkAvailableBookingSlotModel = CheckAvailableBookingSlotModel().obs;

  @override
  void onInit() async {
    super.onInit();
    diffrerence = 1;

    name = await SharedPref.getString(PreferenceConstants.name);
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    providerName.value = await SharedPref.getString(PreferenceConstants.providerName);
    debugPrint(ammount);
    await getAvailableDate();
  }

  @override
  void onReady() async {
    super.onReady();
    selectedPeopleNumber.value = 1;
    await getAmount();
  }

  Future<void> bookingSuccess({String? transactionId, dynamic paymentResponse, String? totalAMT, commission}) async {
    bookingDateTime = DateFormat('HH:mm:ss').format(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute)
        .toUtc());

    showLoader.value = true;
    showLoader.refresh();
    try {
      await TalatService().bookingConfirmApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.userIdKey: userId,
        ConstantStrings.bookingAmountKey: activityDetailItem.value.typeOfActivity!.toLowerCase() == "day"
            ? totalAmount.value
            : (activityDetailItem.value.discountedPrice == 0
                ? activityDetailItem.value.initialPrice
                : activityDetailItem.value.discountedPrice),
        ConstantStrings.providerIdKey: providerID.value,
        ConstantStrings.mycategoryIdKey: categoryID.value,
        ConstantStrings.categoryitemid: activityDetailItem.value.itemId,
        ConstantStrings.bookingStartDate: startDateStr.toString(),
        ConstantStrings.bookingEndDate:
            activityDetailItem.value.typeOfActivity!.toLowerCase() == "day" ? endDateStr : startDateStr,
        "slot_id": activityDetailItem.value.typeOfActivity == "Day"
            ? dateSlotId.value
            : getTimeSlotsResponseModel.value.result?[selectedTimeSlot.value].id.toString() ?? "",
        // ConstantStrings.instructionKey: emptyText,
        "total_amount": totalAMT,
        "commisson_per": commission,
        "transaction_id": transactionId ?? '',
        "status": "success",
        "paymnet_response": paymentResponse ?? '',
        "payment_method": "knet",
        "no_of_persons": selectedPeopleNumber.value.toString()
      }).then((response) async {
        dateSlotId.value = "";
        if (response.data['code'] == 200) {
          BookingSuccessModel bookingSuccessModel = BookingSuccessModel.fromJson(response.data);
          TabbarController.to.currentIndex.value = 0;
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // Get.toNamed(AppRouteNameConstant.dashboardScreen);
          // Get.offAndToNamed(AppRouteNameConstant.bookingConfirmScreen, arguments: bookingSuccessModel);
          showLoader(false);
          showLoader.refresh();
          isCalenderLoading(false);
          isAllSlotLoading(false);
          CommonWidgets().showToastMessage("booking_confirm");
          // isFromCalendar.value = "1";
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
          showLoader.refresh();
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          showLoader.refresh();
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        showLoader.value = false;
        showLoader.refresh();
        // Get.back();
        debugPrint(error.toString());
      });
    } on DioException catch (e) {
      showLoader.value = false;
      showLoader.refresh();
      debugPrint("authenticateUser-error dio error >>>> ${e.toString()}");
    }
    update();
  }

  Future<void> getTimeSlots() async {
    showLoader(true);
    showLoader.refresh();
    isAllSlotLoading(true);
    await TalatService().getTimeSlot({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.deviceTokenKey: token,
      ConstantStrings.userIdKey: userId,
      "item_id": activityDetailItem.value.itemId,
      "date": startDateStr,
    }).then((value) {
      showLoader(false);
      showLoader.refresh();
      getTimeSlotsResponseModel.value = GetTimeSlotsResponseModel.fromJson(value.data);
      update();
    });
    showLoader(false);
    isAllSlotLoading(false);
    showLoader.refresh();
    update();
  }

  getAmount() {
    if (activityDetailItem.value.discountedPrice == 0) {
      totalAmount.value = "${activityDetailItem.value.initialPrice}";
    } else {
      totalAmount.value = "${activityDetailItem.value.discountedPrice}";
    }
  }

  getAvailableDate() async {
    isCalenderLoading(true);
    await TalatService().getAvailableDate({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.deviceTokenKey: token,
      ConstantStrings.userIdKey: userId,
      "activity_id": activityDetailItem.value.itemId,
    }).then((response) async {
      try {
        isCalenderLoading(false);
        AvailableDaysModel days = AvailableDaysModel.fromJson(response.data);
        List<DateTime> tempDays = [];
        availableDays.clear();
        if (days.result != null) {
          for (AvailableStartEndDate element in days.result!) {
            for (int i = 0;
                i <= DateTime.parse(element.endDate ?? '').difference(DateTime.parse(element.startDate ?? '')).inDays;
                i++) {
              tempDays.add(DateTime(DateTime.parse(element.startDate ?? '').year,
                      DateTime.parse(element.startDate ?? '').month, DateTime.parse(element.startDate ?? '').day)
                  .add(Duration(days: i)));
            }
            if (tempDays.isNotEmpty) {
              availableDays.clear();
              availableDays.addAll(tempDays);
            }
          }
          if (activityDetailItem.value.typeOfActivity == "Day") {
            checkAvailableBookingSlot();
          }
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
          showLoader.refresh();
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          showLoader.refresh();
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
        debugPrint('$availableDays');
        update();
      } catch (e) {
        debugPrint('$e');
      }
    });
    isCalenderLoading(false);
    update();
  }

  checkAvailableBookingSlot() async {
    // isCalenderLoading(true);
    await TalatService().checkAvailableBookingSlot({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.deviceTokenKey: token,
      ConstantStrings.userIdKey: userId,
      "item_id": activityDetailItem.value.itemId,
      "start_date": startDateStr,
      "end_date": endDateStr,
      "day_base": activityDetailItem.value.typeOfActivity == "Day" ? "1" : "0",
    }).then((response) async {
      try {
        isCalenderLoading(false);
        debugPrint("=========================== checkAvailableBookingSlot $response");
        if (response.data != null && response.data["code"].toString() == "200") {
          checkAvailableBookingSlotModel.value = CheckAvailableBookingSlotModel.fromJson(response.data);
          debugPrint("checkAvailableBookingSlotModel $checkAvailableBookingSlotModel");
          update();
        } else if (response.data["code"].toString() == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"].toString() == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
          showLoader.refresh();
        } else if (response.data["code"].toString() == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          showLoader.refresh();
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
        debugPrint('$availableDays');
        update();
      } catch (e) {
        debugPrint('$e');
      }
    });
    isCalenderLoading(false);
    update();
  }
}
