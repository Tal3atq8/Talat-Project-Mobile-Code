import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/auth/login/login_screen_controller.dart';
import 'package:talat/src/screens/auth/otp/otp_screen_controller.dart';
import 'package:talat/src/screens/auth/partner_registration/partner_registration_screen_binding.dart';
import 'package:talat/src/screens/auth/partner_registration/partner_registration_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';

import '../../utils/global_constants.dart';
import '../../widgets/common_text_style.dart';
import 'profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final serviceProviderController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    debugPrint('${serviceProviderController.showLoader.value}');

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        body: GetBuilder<ProfileController>(builder: (controller) {
          return controller.name?.isNotEmpty == true && controller.name != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.openDialog();
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                                  child: Directionality(
                                      textDirection:
                                          Get.locale == const Locale('ar', '') ? TextDirection.rtl : TextDirection.ltr,
                                      child: Image.asset(
                                        ImageConstant.logOutIcon,
                                        height: 24,
                                        width: 24,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          return Center(
                              child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                controller.viewProfile.value.result?[0].name ?? "",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold, color: ColorConstant.blackColor),
                              ),
                            ),
                          ));
                        }),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Center(
                              child: Text(
                            controller.viewProfile.value.result?[0].email ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: ColorConstant.darkGrayColor),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0, right: 38),
                          child: GestureDetector(
                            onTap: () {
                              PartnerRegistrationBinding().dependencies();
                              Get.find<PartnerRegistrationController>().clearFields();
                              Get.toNamed(AppRouteNameConstant.partnerRegistrationScreen);
                            },
                            child: Directionality(
                              textDirection:
                                  Get.locale == const Locale('ar', '') ? TextDirection.rtl : TextDirection.ltr,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(48)),
                                    color: Colors.red),
                                height: 56,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Image.asset(ImageConstant.becomePartnerIcon),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 6.0),
                                          child: Text(
                                            toLabelValue(ConstantsLabelKeys.beComePartner).toString(),
                                            style: TextStyle(color: ColorConstant.whiteColor, fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (userDetailModel.value.result?[0].providerRequestStatus != null &&
                                        userDetailModel.value.result?[0].providerRequestStatus != '' &&
                                        userDetailModel.value.result?[0].providerRequestStatus == '2')
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration:
                                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                        // child: Text(userDetailModel.value.result[0].),
                                        child: Text(
                                            (userDetailModel.value.result?[0].providerRequestStatus == '2' &&
                                                    userDetailModel.value.result?[0].providerRequestAccept.toString() ==
                                                        '0')
                                                ? toLabelValue('pending_approval')
                                                : '',
                                            style: TextStyle(fontSize: 12, color: ColorConstant.appThemeColor)),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListView.separated(
                          itemCount: controller.profileItemList.length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return profileItemWidget(controller.profileItemList[index]);
                          },
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 1.5, height: 1, color: ColorConstant.lightGrayColor);
                          },
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        toLabelValue(ConstantStrings.welcomeText),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: ColorConstant.blackColor),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Center(
                            child: Text(
                          toLabelValue(ConstantStrings.moreFeaturesText),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: ColorConstant.darkGrayColor),
                        )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          isNotLoggedIn.value = "0";
                          await SharedPref.clearSharedPref();

                          Get.delete<OtpController>();
                          Get.delete<LoginController>();

                          Get.toNamed(AppRouteNameConstant.loginScreen);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 28.0, right: 38),
                          child: Directionality(
                            textDirection: language == "2" ? TextDirection.rtl : TextDirection.ltr,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(48)),
                                  color: Colors.grey),
                              height: 54,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                                    child: Text(
                                      toLabelValue(ConstantStrings.quickText),
                                      style: TextStyle(color: ColorConstant.whiteColor, fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 28.0, left: 16),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                                      height: 20,
                                      width: 34,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: ColorConstant.lightGrayColor,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(thickness: 1.5, height: 1, color: ColorConstant.lightGrayColor);
                        },
                        itemCount: controller.guestProfileItemList.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return profileItemWidget(controller.guestProfileItemList[index]);
                        },
                      )
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Widget profileItemWidget(ProfileItemModel model) {
    return ListTile(
      onTap: model.onTap,
      leading: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: ImageIcon(
          AssetImage(model.icon ?? ''),
          color: ColorConstant.appThemeColor,
          size: 18,
        ),
      ),
      title: Row(
        children: [
          Text(
            toLabelValue(model.title ?? '').toString() ,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.left,
            style: txtStyleNormalBlack14(),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 100,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (model.subTitle != null)
              Text(
                toLabelValue(language == "1" ? "english" : "arabic").toString() ?? '',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.normal),
              ),
            const SizedBox(
              width: 4,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: ColorConstant.darkGrayColor,
            ),
          ],
        ),
      ),
    );
  }
}
