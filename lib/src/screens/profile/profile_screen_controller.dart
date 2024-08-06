import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/user_deati_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../theme/constant_label.dart';
import '../../theme/image_constants.dart';
import '../dashboard/dashboard_screen_binding.dart';
import '../dashboard/tabBar/tabbar_binding.dart';
import 'edit_profile/edit_profile_screen_binding.dart';
import 'edit_profile/edit_profile_screen_controller.dart';

class ProfileController extends GetxController {
  RxBool showLoader = false.obs;

  String? token;
  String? userId;
  String? name;
  String? email;
  String? isLogin;
  String? userType;
  String? isMobileVerified;
  final viewProfile = UserDetailModel().obs;

  RxString selectedLanguage = "1".obs;
  String? password = "";

  RxList<ProfileItemModel> profileItemList = <ProfileItemModel>[].obs;
  List<ProfileItemModel> guestProfileItemList = <ProfileItemModel>[];

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    name = await SharedPref.getString(PreferenceConstants.name);
    email = await SharedPref.getString(PreferenceConstants.email);
    isLogin = await SharedPref.getString(PreferenceConstants.isRegister);
    userType = await SharedPref.getString(PreferenceConstants.userType);

    selectedLanguage.value = await SharedPref.getString(PreferenceConstants.laguagecode);
    isMobileVerified = await SharedPref.getString(PreferenceConstants.isMobileVerifiedKey);
    viewProfile.value = UserDetailModel();

    addProfileItems();

