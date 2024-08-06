import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../app_routes/app_routes.dart';
import '../../../models/booking_detail_model.dart';
import '../../../utils/global_constants.dart';
import '../my_booking_screen_binding.dart';
import '../my_booking_screen_controller.dart';

class BookingDetailController extends GetxController {
  final selectedvalue = "".obs;
  RxBool isButtonPressed = false.obs;
  RxBool isSecondButtonPressed = false.obs;
  RxBool isThiredButtonPressed = false.obs;
  TextEditingController noteController = TextEditingController();
  Rx<BookingDetailResponseModel> bookingDetailModel = BookingDetailResponseModel().obs;
  RxDouble initialRating = 0.0.obs;
  final cancelBookingFormKey = GlobalKey<FormState>();
  RxBool isFormValid = false.obs;
  TextEditingController textEditingController = TextEditingController();
  RxBool isTextFieldNotEmpty = false.obs;
  String? token;
  String? userId;
  String? name;
  String? countryCode;
  String? mobileNo;
  RxBool showLoader = false.obs;
  RxBool showButtonLoader = false.obs;
  RxBool isClose = false.obs;
  RxString myBookingId = "".obs;
  int? rate;

  RxString bookingId = "".obs;
  RxString providerName = "".obs;
  RxInt selectedbookingId = 0.obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  String? emtyText = "";

  void updateBoolValues(int buttonNumber) {
    isButtonPressed.value = buttonNumber == 1;
    isSecondButtonPressed.value = buttonNumber == 2;
    isThiredButtonPressed.value = buttonNumber == 3;
  }

  @override
  void onInit() async {
    super.onInit();

    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    name = await SharedPref.getString(PreferenceConstants.name);
    mobileNo = await SharedPref.getString(PreferenceConstants.mobileKey);
    countryCode = await SharedPref.getString(PreferenceConstants.contryCodeKey);

    bookingDetail();
  }

  Future<void> addMarker(LatLng position) async {
    BitmapDescriptor markerbitmapRed = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      ImageConstant.talatLogo,
    );

    markers.add(
      Marker(
        visible: true,
        markerId: MarkerId("${bookingDetailModel.value.result!.itemDetail!.itemId}"),
        position: position,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  /// Review api calling

  void addReview() async {
    String? errorMessage;
    if (initialRating < 1) {
      errorMessage = "please_give_rating";
    } else if (textEditingController.value.text.trim().isEmpty) {
      errorMessage = "please_write_review";
    }
    if (errorMessage != null) {
      CommonWidgets().customSnackBar("title", errorMessage);
    } else {
      showButtonLoader(true);
      try {
        await TalatService().addReviewApi({
          ConstantStrings.userTypeKey: '1',
          ConstantStrings.deviceTypeKey: '1',
          ConstantStrings.userIdKey: userId,
          ConstantStrings.deviceTokenKey: token,
          ConstantStrings.languageId: language ?? "1",
          "booking_id": bookingDetailModel.value.result?.bookingDetail?.bookingId ?? "",
          ConstantStrings.itemIdKey: bookingDetailModel.value.result?.itemDetail?.itemId ?? "",
          "provider_id": bookingDetailModel.value.result?.providerDetail?.serviceProviderId ?? "",
          ConstantStrings.ratingKey: initialRating.value,
          ConstantStrings.reviewKey: textEditingController.text,
        }).then((response) async {
          if (response.data['code'] == "1") {
            Get.back();
            // CommonWidgets()
            //     .customSnackBar("Talat", 'Your Review add successfully');
            bookingDetail();
            CommonWidgets().showToastMessage("review_added");
            showButtonLoader(false);
            initialRating.value = 0.0;
            textEditingController.clear();
            update();
          } else if (response.data["code"] == "-7") {
            // Get.back();
            CommonWidgets().showToastMessage('user_login_other_device');
            language = await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
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
          } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
            showLoader.value = false;
            CommonWidgets().showToastMessage(response.data["message"]);
            language = await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
            // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
            update();
          }
        }).catchError((error) {
          debugPrint(error.toString());
          showButtonLoader(false);
        });
      } on DioError catch (e) {
        showButtonLoader(false);
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      }
      update();
    }
  }

  /// Booking Detail api calling
  void bookingDetail() async {
    showLoader.value = true;
    try {
      token = await SharedPref.getString(PreferenceConstants.token);
      userId = await SharedPref.getString(PreferenceConstants.userId);
      await TalatService().bookingDetailApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.bookingIdKey: bookingID.value,
      }).then((response) async {
        if (response.data['code'] == 200) {
          bookingDetailModel.value = BookingDetailResponseModel.fromJson(response.data);
          addMarker(LatLng(double.parse(bookingDetailModel.value.result!.itemDetail!.itemLatitude.toString()),
              double.parse(bookingDetailModel.value.result!.itemDetail!.itemLongitude.toString())));
          update();
          showLoader.value = false;
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
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint("Error in Booking Details : ${error.toString()}");
        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUser-error dio error >>>> ${e.toString()}");
    }
    // showLoader.value = false;
  }

  /// Booking Detail api calling
  Future<bool?> bookingCancel() async {
    showLoader.value = true;

    try {
      await TalatService().bookingCancelApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.bookingIdKey: bookingID.value,
        ConstantStrings.cancelTypeKey: selectedvalue.value,
        ConstantStrings.cancelReasonKey: noteController.text.isNotEmpty == true ? noteController.text : emtyText,
      }).then((response) async {
        if (response.data['code'] == "1") {
          Get.back();
          // Get.back();
          showLoader.value = false;
          bookingDetail();
          CommonWidgets().customSnackBar("Talat", CommonWidgets().showToastMessage("your_booking_has_been_cancelled"));

          // Future.delayed(Duration.zero, () {
          MyBookingBinding().dependencies();
          Get.find<MyBookingScreenController>().getBookingList();
          Get.back();
          // });
          // bookingDetailModel.value =
          //     BookingDetailResponseModel.fromJson(response.data);

          // MyBookingBinding().dependencies();
          // Get.find<MyBookingScreenController>().getBookingList();
          return true;
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
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());

        showLoader.value = false;
      });
    } on DioError catch (e) {
      showLoader.value = false;
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      return false;
    }
    update();
  }

  void openDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Booking Cancelled!"),
        content: Text("Your booking has been cancelled with “Vendor name here”"),
        actions: [
          TextButton(
              child: Text(ConstantStrings.yes),
              onPressed: () {
                Get.back();
                showLoader.value = true;
                bookingCancel();
              }),
        ],
      ),
    );
  }
}
