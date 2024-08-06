import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/service_provider/service_provider_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/utility.dart';

import '../../widgets/common_text_style.dart';

class ReviewListScreen extends StatelessWidget {
  ReviewListScreen({Key? key}) : super(key: key);
  final controller = Get.put(ServiceProviderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarNoSearchBar(title: toLabelValue("rating_review")),
        backgroundColor: ColorConstant.whiteColor,
        body: Obx(() => ListView.separated(
              itemCount:
                  controller.providerDetailModel.value.result?.review?.length ??
                      0,
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var reviewItems =
                    controller.providerDetailModel.value.result?.review?[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        // leading: Image.asset(
                        //     ImageConstant.userImage),

                        title: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            "${reviewItems?.customerName}" ?? "",
                            style: txtStyleTitleBoldBlack16(),
                          ),
                        ),
                        trailing: SizedBox(
                          width: Get.width * 0.35,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                if (reviewItems?.ratings != null &&
                                    reviewItems!.ratings.toString().isNotEmpty)
                                  Text(
                                    " ${double.parse(reviewItems.ratings.toString()).toStringAsFixed(1)}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: ColorConstant.blackColor,
                                        fontWeight: FontWeight.normal),
                                  ),
                                const SizedBox(width: 2),
                                RatingBar.builder(
                                  initialRating:
                                      reviewItems?.ratings?.toDouble() ?? 0.0,
                                  minRating: 1,
                                  ignoreGestures: true,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 18,
                                  itemPadding: EdgeInsets.zero,
                                  // itemCount: 2.,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    size: 1,
                                    color: ColorConstant.appThemeColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            // const SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                DateTime.parse(reviewItems?.createdAt ?? "")
                                    .timeAgo(numericDates: false),
                                style: txtStyleNormalBlack14(),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SizedBox(
                              width: Get.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  reviewItems?.review ?? "",
                                  style: txtStyleNormalBlack14(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(thickness: 2),
            )));
  }
}