    update();
  }

  ///Log Out Api calling
  void onLogOutTap() async {
    showLoader.value = true;

    try {
      await TalatService().logOutApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.deviceTokenKey: token,
      }).then((response) async {
        debugPrint('$response');
        if (response.data["code"] == "1") {
          // CommonWidgets().showToastMessage('logout_successfully');
          userDetailModel.value = UserDetailModel();
          String languag1e = await SharedPref.getString(PreferenceConstants.laguagecode);
          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, languag1e);
          TabbarBinding().dependencies();
          DashboardBinding().dependencies();
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
        if (response.data["code"] == "-7") {
          Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');

          await SharedPref.clearSharedPref();
          language = await SharedPref.getString(PreferenceConstants.laguagecode);
          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          TabbarBinding().dependencies();
          DashboardBinding().dependencies();
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
        if (response.data["code"] == "-1") {
          showLoader.value = false;
          Get.back();
          CommonWidgets().customSnackBar("Error", "user not able to log out");

          update();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          showLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader(false);
      });
    } on dio.DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showLoader(false);
  }

  void openDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(ConstantStrings.talatTitle),
        content: Text(toLabelValue(ConstantStrings.msgLogout)),
        actions: [
          TextButton(
            child: Text(toLabelValue(ConstantStrings.no), style: TextStyle(color: ColorConstant.appThemeColor)),
            onPressed: () => Get.back(),
          ),
          TextButton(
              child: Text(toLabelValue(ConstantStrings.yes), style: TextStyle(color: ColorConstant.appThemeColor)),
              onPressed: () {
                Get.back();
                Future.delayed(const Duration(seconds: 2), () {
                  showLoader.value = true;
                  onLogOutTap();
                });
              }),
        ],
      ),
    );
  }

  ///View Profile Api calling
  viewProfileApi() async {
    try {
      await TalatService().viewProfileApi({
        ConstantStrings.userTypeKey: 1,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.passwordKey: password,
        ConstantStrings.userIdKey: userId,
      }).then((response) async {
        if (response.data["code"] == "1") {
          viewProfile.value = UserDetailModel.fromJson(response.data);
          userDetailModel.value = UserDetailModel.fromJson(response.data);
          name = response.data['result'][0]['name'];
          email = response.data['result'][0]['email'];
          update();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('logout_successfully');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1") {
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader(false);
      });
    } on dio.DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
  }

  ///open contact us bottom sheet
  void bottomSheetOpen() {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: Get.overlayContext!,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(
            toLabelValue("contact_us"),
            style: TextStyle(fontSize: 14, color: ColorConstant.blackColor),
          ),
          // message: const Text('Your options are '),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                toLabelValue("email"),
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Logger.handleLaunchEmail(generalSetting?.result?[0].contactUsEmail ?? "");
              },
            ),
            if (generalSetting?.result?[0].contactUsMobileNo != "" &&
                generalSetting?.result?[0].contactUsMobileNo != null)
              CupertinoActionSheetAction(
                child: Text(
                  toLabelValue("whatsapp"),
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Logger.handleUrlOpen("https://wa.me/${generalSetting?.result?[0].contactUsMobileNo}");
                },
              )
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Get.back();
            },
            child: Text(
              toLabelValue("cancel"),
            ),
          )),
    );
    // Get.bottomSheet(
    //   Container(
    //     // height: 280.h,
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.only(
    //           topRight: Radius.circular(16),
    //           topLeft: Radius.circular(16),
    //         )),
    //     child: Padding(
    //       padding: const EdgeInsets.all(18.0),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             SizedBox(height: 4),
    //             Center(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   toLabelValue("contact_us"),
    //                   style: TextStyle(
    //                       color: Colors.black, fontWeight: FontWeight.w600),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 4),
    //             Divider(),
    //             SizedBox(height: 4),
    //             GestureDetector(
    //               onTap: () {
    //                 Logger.handleLaunchEmail(ConstantStrings.contactusEmail);
    //               },
    //               child: Column(
    //                 children: [
    //                   Center(
    //                     child: Text(
    //                       toLabelValue("email"),
    //                       style: TextStyle(
    //                           color: Colors.blueAccent,
    //                           fontWeight: FontWeight.normal),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(height: 4),
    //             Divider(),
    //             SizedBox(height: 4),
    //             GestureDetector(
    //               onTap: () {
    //                 Logger.handleUrlOpen("whatsapp.com");
    //               },
    //               child: Column(
    //                 children: [
    //                   Center(
    //                     child: Text(
    //                       toLabelValue("whatsapp"),
    //                       style: TextStyle(
    //                           color: Colors.blueAccent,
    //                           fontWeight: FontWeight.normal),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Divider(),
    //             SizedBox(height: 2),
    //             Center(
    //               child: Padding(
    //                 padding: const EdgeInsets.only(top: 0.0),
    //                 child: ElevatedButton(
    //                   style: ElevatedButton.styleFrom(
    //                       backgroundColor: ColorConstant.whiteColor,
    //                       elevation: 0,
    //                       shape: RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(10.0)),
    //                       padding: EdgeInsets.symmetric(
    //                           horizontal: 110, vertical: 16),
    //                       textStyle: TextStyle(
    //                           fontSize: 16.sp, fontWeight: FontWeight.bold)),
    //                   onPressed: () {
    //                     Get.back();
    //                     //   Get.toNamed(AppRouteNameConstant.tabScreen);
    //                   },
    //                   child: Text(
    //                     toLabelValue("cancel"),
    //                     style: TextStyle(
    //                         fontSize: 14,
    //                         color: Colors.blue,
    //                         fontWeight: FontWeight.w600),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  void addProfileItems() {
    guestProfileItemList.clear();
    profileItemList.clear();
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.userIcon,
        title: (ConstantsLabelKeys.myProfileText),
        onTap: () {
          EditProfileBinding().dependencies();
          Get.find<EditProfileController>().viewProfileApi();
          Get.toNamed(AppRouteNameConstant.editProfileScreen);
        }));
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.myBookingIcon,
        title: (ConstantsLabelKeys.myBookingText),
        onTap: () {
          isFromCalendar.value = "0";
          Get.toNamed(AppRouteNameConstant.myBookingScreen);
        }));
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.notificationOutLineIcon,
        title: (ConstantsLabelKeys.notificationSettingText),
        onTap: () {
          Get.toNamed(AppRouteNameConstant.notificationSettingScreen);
        }));
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.changeLanguageTextIcon,
        title: (ConstantsLabelKeys.changeLanguageText),
        onTap: () {
          Get.toNamed(AppRouteNameConstant.changeLanguageScreen)!.then((value) async {
            selectedLanguage.value = await SharedPref.getString(PreferenceConstants.laguagecode);
            update();
            // onInit();
          });
        },
        subTitle: (selectedLanguage.value == "1") ? ("english") : "arabic"));
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.keyIcon,
        title: ConstantsLabelKeys.changePasswordText,
        onTap: () {
          Get.toNamed(AppRouteNameConstant.changePasswordScreen);
        }));
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.phoneIcon,
        title: ConstantsLabelKeys.contactUsText,
        onTap: () {
          bottomSheetOpen();
        }));
    profileItemList.add(ProfileItemModel(
        icon: ImageConstant.aboutUsIcon,
        title: ConstantsLabelKeys.aboutUsText,
        onTap: () {
          Get.toNamed(AppRouteNameConstant.moreAboutScreen);
        }));

    guestProfileItemList.add(ProfileItemModel(
      icon: ImageConstant.changeLanguageTextIcon,
      title: (ConstantsLabelKeys.changeLanguageText),
      onTap: () {
        Get.toNamed(AppRouteNameConstant.changeLanguageScreen);
      },
      subTitle: (language == "1") ? ("english") : ("arabic"),
    ));
    guestProfileItemList.add(ProfileItemModel(
        icon: ImageConstant.phoneIcon,
        title: "contact_us",
        onTap: () {
          bottomSheetOpen();
        }));
    guestProfileItemList.add(ProfileItemModel(
        icon: ImageConstant.aboutUsIcon,
        title: "about_us",
        onTap: () {
          Get.toNamed(AppRouteNameConstant.moreAboutScreen);
        }));
  }
}

class ProfileItemModel {
  final String? icon;
  final String? title;
  final String? subTitle;
  final Function()? onTap;

  ProfileItemModel({required this.icon, required this.title, required this.onTap, this.subTitle});
}
