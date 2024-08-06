import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talat/src/models/search_model.dart';
import 'package:talat/src/models/see_all_activity_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';

class SeeALLActivityController extends GetxController {
  Rx<SeeAllActivity> seeAllActivityDetailModel = SeeAllActivity().obs;
  Rx<SearchModel> searchListModel = SearchModel().obs;
  RxBool showLoader = false.obs;
  String? name;
  String? usertoken;
  String? userId;
  final textValue = RxString('');

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  final isTextEmpty = RxBool(true);

  void clearText() {
    searchController.clear();
    textValue.value = '';
  }

  @override
  void onInit() async {
    super.onInit();
    searchFocusNode.requestFocus();
    name = await SharedPref.getString(PreferenceConstants.name);
    usertoken = await SharedPref.getString(PreferenceConstants.token);
    name = await SharedPref.getString(PreferenceConstants.name);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    seeAllActivityDetailModel.value = SeeAllActivity();
    // seeAllActivityData();
  }

  ///See All Api calling
  void seeAllActivityData() async {
    showLoader.value = true;
    try {
      await TalatService().seeAllActivityApi({
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.limitKey: "10",
      }).then((response) async {
        if (response.data['code'] == 200) {
          seeAllActivityDetailModel.value = SeeAllActivity.fromJson(response.data);
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
        if (response.data['status'] == false) {
          showLoader.value = false;
          CommonWidgets().customSnackBar("Error", 'not found any activity');
        }
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showLoader.value = false;
    update();
  }

  ///search All Api calling
  void searchData(String value) async  {
    showLoader.value = true;
    try {
      await TalatService().searchApi({
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.searchTextKey: value,
      }).then((response) async {
        if (response.data['code'] == 200) {
          searchListModel.value = SearchModel.fromJson(response.data);
          showLoader.value = false;
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
        if (response.data['status'] == false) {
          showLoader.value = false;
          // CommonWidgets()
          //     .customSnackBar("Error", 'not found any activity');
        }
      }).catchError((error) {
        print(error);
        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showLoader.value = false;
    update();
  }

  ///Add Fav Api calling
  void addFavouriteItem(String? activityId) async {
    showLoader.value = true;

    await TalatService().removeFavApi({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.userIdKey: userId,
      ConstantStrings.deviceTokenKey: usertoken,
      ConstantStrings.languageId: language ?? "1",
      ConstantStrings.activityIdKey: activityId,
      ConstantStrings.isFavKey: 1,
    }).then((response) async {
      if (response.data['code'] == "1") {
        CommonWidgets().customSnackBar("Talat", "Product successfully add from favorite list.");
        seeAllActivityData();
        update();
      } else if (response.data["code"] == "-1") {
        showLoader.value = false;
        Get.back();
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

      showLoader.value = false;
      Get.back();
    });
  }

  /// Delete FavouriteItem api Calling
  void deleteFavouriteItem(String? activityId) async {
    showLoader.value = true;
    await TalatService().removeFavApi({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.userIdKey: userId,
      ConstantStrings.deviceTokenKey: usertoken,
      ConstantStrings.languageId: language ?? "1",
      ConstantStrings.activityIdKey: activityId,
      ConstantStrings.isFavKey: 0,
    }).then((response) async {
      if (response.data['code'] == "1") {
        CommonWidgets().customSnackBar("Talat", "Product successfully remove from favorite list.");
        seeAllActivityData();
        update();
      } else if (response.data["code"] == "-1") {
        showLoader.value = false;
        Get.back();
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
      //showLoader(false);
    });
    showLoader.value = false;
    Get.back();
  }
}
