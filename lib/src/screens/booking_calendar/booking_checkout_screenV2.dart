import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:talat/main.dart';
import 'package:talat/src/models/pay_now_success_model.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/enums/enum.dart';
import '../../utils/preference/preference_keys.dart';
import '../../utils/preference/preferences.dart';
import '../../widgets/common_map_widget.dart';
import 'booking_calendar_controller.dart';

class BookingCheckoutScreenV2 extends StatefulWidget {
  const BookingCheckoutScreenV2({super.key});

  @override
  State<BookingCheckoutScreenV2> createState() => _BookingCheckoutScreenV2State();
}

class _BookingCheckoutScreenV2State extends State<BookingCheckoutScreenV2> {
  final dateInputFormat = DateFormat('d MMM yyyy hh:mm a');

  final controller = Get.find<BookingCalendarController>();

  RxBool isButtonTaped = false.obs;
  bool webview = false;
  PayNowSuccessModel? paymentResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: CustomAppbarNoSearchBar(
          title: toLabelValue(ConstantStrings.confirmBooking),
          disableAutoBack: backgroundMessage != null,
          onBackPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() => controller.showLoader.isTrue
          ? Center(
              child: Padding(
                padding: EdgeInsets.only(right: language == '1' ? 16 : 0, left: language == '2' ? 16 : 0, top: 14),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: ColorConstant.appThemeColor,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
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
                          '${serviceProviderName.value}',
                          style: txtStyleTitleBoldBlack18(),
                        ),
                        // Text(
                        //   'KD ${controller.totalAmount.value}',
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
                          '  "${ConstantStrings.countryCodeKuwait}"  $serviceProviderNumber ',
                          style:
                              TextStyle(color: ColorConstant.appThemeColor, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      height: 130,
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
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              toLabelValue(ConstantsLabelKeys.your_booking_on),
                              style: TextStyle(
                                  color: ColorConstant.blackColor, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                          // Time slot
                          if (activityDetailItem.value.typeOfActivity == 'Time')
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'From '
                                    '${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.startDateStr))}',
                                    style: TextStyle(
                                      color: ColorConstant.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '$selectedSlot',
                                    style: TextStyle(
                                        color: ColorConstant.blackColor, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          if (activityDetailItem.value.typeOfActivity == 'Day')
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                selectedStartDate == selectedEndDate
                                    ? 'From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("$selectedStartDate"))}'
                                    : ' From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("$selectedStartDate"))} To ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("$selectedEndDate"))}',
                                style: TextStyle(
                                    color: ColorConstant.blackColor, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
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
                                imageUrl: activityDetailItem.value.images?.first.imageUrl ?? '',
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
                              "${activityDetailItem.value.itemName}",
                              style: txtStyleTitleBoldBlack16(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${generalSetting?.result?.first.currency ?? ''} ${activityDetailItem.value.discountedPrice == 0 ? '${(double.parse(controller.totalAmount.value))}' : '${(double.parse(controller.totalAmount.value.toString()))}'}',
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
                                "${activityDetailItem.value.address}",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: txtStyleNormalGray14(),
                                maxLines: 3,
                              ),
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
                          "$specialInstruction",
                          style: txtStyleNormalGray14(),
                        )
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
                          controller.selectedPeopleNumber.value.toString(),
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
                      style: TextStyle(color: ColorConstant.blackColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  activityDetailItem.value.is_location == 0 || activityDetailItem.value.is_location == ""
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: RichText(
                                      maxLines: 50,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "${serviceProviderName.value} ",
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
                      : CommonMapWidget(
                          latitude: double.parse("${activityDetailItem.value.latitude}"),
                          longitude: double.parse("${activityDetailItem.value.longitude}"),
                          markers: {
                            Marker(
                              visible: true,
                              markerId: MarkerId("${activityDetailItem.value.itemId}"),
                              position: LatLng(double.parse("${activityDetailItem.value.latitude}"),
                                  double.parse("${activityDetailItem.value.longitude}")),
                              // infoWindow: InfoWindow(title: "${result?.providerName}"),
                              icon: BitmapDescriptor.defaultMarker,
                            )
                          },
                        ),
                  const SizedBox(height: 20),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorConstant.lightTextGrayColor.withOpacity(.3)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${toLabelValue(ConstantsLabelKeys.note)}: ',
                            style:
                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorConstant.blackColor),
                          ),
                          SizedBox(
                            width: Get.width * .71,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.refundpolicy);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  toLabelValue(ConstantsLabelKeys.refund_policy_note),
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.normal, color: ColorConstant.blackColor),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: Get.width,
                      // height: 42,
                      child: Obx(() {
                        if (isButtonTaped.isTrue) {
                          return activityDetailItem.value.initialPrice == 0
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: ColorConstant.appThemeColor,
                                ))
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: ColorConstant.whiteColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: ColorConstant.appThemeColor),
                                          borderRadius: BorderRadius.circular(10.0)),
                                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Text(
                                      toLabelValue(ConstantsLabelKeys.label_pay_now).toUpperCase(),
                                      style: TextStyle(color: ColorConstant.appThemeColor, fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                );
                        } else {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: ColorConstant.whiteColor,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: ColorConstant.appThemeColor),
                                    borderRadius: BorderRadius.circular(10.0)),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                            onPressed: () {
                              isButtonTaped(true);
                              isButtonTaped.refresh();
                              if (activityDetailItem.value.initialPrice == 0) {
                                debugPrint("test 11");
                                controller
                                    .bookingSuccess(totalAMT: "", commission: "")
                                    .then((value) => isButtonTaped(false));
                              } else {
                                debugPrint("test 22");
                                // paymentDetails userData = kentPaymentUserDetail()!;
                                try {
                                  RequestPayments(context, OnSuccess, OnFailure, false);
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                toLabelValue(ConstantsLabelKeys.label_pay_now).toUpperCase(),
                                style: TextStyle(color: ColorConstant.appThemeColor, fontWeight: FontWeight.w300),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )),
    );
  }

  OnSuccess(isSuccess, data, message) {
    setState(() {
      debugPrint("DAATAAAA ${data}");
      controller.bookingSuccess(
        transactionId: data["TranID"][0],
        paymentResponse: data.toString(),
        totalAMT: paymentResponse?.result.total_amount.toString(),
        commission: paymentResponse?.result.commissonPer.toString(),
      );
      webview = isSuccess;
    });
  }

  OnFailure(isSuccess, TransactionDetails, message) {
    setState(() {
      webview = isSuccess;
    });
    Get.offAndToNamed(AppRouteNameConstant.paymentFailScreen);
  }

  /// Payment pop
  Future<dynamic> RequestPayments(
      context,
      Function(
        bool isSuccess,
        Map transactionDetails,
        String message,
      ) onSuccess,
      Function(
        bool isSuccess,
        Map transactionDetails,
        String message,
      ) onFailure,
      bool isApplePay) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ));
        });

    var paymentUrl;
    Map? values;
    try {
      var salt10 = await FlutterBcrypt.saltWithRounds(rounds: 10);

      var head = {"Content-Type": "application/json"};
      // encode Map to JSON
      // http.Response response = await http
      //     .post(Uri.parse('https://talat.dev.vrinsoft.in/paymenttest.php'));

      String? userId = await SharedPref.getString(PreferenceConstants.userId);
      String? userName = await SharedPref.getString(PreferenceConstants.name);
      String? email = await SharedPref.getString(PreferenceConstants.email);
      String? mobileNumber = await SharedPref.getString(PreferenceConstants.mobileKey);

      String _paymentMethod = isApplePay ? "apple-pay" : "knet";

      token = await SharedPref.getString(PreferenceConstants.token);
      values = {
        "user_type": "1",
        "device_token": token,
        "device_type": '1',
        "user_id": userId,
        "total_amount": controller.totalAmount.value,
        "currency_code": "kwd"
      };

      http.Response response = await http.post(Uri.parse('${ConstantStrings.baseUrl}pay-now'),
          headers: Map<String, String>.from({"username": "talat", "password": "Admin@123"}), body: values);

      debugPrint("response11 =======> ${response.body}");
      PayNowSuccessModel model = PayNowSuccessModel.fromJson(json.decode(response.body));
      paymentResponse = model;
      final jsonResponse = json.decode(response.body);
      print("test =======> $jsonResponse");
      if (model.result.paymentUrl != '') {
        paymentUrl = model.result.paymentUrl;
        Navigator.pop(context);
      } else {
        Map details = {};
        Fluttertoast.showToast(
                msg: "Something Went Wrong!\nTry Again Later",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0)
            .then((value) => OnFailure(false, details, 'error'));
        Navigator.pop(context);
        isButtonTaped(false);
        isButtonTaped.refresh();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong!\nTry Again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      isButtonTaped(false);
      isButtonTaped.refresh();
    }
    isButtonTaped(false);
    isButtonTaped.refresh();
    paymentUrl != null
        ? Get.toNamed(
            AppRouteNameConstant.paymentLinkScreen,
            arguments: {
              "data": values,
              "OnFailure": OnFailure,
              "OnSuccess": OnSuccess,
              "weblink": paymentUrl,
            },
          )
        : null;
  }

  void bottomPaymentSelectionOption(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Please select payment option'),
        message: const Text('You can checkout with Knet or Apple pay as you wish to'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              RequestPayments(context, OnSuccess, OnFailure, false);
            },
            child: const Text('Knet'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              RequestPayments(context, OnSuccess, OnFailure, true);
            },
            child: const Text('ApplePay'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
