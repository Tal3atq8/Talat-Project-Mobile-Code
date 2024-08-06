// import 'dart:convert';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bcrypt/flutter_bcrypt.dart';
// import 'package:flutter_upayments/flutter_upayments.dart';
// import 'package:flutter_upayments/src/api_services/api_base_helper.dart';
// import 'package:flutter_upayments/src/api_services/app_const.dart';
// import 'package:flutter_upayments/src/u_data.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:talat/main.dart';
// import 'package:talat/src/theme/color_constants.dart';
// import 'package:talat/src/theme/constant_label.dart';
// import 'package:talat/src/theme/constant_strings.dart';
// import 'package:talat/src/theme/image_constants.dart';
// import 'package:talat/src/utils/common_widgets.dart';
// import 'package:talat/src/utils/global_constants.dart';
// import 'package:talat/src/utils/utility.dart';
// import 'package:talat/src/widgets/common_text_style.dart';
//
// import '../../app_routes/app_routes.dart';
// import '../../utils/enums/enum.dart';
// import '../../widgets/common_map_widget.dart';
// import 'booking_calendar_controller.dart';
//
// class BookingCheckoutScreen extends StatefulWidget {
//   const BookingCheckoutScreen({super.key});
//
//   @override
//   State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
// }
//
// class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
//   final dateInputFormat = DateFormat('d MMM yyyy hh:mm a');
//
//   final controller = Get.find<BookingCalendarController>();
//
//   bool webview = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         if (controller.showLoader.isTrue) {
//           return Future(() => false);
//         } else {
//           Get.back();
//           return Future(() => true);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: ColorConstant.whiteColor,
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(58),
//           child: CustomAppbarNoSearchBar(
//             title: toLabelValue(ConstantStrings.confirmBooking),
//             disableAutoBack: backgroundMessage != null,
//             onBackPressed: controller.showLoader.isTrue
//                 ? null
//                 : () {
//                     Get.back();
//                   },
//           ),
//         ),
//         body: Obx(() {
//           return controller.showLoader.isTrue
//               ? Center(
//                   child: CircularProgressIndicator(
//                   color: ColorConstant.appThemeColor,
//                 ))
//               : SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             top: 24.0, left: 18, right: 18),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '$serviceProviderName',
//                               style: txtStyleTitleBoldBlack18(),
//                             ),
//                             Text(
//                               activityDetailItem.value.initialPrice == 0
//                                   ? toLabelValue(ConstantsLabelKeys.label_free)
//                                   : '${generalSetting?.result?.first.currency ?? ''} ${activityDetailItem.value.discountedPrice == 0 ? '${(double.parse(activityDetailItem.value.initialPrice.toString()) * controller.diffrerence)}' : '${(double.parse(activityDetailItem.value.discountedPrice.toString()) * controller.diffrerence)}'}',
//                               style: txtStyleTitleBoldBlack18(),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(18.0),
//                         child: Row(
//                           children: [
//                             Text(
//                               '${toLabelValue("contact_label")} :',
//                               style: txtStyleTitleBoldBlack14(),
//                             ),
//                             Text(
//                               '  ${ConstantStrings.countryCodeKuwait} $serviceProviderNumber ',
//                               style: TextStyle(
//                                   color: ColorConstant.appThemeColor,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 12.0),
//                         child: Container(
//                           height: 130,
//                           width: double.infinity,
//                           color: const Color(0x00f21f0c).withOpacity(0.06),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 ImageConstant.bookingCalendarIcon,
//                                 height: 44,
//                                 width: 44,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 6.0),
//                                 child: Text(
//                                   toLabelValue(
//                                       ConstantsLabelKeys.your_booking_on),
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               ),
//                               // Time slot
//                               if (activityDetailItem.value.typeOfActivity ==
//                                   'Time')
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 6.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         ' ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse(controller.startDateStr))}',
//                                         style: TextStyle(
//                                             color: ColorConstant.blackColor,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       Text(
//                                         '${controller.getTimeSlotsResponseModel.value.result?[controller.selectedTimeSlot.value].timeSlot}',
//                                         style: TextStyle(
//                                             color: ColorConstant.blackColor,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               if (activityDetailItem.value.typeOfActivity ==
//                                   'Day')
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Text(
//                                     (selectedStartDate == selectedEndDate)
//                                         ? ' ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("$selectedStartDate"))}'
//                                         : ' From ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("$selectedStartDate"))} To ${DateFormat('d MMM yyyy').format(DateFormat("yyyy-MM-dd").parse("$selectedEndDate"))}',
//                                     style: TextStyle(
//                                         color: ColorConstant.blackColor,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 8.0, right: 8.0, top: 10),
//                         child: ListTile(
//                           leading: Transform.scale(
//                             scale: 1.4,
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0.0),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: SizedBox(
//                                   height: 45,
//                                   width: 45,
//                                   child: CachedNetworkImage(
//                                     imageUrl: activityDetailItem
//                                             .value.images?.first.imageUrl ??
//                                         '',
//                                     fit: BoxFit.fill,
//                                     errorWidget: (context, url, error) {
//                                       return const PlaceholderImage();
//                                     },
//                                     placeholder: (context, url) {
//                                       return const PlaceholderImage();
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           title: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   "${activityDetailItem.value.itemName}",
//                                   style: txtStyleTitleBoldBlack16(),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Text(
//                                 '${activityDetailItem.value.initialPrice == 0 ? '' : generalSetting?.result?.first.currency ?? ''} ${activityDetailItem.value.discountedPrice == 0 ? activityDetailItem.value.initialPrice == 0 ? toLabelValue(ConstantsLabelKeys.label_free) : (double.parse(activityDetailItem.value.initialPrice.toString()) * controller.diffrerence).toStringAsFixed(3) : (double.parse(activityDetailItem.value.discountedPrice.toString()) * controller.diffrerence).toStringAsFixed(3)}',
//                                 style: txtStyleTitleBoldBlack14(
//                                     color:
//                                         activityDetailItem.value.initialPrice ==
//                                                 0
//                                             ? ColorConstant.greenColor
//                                             : ColorConstant.appThemeColor),
//                               )
//                             ],
//                           ),
//                           subtitle: Padding(
//                             padding: const EdgeInsets.only(top: 0.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   width: Get.width * 0.48,
//                                   child: Text(
//                                     "${activityDetailItem.value.address}",
//                                     softWrap: true,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: txtStyleNormalGray14(),
//                                     maxLines: 3,
//                                   ),
//                                 ),
//                                 // Text(
//                                 //   DateTime.parse('$selectedStartDate')
//                                 //       .toLocal()
//                                 //       .timeAgo(numericDates: false),
//                                 //   style: TextStyle(
//                                 //       color: ColorConstant.darkGrayColor,
//                                 //       fontSize: 11,
//                                 //       fontWeight: FontWeight.normal),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 24,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(toLabelValue("special_instruction"),
//                                 style: txtStyleTitleBoldBlack16()),
//                             const SizedBox(height: 10),
//                             Text(
//                               "$specialInstruction",
//                               style: txtStyleNormalGray14(),
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(toLabelValue(ConstantStrings.no_of_people),
//                                 style: txtStyleTitleBoldBlack16()),
//                             const SizedBox(height: 10),
//                             Text(
//                               controller.selectedPeopleNumber.value.toString(),
//                               style: txtStyleNormalGray14(),
//                             )
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: Text(
//                           toLabelValue('sp_location'),
//                           style: TextStyle(
//                               color: ColorConstant.blackColor,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       CommonMapWidget(
//                         latitude: double.parse(
//                             "${activityDetailItem.value.latitude}"),
//                         longitude: double.parse(
//                             "${activityDetailItem.value.longitude}"),
//                         markers: {
//                           Marker(
//                             visible: true,
//                             markerId:
//                                 MarkerId("${activityDetailItem.value.itemId}"),
//                             position: LatLng(
//                                 double.parse(
//                                     "${activityDetailItem.value.latitude}"),
//                                 double.parse(
//                                     "${activityDetailItem.value.longitude}")),
//                             // infoWindow: InfoWindow(title: "${result?.providerName}"),
//                             icon: BitmapDescriptor.defaultMarker,
//                           )
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 16),
//                           padding: const EdgeInsets.all(18),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: ColorConstant.lightTextGrayColor
//                                   .withOpacity(.3)),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '${toLabelValue(ConstantsLabelKeys.note)}: ',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     color: ColorConstant.blackColor),
//                               ),
//                               SizedBox(
//                                 width: Get.width * .71,
//                                 child: InkWell(
//                                   onTap: () {
//                                     Get.toNamed(AppRouteNameConstant.cmsScreen,
//                                         arguments: CmsType.refundpolicy);
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 4.0),
//                                     child: Text(
//                                       toLabelValue(ConstantsLabelKeys
//                                           .refund_policy_note),
//                                       maxLines: 3,
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.normal,
//                                           color: ColorConstant.blackColor),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )),
//                       const SizedBox(height: 20),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: SizedBox(
//                           width: Get.width,
//                           // height: 42,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                                 elevation: 0,
//                                 backgroundColor: ColorConstant.whiteColor,
//                                 shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                         color: ColorConstant.appThemeColor),
//                                     borderRadius: BorderRadius.circular(10.0)),
//                                 textStyle: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.normal)),
//                             onPressed: () {
//                               if (activityDetailItem.value.initialPrice == 0) {
//                                 controller.bookingSucces();
//                               } else {
//                                 paymentDetails userData =
//                                     kentPaymentUserDetail()!;
//                                 try {
//                                   RequestPayments(
//                                       context, userData, OnSuccess, OnFailure);
//                                 } catch (e) {
//                                   debugPrint(e.toString());
//                                 }
//                               }
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               child: Text(
//                                 toLabelValue(ConstantsLabelKeys.label_pay_now),
//                                 style: TextStyle(
//                                     color: ColorConstant.appThemeColor,
//                                     fontWeight: FontWeight.w300),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 );
//         }),
//       ),
//     );
//   }
//
//   OnSuccess(isSuccess, data, message) {
//     setState(() {
//       // controller.transactionId = data["TranID"][0];
//       // controller.paymentResponse = date.toString();
//       controller.bookingSucces(
//         transactionId: data["TranID"][0],
//         paymentResponse: data.toString(),
//       );
//       webview = isSuccess;
//     });
//   }
//
//   OnFailure(isSuccess, TransactionDetails, message) {
//     setState(() {
//       webview = isSuccess;
//     });
//     Get.offAndToNamed(AppRouteNameConstant.paymentFailScreen);
//   }
//
//   paymentDetails? kentPaymentUserDetail() {
//     try {
//       paymentDetails userData = paymentDetails(
//         merchantId: "1201",
//         username: "test",
//         password: "test",
//         apiKey: "jtest123",
//         orderId: "12345",
//         totalPrice: activityDetailItem.value.discountedPrice == 0
//             ? '${(double.parse(activityDetailItem.value.initialPrice.toString()) * controller.diffrerence)}'
//             : '${(double.parse(activityDetailItem.value.discountedPrice.toString()) * controller.diffrerence)}',
//         currencyCode: "NA",
//         successUrl: "https://example.com/success.html",
//         errorUrl: "https://example.com/error.html",
//         testMode: "1",
//         customerFName: "test23",
//         customerEmail: "test23@gmail.com",
//         customerMobile: "12345678",
//         paymentGateway: "knet",
//         whitelabled: "true",
//         productTitle: "productTitle",
//         productName: "Food",
//         productPrice: "12",
//         productQty: "2",
//         reference: "Ref00001",
//         notifyURL: "https://example.com/success.html",
//       );
//       return userData;
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//
//   /// Payment pop
//   Future<dynamic> RequestPayments(
//     context,
//     paymentDetails data,
//     Function(
//       bool isSuccess,
//       Map transactionDetails,
//       String message,
//     ) onSuccess,
//     Function(
//       bool isSuccess,
//       Map transactionDetails,
//       String message,
//     ) onFailure,
//   ) async {
//     showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return WillPopScope(
//               onWillPop: () async {
//                 return false;
//               },
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.green,
//                 ),
//               ));
//         });
//     final ApiBaseHelper _helper = ApiBaseHelper();
//
//     var paymentUrl;
//
//     try {
//       var salt10 = await FlutterBcrypt.saltWithRounds(rounds: 10);
//       var encryptedSHA =
//           await FlutterBcrypt.hashPw(password: data.apiKey!, salt: salt10);
//
//       Map details = {
//         "merchant_id": data.merchantId,
//         "username": data.username,
//         "password": data.password,
//         "api_key": data.testMode == "0" ? encryptedSHA : data.apiKey,
//         "order_id": data.orderId,
//         "total_price": data.totalPrice,
//         "CurrencyCode": data.currencyCode,
//         "success_url": data.successUrl,
//         "error_url": data.errorUrl,
//         "test_mode": data.testMode,
//         "CstFName": data.customerFName,
//         "CstEmail": data.customerEmail,
//         "CstMobile": data.customerMobile,
//         "payment_gateway": data.paymentGateway,
//         "whitelabled": data.whitelabled,
//         "ProductTitle": data.productTitle,
//         "ProductName": data.productName,
//         "ProductPrice": data.productPrice,
//         "ProductQty": data.productQty,
//         "Reference": data.reference,
//         "notifyURL": data.notifyURL,
//       };
//
//       //var head = {"Content-Type": "application/json"};
//       //encode Map to JSON
//       var body = json.encode(details);
//
//       final response = await _helper.post(
//           data.testMode == "0"
//               ? AppConst.getProductionPaymentUrl
//               : AppConst.getTestPaymentUrl,
//           body);
//       if (response['status'] == 'success') {
//         paymentUrl = response['paymentURL'];
//         Navigator.pop(context);
//       } else {
//         Map details = {};
//         Fluttertoast.showToast(
//                 msg: "Something Went Wrong!\nTry Again Later",
//                 toastLength: Toast.LENGTH_LONG,
//                 gravity: ToastGravity.SNACKBAR,
//                 timeInSecForIosWeb: 1,
//                 backgroundColor: Colors.black,
//                 textColor: Colors.white,
//                 fontSize: 16.0)
//             .then((value) => OnFailure(false, details, 'error'));
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       Fluttertoast.showToast(
//           msg: "Something went wrong!\nTry Again",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.SNACKBAR,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       Navigator.pop(context);
//     }
//
//     paymentUrl != null
//         ? Get.toNamed(
//             AppRouteNameConstant.paymentLinkScreen,
//             arguments: {
//               "data": data,
//               "OnFailure": OnFailure,
//               "OnSuccess": OnSuccess,
//               "weblink": paymentUrl,
//             },
//           )
//         : null;
//   }
// }
