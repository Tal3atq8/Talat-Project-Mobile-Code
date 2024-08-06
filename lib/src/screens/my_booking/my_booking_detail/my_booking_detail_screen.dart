// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
// import 'package:talat/src/screens/my_booking/my_booking_detail/my_booking_detail_controller.dart';
// import 'package:talat/src/theme/color_constants.dart';
// import 'package:talat/src/theme/constant_strings.dart';
// import 'package:talat/src/theme/image_constants.dart';
// import 'package:talat/src/utils/size_utils.dart';
// import 'package:talat/src/widgets/custom_textform_field.dart';

// class BookingDetail extends StatelessWidget {
//   BookingDetail({Key? key}) : super(key: key);
//   final Set<Marker> markers = new Set(); //markers for google map
//   final controller = Get.put(BookingDetailController());

//   //location to show in map
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstant.whiteColor,
//       appBar: AppBar(
//         toolbarHeight: 80,
//         elevation: 1,
//         leadingWidth: 50,
//         leading: InkWell(
//             onTap: () {
//               Get.back();
//             },
//             child: Icon(
//               Icons.arrow_back_ios,
//               color: ColorConstant.appThemeColor,
//               size: 20,
//               // weight: 50,
//             )),
//         centerTitle: true,
//         title: Text(
//           '#${controller.bookingDetailModel.value.result?.bookingDetail?.bookingId}',
//           style: TextStyle(
//               color: ColorConstant.blackColor,
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Obx(
//         () => Stack(
//           children: [
//             IgnorePointer(
//               ignoring: controller.showLoader.value ? true : false,
//               child: controller.bookingDetailModel.value.result == null
//                   ? controller.showLoader.value
//                       ? const SizedBox()
//                       : const CommonNoDataFound()
//                   : SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 18.0, left: 18, right: 18),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   controller.name ?? "",
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   'KD ${controller.bookingDetailModel.value.result?.itemDetail?.itemAmount}.00',
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(18.0),
//                             child: Row(
//                               children: [
//                                 Text(
//                                   ' ${ConstantStrings.contactText}  ',
//                                   style: TextStyle(
//                                       color: ColorConstant.grayBorderColor,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                                 Text(
//                                   '+965',
//                                   style: TextStyle(
//                                       color: ColorConstant.appThemeColor,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           controller.bookingDetailModel.value.result
//                                       ?.bookingDetail?.bookingType ==
//                                   "active booking"
//                               ? Container()
//                               : Padding(
//                                   padding: const EdgeInsets.only(top: 18.0),
//                                   child: Container(
//                                     height: 113.h,
//                                     width: double.infinity,
//                                     color:
//                                         const Color(0xF21F0C).withOpacity(0.06),
//                                     child: Column(
//                                       children: [
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 18.0),
//                                           child: Image.asset(
//                                             ImageConstant.bookingCalendarIcon,
//                                             height: 44.h,
//                                             width: 44.w,
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 8.0),
//                                           child: Text(
//                                             'Your booking on Sunday',
//                                             style: TextStyle(
//                                                 color: ColorConstant.blackColor,
//                                                 fontSize: 12.sp,
//                                                 fontWeight: FontWeight.normal),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 8.0),
//                                           child: Text(
//                                             'From 8 Oct 2022 To 14 Oct 2022',
//                                             style: TextStyle(
//                                                 color: ColorConstant.blackColor,
//                                                 fontSize: 12.sp,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 8.0, right: 8.0, top: 10),
//                             child: ListTile(
//                               leading: Transform.scale(
//                                 scale: 1.4,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 10.0),
//                                   child: Image.asset(
//                                     ImageConstant.browseImageOne,
//                                   ),
//                                 ),
//                               ),
//                               title: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     controller.bookingDetailModel.value.result
//                                             ?.itemDetail?.itemName ??
//                                         "",
//                                     style: TextStyle(
//                                         color: ColorConstant.blackColor,
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                   Text(
//                                     'KD ${controller.bookingDetailModel.value.result?.itemDetail?.itemAmount}.000',
//                                     style: TextStyle(
//                                         color: ColorConstant.appThemeColor,
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.normal),
//                                   )
//                                 ],
//                               ),
//                               subtitle: Padding(
//                                 padding: const EdgeInsets.only(top: 10.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Al khiran Al Ahmed Kuwait City…',
//                                       style: TextStyle(
//                                           color: ColorConstant.darkGrayColor,
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.normal),
//                                     ),
//                                     Text(
//                                       '7days',
//                                       style: TextStyle(
//                                           color: ColorConstant.darkGrayColor,
//                                           fontSize: 11.sp,
//                                           fontWeight: FontWeight.normal),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 18.0, right: 8.0, top: 40),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   ConstantStrings.specialInstructionText,
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: 20.h),
//                                 Text(
//                                   controller.bookingDetailModel.value.result
//                                           ?.customerInstructions ??
//                                       "",
//                                   style: TextStyle(
//                                       color: ColorConstant.grayBorderColor,
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 18.0, right: 8.0, top: 30),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   ConstantStrings.paymentMethodText,
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: 10.h),
//                                 Row(
//                                   children: [
//                                     Image.asset(
//                                       ImageConstant.cardImage,
//                                       height: 24.h,
//                                       width: 37.w,
//                                     ),
//                                     SizedBox(width: 10.w),
//                                     Text(
//                                       ConstantStrings.creditCardText,
//                                       style: TextStyle(
//                                           color: ColorConstant.grayBorderColor,
//                                           fontSize: 12.sp,
//                                           fontWeight: FontWeight.normal),
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 18.0, right: 8.0, top: 30),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   ConstantStrings.serviceProviderLocationText,
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 SizedBox(height: 10.h),
//                                 Text(
//                                   'Kuwait City, Block 2 Street 3 ...',
//                                   style: TextStyle(
//                                       color: ColorConstant.blackColor,
//                                       fontSize: 12.sp,
//                                       fontWeight: FontWeight.normal),
//                                 ),
//                                 SizedBox(height: 20.h),
//                               ],
//                             ),
//                           ),
//                           // Container(
//                           //   height: 141.h,
//                           //   width: double.infinity,
//                           //   child: GoogleMap(
//                           //     onMapCreated: _onMapCreated,
//                           //     markers: getmarkers(),
//                           //     zoomGesturesEnabled: true,
//                           //     mapType: MapType.terrain,
//                           //     //enable Zoom in, out on map
//                           //     initialCameraPosition:  CameraPosition(
//                           //       //innital position in map
//                           //       target:
//                           //         LatLng(double.parse(controller.bookingDetailModel.value.result.providerDetail.), 85.3086209), //initial position
//                           //       zoom: 15.0, //initial zoom level
//                           //     ),
//                           //   ),
//                           // ),
//                           SizedBox(height: 20.h),
//                           controller.bookingDetailModel.value.result
//                                       ?.bookingDetail?.bookingType ==
//                                   "active booking"
//                               ? Center(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(top: 28.0),
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           elevation: 0,
//                                           backgroundColor:
//                                               ColorConstant.whiteColor,
//                                           shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                   color: ColorConstant
//                                                       .appThemeColor),
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0)),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 110, vertical: 16),
//                                           textStyle: TextStyle(
//                                               fontSize: 16.sp,
//                                               fontWeight: FontWeight.bold)),
//                                       onPressed: () {
//                                         Get.bottomSheet(
//                                           Form(
//                                             key:
//                                                 controller.cancelBookingFormKey,
//                                             onChanged: () {
//                                               controller.isFormValid.value =
//                                                   controller
//                                                           .cancelBookingFormKey
//                                                           .currentState
//                                                           ?.validate() ??
//                                                       false;
//                                             },
//                                             child: Container(
//                                               height: 400.h,
//                                               decoration: const BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.only(
//                                                     topRight:
//                                                         Radius.circular(16),
//                                                     topLeft:
//                                                         Radius.circular(16),
//                                                   )),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(18.0),
//                                                 child: SingleChildScrollView(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       const SizedBox(height: 4),
//                                                       Center(
//                                                         child: Container(
//                                                           margin:
//                                                               const EdgeInsets
//                                                                       .symmetric(
//                                                                   horizontal:
//                                                                       2.0),
//                                                           height: 5.h,
//                                                           width: 80.w,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: ColorConstant
//                                                                 .lightGrayColor,
//                                                             borderRadius:
//                                                                 const BorderRadius
//                                                                         .all(
//                                                                     Radius
//                                                                         .circular(
//                                                                             50)),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       const SizedBox(height: 4),
//                                                       GestureDetector(
//                                                           onTap: () {
//                                                             Get.back();
//                                                           },
//                                                           child: const Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topRight,
//                                                               child: Icon(
//                                                                 Icons
//                                                                     .close_rounded,
//                                                                 size: 24,
//                                                               ))),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 4.0),
//                                                         child: Text(
//                                                           ConstantStrings
//                                                               .cancelBookingReasonText,
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               fontSize: 20.sp),
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 8.0),
//                                                         child: Text(
//                                                           ConstantStrings
//                                                               .cancelBookingChargesText,
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal,
//                                                               fontSize: 12.sp,
//                                                               color: ColorConstant
//                                                                   .grayBorderColor),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 20.h),
//                                                       const Divider(
//                                                         thickness: 1,
//                                                       ),
//                                                       Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   top: 18.0),
//                                                           child:
//                                                               GestureDetector(
//                                                             onTap: () {
//                                                               controller
//                                                                       .isButtonPressed
//                                                                       .value =
//                                                                   !controller
//                                                                       .isButtonPressed
//                                                                       .value;
//                                                             },
//                                                             child: Container(
//                                                               color: controller
//                                                                           .isButtonPressed
//                                                                           .value ==
//                                                                       false
//                                                                   ? ColorConstant
//                                                                       .whiteColor
//                                                                   : ColorConstant
//                                                                       .appThemeColor,
//                                                               child: Text(
//                                                                 ConstantStrings
//                                                                     .notAvailableBookingText,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       14.sp,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .normal,
//                                                                   color: controller
//                                                                               .isButtonPressed
//                                                                               .value ==
//                                                                           false
//                                                                       ? ColorConstant
//                                                                           .blackColor
//                                                                       : ColorConstant
//                                                                           .whiteColor,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           )),
//                                                       Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   top: 18.0),
//                                                           child:
//                                                               GestureDetector(
//                                                             onTap: () {
//                                                               controller
//                                                                       .isButtonPressed
//                                                                       .value =
//                                                                   !controller
//                                                                       .isButtonPressed
//                                                                       .value;
//                                                             },
//                                                             child: Container(
//                                                               color: controller
//                                                                           .isButtonPressed
//                                                                           .value ==
//                                                                       false
//                                                                   ? ColorConstant
//                                                                       .whiteColor
//                                                                   : ColorConstant
//                                                                       .appThemeColor,
//                                                               child: Text(
//                                                                 ConstantStrings
//                                                                     .vendorText,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       14.sp,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .normal,
//                                                                   color: controller
//                                                                               .isButtonPressed
//                                                                               .value ==
//                                                                           false
//                                                                       ? ColorConstant
//                                                                           .blackColor
//                                                                       : ColorConstant
//                                                                           .whiteColor,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           )),
//                                                       Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   top: 18.0),
//                                                           child:
//                                                               GestureDetector(
//                                                             onTap: () {
//                                                               controller
//                                                                       .isButtonPressed
//                                                                       .value =
//                                                                   !controller
//                                                                       .isButtonPressed
//                                                                       .value;
//                                                             },
//                                                             child: Container(
//                                                               color: controller
//                                                                           .isButtonPressed
//                                                                           .value ==
//                                                                       false
//                                                                   ? ColorConstant
//                                                                       .whiteColor
//                                                                   : ColorConstant
//                                                                       .appThemeColor,
//                                                               child: Text(
//                                                                 ConstantStrings
//                                                                     .serviceText,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       14.sp,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .normal,
//                                                                   color: controller
//                                                                               .isButtonPressed
//                                                                               .value ==
//                                                                           false
//                                                                       ? ColorConstant
//                                                                           .blackColor
//                                                                       : ColorConstant
//                                                                           .whiteColor,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           )),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(top: 10),
//                                                         child:
//                                                             CustomTextFormField(
//                                                           width:
//                                                               double.infinity,

