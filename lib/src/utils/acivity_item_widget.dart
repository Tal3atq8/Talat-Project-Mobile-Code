import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';

import '../theme/color_constants.dart';
import 'common_widgets.dart';

class ActivityItemWidget extends StatelessWidget {
  final Function()? onBannerTap;
  final Function()? onFavIconTap;
  final String? itemImageUrl;
  final String? serviceProviderImageUrl;
  final String? serviceProviderName;
  final String? serviceProviderAddress;
  final dynamic serviceProviderDistance;
  final bool isIconDisplay;
  final RxBool? favShowLoader;
  final bool isNotFav;
  final int isCurrentIndex;
  final RxInt? isSelectedIndex;
  final bool? fullWidth;

  const ActivityItemWidget(
      {super.key,
      required this.onBannerTap,
      this.fullWidth,
      this.itemImageUrl,
      required this.isIconDisplay,
      this.favShowLoader,
      required this.onFavIconTap,
      required this.isNotFav,
      this.serviceProviderImageUrl,
      this.serviceProviderName,
      this.serviceProviderDistance,
      this.serviceProviderAddress,
      required this.isCurrentIndex,
      this.isSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBannerTap,
      child: SizedBox(
        height: Get.height * 0.3,
        child: Card(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: (fullWidth != null && fullWidth!) ? Get.width * .9 : Get.width * .8,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 8,
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: itemImageUrl ?? '',
                        width: Get.width,
                        fit: BoxFit.fill,
                        fadeOutDuration: const Duration(seconds: 0),
                        fadeInDuration: const Duration(seconds: 0),
                        errorWidget: (context, url, error) {
                          return const PlaceholderImage();
                        },
                        placeholder: (context, url) {
                          return const PlaceholderImage();
                        },
                      ),
                    ),
                    if (isIconDisplay)
                      Align(
                        alignment: language == '1' ? Alignment.topRight : Alignment.topLeft,
                        child: Obx(() {
                          return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ((favShowLoader != null && favShowLoader!.value) &&
                                      ((isSelectedIndex != null) && isCurrentIndex == (isSelectedIndex!.value)))
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          right: language == '1' ? 16 : 0, left: language == '2' ? 16 : 0, top: 14),
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: ColorConstant.appThemeColor,
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: onFavIconTap != null
                                          ? () {
                                              Fluttertoast.cancel().then((value) => onFavIconTap!());
                                            }
                                          : null,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 8, left: language == '2' ? 16 : 0, right: language == '1' ? 16 : 0),
                                        color: Colors.transparent,
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: ColorConstant.grayBorderColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            color: isNotFav ? ColorConstant.whiteColor : ColorConstant.appThemeColor,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ));
                        }),
                      )
                  ]),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 4,
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Padding(
                        padding: EdgeInsets.only(left: 16, right: language == "1" ? 0 : 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: serviceProviderImageUrl ?? "",
                            fit: BoxFit.cover,
                            height: 52,
                            width: 52,
                            errorWidget: (context, url, error) {
                              return const PlaceholderImage();
                            },
                            placeholder: (context, url) {
                              return const PlaceholderImage();
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        serviceProviderName.toString() ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: ColorConstant.blackColor, fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                      subtitle: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: serviceProviderAddress,
                                style: txtStyleNormalGray12(color: ColorConstant.blackColor)),
                            TextSpan(
                              text: (serviceProviderDistance != null && serviceProviderDistance!.isNotEmpty)
                                  ? "\n$serviceProviderDistance ${toLabelValue("away")}"
                                  : '',
                              style: txtStyleNormalGray12(),
                            ),
                          ],
                        ),
                      ),
                      // trailing: Padding(
                      //   padding: EdgeInsets.only(
                      //       top: 10.0,
                      //       right: 16,
                      //       left: controller.languageID == "1" ? 0 : 16),
                      //   child: Column(
                      //     crossAxisAlignment: controller.languageID == "1"
                      //         ? CrossAxisAlignment.start
                      //         : CrossAxisAlignment.end,
                      //     children: [
                      //       Text(
                      //         toLabelValue("starting_from"),
                      //         style: TextStyle(
                      //             fontSize: 12.sp,
                      //             fontWeight: FontWeight.normal,
                      //             color: ColorConstant.grayLightListDataColor),
                      //       ),
                      //       const SizedBox(
                      //         height: 6,
                      //       ),
                      //       Text(
                      //         '${generalSetting?.result?.first.currency ?? ''} ${popularListData?.amount}.000',
                      //         style: TextStyle(
                      //             fontSize: 12,
                      //             fontWeight: FontWeight.bold,
                      //             color: ColorConstant.appThemeColor),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
