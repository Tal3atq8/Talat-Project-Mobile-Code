import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/enums/enum.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/utility.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/common_widgets.dart';
import '../../widgets/common_text_style.dart';

class MoreAbout extends StatefulWidget {
  const MoreAbout({Key? key}) : super(key: key);

  @override
  State<MoreAbout> createState() => _MoreAboutState();
}

class _MoreAboutState extends State<MoreAbout> {
  List<SocialIconModel> socialIconList = [];

  @override
  void initState() {
    super.initState();
    socialIconList.add(SocialIconModel(
        iconPath: ImageConstant.instagramIcon, socialLink: generalSetting?.result?.first.instagramLink ?? ''));
    // socialIconList.add(SocialIconModel(
    //     iconPath: ImageConstant.faceBookIcon,
    //     socialLink: generalSetting?.result?.first.facebookLink ?? ''));
    // socialIconList.add(SocialIconModel(
    //     iconPath: ImageConstant.twitterIconNew,
    //     socialLink: generalSetting?.result?.first.twitterLink ?? ''));
    // socialIconList.add(SocialIconModel(
    //     iconPath: ImageConstant.youTubeIcon,
    //     socialLink: generalSetting?.result?.first.youtubeLink ?? ''));
    socialIconList.add(SocialIconModel(
        iconPath: ImageConstant.whatsAppIcon, socialLink: generalSetting?.result?.first.whatsappLink ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: CustomAppbarNoSearchBar(
        title: toLabelValue(ConstantsLabelKeys.aboutUsText).toString(),
      ),
      body: Column(
        children: [
          cmsItemListTile('aboutus', () {
            Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.aboutus);
          }),
          Divider(thickness: 1.5, height: 1, color: ColorConstant.lightGrayColor),
          cmsItemListTile('terms_conditions', () {
            Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.termsandcondition);
          }),
          Divider(thickness: 1.5, height: 1, color: ColorConstant.lightGrayColor),
          cmsItemListTile('privacy_poilicy', () {
            Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.privacypolicy);
          }),
          Divider(thickness: 1.5, height: 1, color: ColorConstant.lightGrayColor),
          cmsItemListTile('refund_policy', () {
            Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.refundpolicy);
          }),
          const Expanded(child: SizedBox(height: 10)),
          Text(
            toLabelValue(ConstantStrings.findSocialAccount),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: txtStyleTitleBoldBlack12(),
          ),
          SizedBox(
            height: Get.height * .07,
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: socialIconList.length,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return socialIconList[index].socialLink.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                            onTap: () {
                              Logger.handleUrlOpen(socialIconList[index].socialLink);
                            },
                            child: (socialIconList[index].iconPath == ImageConstant.twitterIconNew)
                                ? SvgPicture.asset(
                                    ImageConstant.twitterIconNew,
                                    width: 21,
                                    height: 23,
                                  )
                                : Image.asset(
                                    socialIconList[index].iconPath,
                                    height: 24,
                                    width: 24,
                                  )),
                      )
                    : const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  ListTile cmsItemListTile(String title, Function() onTap) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Text(
            toLabelValue(title).toString(),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.left,
            style: txtStyleNormalBlack14(),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15,
        color: ColorConstant.darkGrayColor,
      ),
    );
  }
}

class SocialIconModel {
  final String iconPath;
  final String socialLink;

  SocialIconModel({required this.iconPath, required this.socialLink});
}
