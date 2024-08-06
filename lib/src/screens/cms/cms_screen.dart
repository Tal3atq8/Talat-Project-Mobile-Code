import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/cms/cms_screen_controller.dart';
import 'package:talat/src/screens/seeAll_activity/see_popular_activities.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/utils/enums/enum.dart';
import 'package:talat/src/utils/utility.dart';

import '../../utils/common_widgets.dart';

class CmsScreen extends GetWidget<CmsController> {
  CmsScreen({Key? key}) : super(key: key);
  final serviceProviderController = Get.find<CmsController>();

  CmsType? cmsType;

  @override
  Widget build(BuildContext context) {
    cmsType = Get.arguments ?? '';
    return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: CustomAppbarNoSearchBar(
          title: cmsType == CmsType.aboutus
              ? toLabelValue("aboutus")
              : cmsType == CmsType.termsandcondition
                  ? toLabelValue("terms_conditions")
                  : cmsType == CmsType.refundpolicy
                      ? toLabelValue("refund_policy")
                      : toLabelValue("privacy_poilicy"),
        ),
        body: Obx(() => serviceProviderController.showLoader.value
            ? const CommonLoading()
            : (serviceProviderController
                            .cms
                            .value
                            .result![cmsType == CmsType.aboutus
                                ? 0
                                : cmsType == CmsType.termsandcondition
                                    ? 1
                                    : 2]
                            .cmsDescription !=
                        null &&
                    serviceProviderController
                        .cms
                        .value
                        .result![cmsType == CmsType.aboutus
                            ? 0
                            : cmsType == CmsType.termsandcondition
                                ? 1
                                : 2]
                        .cmsDescription!
                        .isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        Html(
                          data: serviceProviderController
                              .cms
                              .value
                              .result![cmsType == CmsType.aboutus
                                  ? 0
                                  : cmsType == CmsType.termsandcondition
                                      ? 1
                                      : cmsType == CmsType.privacypolicy
                                          ? 2
                                          : 3]
                              .cmsDescription,
                        ),
                      ],
                    ),
                  )
                : const SizedBox()));
  }
}
