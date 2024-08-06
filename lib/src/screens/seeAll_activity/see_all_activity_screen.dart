// import 'package:flutter/material.dart';
//
// import 'package:get/get.dart';
// import 'package:talat/src/app_routes/app_routes.dart';
// import 'package:talat/src/screens/activite/activity_list_binding.dart';
// import 'package:talat/src/screens/activite/activity_list_controller.dart';
// import 'package:talat/src/screens/seeAll_activity/see_all_activity_controller.dart';
// import 'package:talat/src/theme/image_constants.dart';
// import 'package:talat/src/utils/size_utils.dart';
//
// import '../../theme/color_constants.dart';
// import '../../theme/constant_strings.dart';
// import '../../utils/global_constants.dart';
// import '../../widgets/gray_custome_textform_filed.dart';
// import '../dashboard/dashboard_screen_controller.dart';
//
// class SeeAll extends StatelessWidget {
//   SeeAll({Key? key}) : super(key: key);
//   final controller = Get.find<SeeALLActivityController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ColorConstant.whiteColor,
//         appBar: AppBar(
//           toolbarHeight: 80,
//           elevation: 0,
//           leadingWidth: 34,
//           leading: InkWell(
//               onTap: () {
//                 Get.back();
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: ImageIcon(
//                   AssetImage(
//                     ImageConstant.backArrowIcon,
//                   ),
//                   size: 10,
//                   color: ColorConstant.appThemeColor,
//                 ),
//               )),
//           title: GrayCustomTextFormField(
//             width: double.infinity,
//             onTapEvent: () {
//               Get.toNamed(AppRouteNameConstant.searchScreen);
//             },
//             readOnly: true,
//             hintText: ConstantStrings.searchHintText,
//             textInputType: TextInputType.text,
//             prefix: Icon(
//               Icons.search,
//               size: 26,
//               color: ColorConstant.grayTextFormFieldTextColor,
//             ),
//             margin: getMargin(
//               top: 4,
//             ),
//           ),
//         ),
//         body: Obx(
//           () => (controller.showLoader.value)
//               ? Center(
//                   child: CircularProgressIndicator(
//                     color: ColorConstant.appThemeColor,
//                   ),
//                 )
//               : (controller.seeAllActivityDetailModel.value != null)
//                   ? ListView(
//                       physics: const ClampingScrollPhysics(),
//                       shrinkWrap: true,
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       // mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                           Padding(
//                             padding: const EdgeInsets.only(top: 22, left: 16),
//                             child: Text(
//                               ConstantStrings.activityProviderText,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 12.sp),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           SizedBox(
//                             height: 90.h,
//                             child: ListView.builder(
//                                 itemCount: controller.seeAllActivityDetailModel
//                                     .value.result?.providerData?.mydata?.length,
//                                 scrollDirection: Axis.horizontal,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, index) {
//                                   var browseItems = controller
//                                       .seeAllActivityDetailModel
//                                       .value
//                                       .result
//                                       ?.providerData
//                                       ?.mydata?[index];
//                                   return GestureDetector(
//                                     onTap: () {
//                                       providerID.value =
//                                           browseItems?.id.toString() ?? '';
//                                       Get.toNamed(AppRouteNameConstant
//                                           .activityDetailScreen);
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left: 16),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           (browseItems?.profileImage == "")
//                                               ? Image.asset(
//                                                   ImageConstant.desertImage,
//                                                   height: 50.h,
//                                                   width: 56.w,
//                                                 )
//                                               : ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(50),
//                                                   child: Image.network(
//                                                     browseItems?.profileImage ??
//                                                         "",
//                                                     height: 50.h,
//                                                     width: 56.w,
//                                                     fit: BoxFit.cover,
//                                                     errorBuilder: (context,
//                                                         error, stackTrace) {
//                                                       return Image.asset(
//                                                         ImageConstant
//                                                             .desertImage,
//                                                         height: 50.h,
//                                                         width: 56.w,
//                                                       );
//                                                     },
//                                                   ),
//                                                 ),
//                                           SizedBox(height: 8.h),
//                                           Text(
//                                             browseItems?.name ?? "",
//                                             style: TextStyle(
//                                                 fontSize: 12.sp,
//                                                 fontWeight: FontWeight.normal),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ),
//                           Divider(
//                             thickness: 8,
//                             color: ColorConstant.grayTextFormFieldColor,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 16.0, top: 20),
//                             child: Text(
//                               ConstantStrings.allPopularText,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.normal,
//                                   fontSize: 12.sp),
//                             ),
//                           ),
//                           GridView.builder(
//                             physics: const ClampingScrollPhysics(),
//                             shrinkWrap: true,
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               childAspectRatio: 2.8 / 3.6,
//                             ),
//                             itemCount: controller.seeAllActivityDetailModel
//                                 .value.result?.categoryData?.data?.length,
//                             itemBuilder: (BuildContext ctx, index) {
//                               var activityList = controller
//                                   .seeAllActivityDetailModel
//                                   .value
//                                   .result
//                                   ?.categoryData
//                                   ?.data?[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   ActivityListBinding().dependencies();
//                                   Get.find<ActivityListController>()
//                                       .showLoader
//                                       .value = true;
//                                   Get.find<ActivityListController>().id.value =
//                                       "0";
//                                   Get.find<ActivityListController>()
//                                       .activityName
//                                       .value = activityList!.name!;
//
//                                   Get.find<ActivityListController>()
//                                       .activityItemList();
//                                   Get.find<ActivityListController>().update();
//
//                                   Get.toNamed(
//                                       AppRouteNameConstant.activityListScreen);
//                                   // Get.toNamed(
//                                   //     AppRouteNameConstant.activityListScreen);
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 16.0, right: 16.0, top: 12),
//                                   child: Column(
//                                     children: [
//                                       Image.asset(
//                                         ImageConstant.foldableTentImage,
//                                         height: 90.h,
//                                         width: 103.w,
//                                       ),
//                                       Flexible(
//                                         child: Text(
//                                           activityList?.name ?? "asd",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 12.sp,
//                                               fontWeight: FontWeight.normal),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           Divider(
//                             thickness: 8,
//                             color: ColorConstant.grayTextFormFieldColor,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 18.0, top: 20),
//                             child: Text(
//                               "All Category Item",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 12.sp),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 14.0, top: 10, right: 12),
//                             child: Container(
//                               height: MediaQuery.of(context).size.height * 0.35,
//                               width: 420.w,
//                               child: ListView.builder(
//                                   itemCount: controller
//                                       .seeAllActivityDetailModel
//                                       .value
//                                       .result
//                                       ?.itemsData
//                                       ?.data
//                                       ?.length,
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index) {
//                                     var popularListData = controller
//                                         .seeAllActivityDetailModel
//                                         .value
//                                         .result
//                                         ?.itemsData
//                                         ?.data?[index];
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Get.toNamed(
//                                             AppRouteNameConstant
//                                                 .activityDetailScreen,
//                                             arguments:
//                                                 popularListData?.providerId);
//                                       },
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(2.0),
//                                         child: Card(
//                                           child: Container(
//                                             width: 300.w,
//                                             clipBehavior:
//                                                 Clip.antiAliasWithSaveLayer,
//                                             decoration: const BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.only(
//                                                 topLeft: Radius.circular(10.0),
//                                                 topRight: Radius.circular(10.0),
//                                                 bottomRight:
//                                                     Radius.circular(40.0),
//                                                 bottomLeft:
//                                                     Radius.circular(40.0),
//                                               ),
//                                             ),
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Stack(children: [
//                                                   // popularListData?.activityImage=="https://talat.dev.vrinsoft.in/uploads/activity/"?
//                                                   Image.asset(
//                                                     ImageConstant
//                                                         .dashboardSliderSecondImage,
//                                                     fit: BoxFit.cover,
//                                                     height: 156.h,
//                                                     width: 360,
//                                                     errorBuilder: (context,
//                                                         error, stackTrace) {
//                                                       return const SizedBox();
//                                                     },
//                                                   ),
//                                                   //     :  Image.network(
//                                                   //   popularListData?.activityImage ?? "",
//                                                   //   fit: BoxFit.cover,
//                                                   //   height: 156.h,
//                                                   //   width: 360,
//                                                   //
//                                                   //   errorBuilder: (context, error, stackTrace) {
//                                                   //     return SizedBox();
//                                                   //   },
//                                                   // ),
//                                                   // if (controller.name?.isNotEmpty==true&&controller.name!=null) Align(
//                                                   //   alignment: Alignment.topRight,
//                                                   //   child: Padding(
//                                                   //     padding:
//                                                   //     const EdgeInsets.only(top: 8.0),
//                                                   //     child: IconButton(
//                                                   //       onPressed: () {
//                                                   //         popularListData?.isFav==0? controller.addFavouriteItem(popularListData?.id.toString()):controller.deleteFavouriteItem(popularListData?.id.toString());
//                                                   //
//                                                   //         if (controller.showLoader.value == true)
//                                                   //           onNewLoading(context);
//                                                   //         // if (favoriteListData
//                                                   //         //         .isEnableItem!.value ==
//                                                   //         //     false) {
//                                                   //         //   //favoriteListData.isEnableItem!.value == true;
//                                                   //         //   controller.addItem(
//                                                   //         //       favoriteListData.id!);
//                                                   //         // } else {
//                                                   //         //   controller.removeItem(
//                                                   //         //       favoriteListData.id!);
//                                                   //         // }
//                                                   //       },
//                                                   //       icon: Icon(
//                                                   //         Icons.favorite,
//                                                   //         color: popularListData?.isFav==0?ColorConstant.grayBorderColor:ColorConstant.appThemeColor,
//                                                   //         // favoriteListData.isEnableItem!
//                                                   //         //             .value ==
//                                                   //         //         false
//                                                   //         //     ? Icons.favorite
//                                                   //         //     : Icons.favorite,
//                                                   //         // color: favoriteListData
//                                                   //         //             .isEnableItem!
//                                                   //         //             .value ==
//                                                   //         //         false
//                                                   //         //     ? ColorConstant
//                                                   //         //         .grayBorderColor
//                                                   //         //     : ColorConstant
//                                                   //         //         .appThemeColor
//                                                   //       ),
//                                                   //     ),
//                                                   //   ),
//                                                   // ) else Container(),
//                                                 ]),
//                                                 ListTile(
//                                                   leading: Transform.scale(
//                                                     scale: 1.1,
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 10.0),
//                                                       child: Image.asset(
//                                                         ImageConstant
//                                                             .browseImageOne,
//                                                         height: 52.h,
//                                                         width: 52.w,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   title: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 20.0),
//                                                     child: Row(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Text(
//                                                           popularListData
//                                                                   ?.providerName ??
//                                                               "",
//                                                           style: TextStyle(
//                                                               fontSize: 12.sp,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                         ),
//                                                         Text(
//                                                           'Starting From',
//                                                           style: TextStyle(
//                                                               fontSize: 14.sp,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal,
//                                                               color: ColorConstant
//                                                                   .grayLightListDataColor),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   subtitle: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 2.0),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           popularListData
//                                                                   ?.address ??
//                                                               "",
//                                                           style: TextStyle(
//                                                               color: ColorConstant
//                                                                   .blackColor,
//                                                               fontSize: 10.sp,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .normal),
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                       .only(
//                                                                   top: 2.0),
//                                                           child: Row(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             children: [
//                                                               Text(
//                                                                 '5.6 KM away',
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         10.sp,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .normal,
//                                                                     color: ColorConstant
//                                                                         .grayDarkDataColor),
//                                                               ),
//                                                               Text(
//                                                                 '${generalSetting!.result!.first.currency} ${popularListData?.initialPrice ?? ""}',
//                                                                 style: TextStyle(
//                                                                     fontSize:
//                                                                         13.sp,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                     color: ColorConstant
//                                                                         .appThemeColor),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                             ),
//                           ),
//                           const SizedBox(height: 40),
//                         ])
//                   : const CommonNoDataFound(),
//         ));
//   }
// }