//                                                           controller: controller
//                                                               .textEditingController,
//                                                           maxLines: 6,
//                                                           hintText:
//                                                               ConstantStrings
//                                                                   .reasonText,
//                                                           textInputType:
//                                                               TextInputType
//                                                                   .text,
//                                                           // onChanged: (value) {
//                                                           //   controller.isTextFieldNotEmpty.value = value.isNotEmpty;
//                                                           // },
//                                                           margin: getMargin(
//                                                             top: 10,
//                                                           ),

//                                                           validator: (value) {
//                                                             if (value!
//                                                                 .isEmpty) {
//                                                               return 'Please enter some text';
//                                                             }
//                                                             return null;
//                                                           },
//                                                         ),
//                                                       ),
//                                                       Center(
//                                                         child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     top: 28.0),
//                                                             child:
//                                                                 ElevatedButton(
//                                                               style: ElevatedButton.styleFrom(
//                                                                   backgroundColor: controller
//                                                                           .isTextFieldNotEmpty
//                                                                           .value
//                                                                       ? ColorConstant
//                                                                           .grayTextFormFieldTextColor
//                                                                       : ColorConstant
//                                                                           .appThemeColor,
//                                                                   shape: RoundedRectangleBorder(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               10.0)),
//                                                                   padding: const EdgeInsets
//                                                                           .symmetric(
//                                                                       horizontal:
//                                                                           110,
//                                                                       vertical:
//                                                                           16),
//                                                                   textStyle: TextStyle(
//                                                                       fontSize:
//                                                                           16.sp,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold)),
//                                                               onPressed: () {
//                                                                 //   Get.toNamed(AppRouteNameConstant.tabScreen);
//                                                               },
//                                                               child: Text(
//                                                                 ConstantStrings
//                                                                     .cancelBookingText,
//                                                                 style: const TextStyle(
//                                                                     color: Colors
//                                                                         .white,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600),
//                                                               ),
//                                                             )),
//                                                       ),
//                                                       const SizedBox(
//                                                           height: 10),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                         //   Get.toNamed(AppRouteNameConstant.tabScreen);
//                                       },
//                                       child: Text(
//                                         ConstantStrings.cancelBookingText,
//                                         style: TextStyle(
//                                             color: ColorConstant.appThemeColor,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : Container(),
//                           SizedBox(height: 20.h),
//                         ],
//                       ),
//                     ),
//             ),
//             if (controller.showLoader.value)
//               Center(
//                 child: CircularProgressIndicator(
//                   color: ColorConstant.appThemeColor,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   late GoogleMapController mapController;

//   final LatLng _center = const LatLng(45.521563, -122.677433);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
// }
