import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:talat/src/screens/extra_activity/extra_activity_detail_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_map_widget.dart';

import '../../utils/common_widgets.dart';
import '../../utils/global_constants.dart';
import '../../widgets/common_text_style.dart';
import '../activite/activity_detail/activity_detail_screen.dart';

class ExtraActivity extends StatelessWidget {
  late GoogleMapController mapController;

  final controller = Get.find<ExtraActivityDetailController>();

  ExtraActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    (extraAdvertisementData.value.advertisementImage == null &&
                            extraAdvertisementData.value.advertisementImage!.isEmpty)
                        ? CachedNetworkImage(
                            height: 460,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            imageUrl: extraAdvertisementData.value.bannerImage ?? '',
                            errorWidget: (context, url, error) {
                              return const PlaceholderImage();
                            },
                            placeholder: (context, url) {
                              return const PlaceholderImage();
                            },
                          )
                        : CarouselSlider(
                            items: extraAdvertisementData.value.advertisementImage
                                ?.map((imageUrl) => ClipRRect(
                                        child: Stack(
                                      children: <Widget>[
                                        CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          height: 460,
                                          // height: Get.height * 0.42,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) {
                                            return const PlaceholderImage();
                                          },
                                          placeholder: (context, url) {
                                            return const PlaceholderImage();
                                          },
                                        )
                                      ],
                                    )))
                                .toList(),
                            carouselController: controller.slideControllers,
                            options: CarouselOptions(
                                viewportFraction: 1.0,
                                autoPlay: false,
                                // height: 400,
                                enlargeCenterPage: false,
                                aspectRatio: 1.0,
                                enableInfiniteScroll:
                                    extraAdvertisementData.value.advertisementImage!.isEmpty ? true : false,
                                onPageChanged: (index, reason) {
                                  controller.current.value = index;
                                }),
                          ),
                    Positioned(
                      top: 46.0,
                      left: 16.0,
                      // right: 300.0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.appThemeColor),
                          color: Colors.white, // border color

                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          // or ClipRRect if you need to clip the content
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,

                            /// inner circle color
                          ),
                          child: Center(
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: ImageIcon(
                                  AssetImage(
                                    ImageConstant.backArrowIcon,
                                  ),
                                  size: 28,
                                  color: ColorConstant.appThemeColor,
                                )),
                          ), // inner content
                        ),
                      ),
                    ),
                    if (extraAdvertisementData.value.advertisementImage!.length > 1)
                      Positioned(
                        // top: 0.0,
                        bottom: 40.0,
                        left: 0.0,
                        right: 0.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: extraAdvertisementData.value.advertisementImage!.asMap().entries.map((entry) {
                            return Obx(() {
                              return GestureDetector(
                                onTap: () => controller.slideControllers.animateToPage(entry.key),
                                child: Container(
                                    width: 12,
                                    height: 12,
                                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: controller.current == entry.key
                                            ? ColorConstant.appThemeColor
                                            : ColorConstant.lightGrayColor)),
                              );
                            });
                          }).toList(),
                        ),
                      )
                  ],
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      extraAdvertisementData.value.extraItemName ?? "",
                      style: txtStyleTitleBoldBlack20(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          toLabelValue("description"),
                          style: txtStyleTitleBoldBlack18(),
                        ),
                      ),
                      const SizedBox(
                        height: descriptionSpacing,
                      ),
                      Text(
                        extraAdvertisementData.value.description ?? "",
                        style: txtStyleNormalGray14(),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.address.value,
                            style: TextStyle(
                                color: ColorConstant.grayLightListDataColor,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toLabelValue("address"),
                        style: txtStyleTitleBoldBlack20(),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        extraAdvertisementData.value.address ?? "",
                        style: txtStyleNormalGray14(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                CommonMapWidget(
                  latitude: double.parse(extraAdvertisementData.value.latitude.toString()),
                  longitude: double.parse(extraAdvertisementData.value.longitude.toString()),
                  markers: {
                    Marker(
                      visible: true,
                      markerId: MarkerId("${extraAdvertisementData.value.itemId}"),
                      position: LatLng(double.parse(extraAdvertisementData.value.latitude.toString()),
                          double.parse(extraAdvertisementData.value.longitude.toString())),
                      // infoWindow: InfoWindow(title: "${result?.providerName}"),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                ),
              ],
            ),
          )),
    );
  }
}
