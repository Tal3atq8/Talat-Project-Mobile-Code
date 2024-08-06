import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/favorite_list_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

class FavoriteListController extends GetxController {
  Rx<FavoriteModel> favoriteItems = FavoriteModel().obs;
  RxList<FavouriteList> resultFavList = <FavouriteList>[].obs;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  RxBool myshowLoader = false.obs;
  RxBool favShowLoader = false.obs;
  String? token;
  String? userId;
  RxInt pageIndex = 1.obs;
  RxInt selectedIndex = 0.obs;
  RxInt limit = 10.obs;
  String? latitude;
  String? longtitude;

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
  }

  /// Get FavouriteList api Calling
  Future<void> getFavouriteList({bool? isRefresh}) async {
    if (pageIndex.value == 1) {
      if (isRefresh == null || (!isRefresh)) {
        myshowLoader.value = true;
      }
      // result.value = [];
    }
    if (userId != null && userId != "") {
      try {
        await TalatService().favoriteListApi({
          ConstantStrings.userTypeKey: '1',
          ConstantStrings.deviceTypeKey: '1',
          ConstantStrings.userIdKey: userId,
          ConstantStrings.deviceTokenKey: token,
          ConstantStrings.languageId: language ?? "1",
          ConstantStrings.longitudeKey: userLong.value != "" ? userLong.value : "0.0",
          ConstantStrings.latitudKey: userLat.value != "" ? userLat.value : "0.0",
          ConstantStrings.limitKey: limit.value,
          ConstantStrings.pageKey: pageIndex.value.toString()
        }).then((response) async {
          if (response.data['code'] == 200) {
            debugPrint("Favourite List Count == ${response.data["result"]}");

            favoriteItems.value = FavoriteModel.fromJson(response.data);
            resultFavList.value = [];
            resultFavList.addAll(favoriteItems.value.result!.data!);
            update();

            myshowLoader.value = false;
            favShowLoader.value = false;
          } else if (response.data["code"] == "-1") {
            myshowLoader.value = false;
            favShowLoader.value = false;
            Get.back();
          } else if (response.data["code"] == "-7") {
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
            update();
            myshowLoader.value = false;
            favShowLoader.value = false;
          } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
            CommonWidgets().showToastMessage(response.data["message"]);
            language = await SharedPref.getString(PreferenceConstants.laguagecode);

            await SharedPref.clearSharedPref();
            await SharedPref.setString(PreferenceConstants.laguagecode, language);
            Get.offAllNamed(AppRouteNameConstant.tabScreen);
            update();
          }
        }).catchError((error) {
          debugPrint(error.toString());
          myshowLoader.value = false;
          favShowLoader.value = false;
        });
      } on DioError catch (e) {
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      }
    }
    update();
  }

  /// Delete FavouriteItem api Calling
  void deleteFavouriteItem(String? activityId) async {
    favShowLoader.value = true;
    debugPrint("delete object ===");
    await TalatService().removeFavApi({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.userIdKey: userId,
      ConstantStrings.deviceTokenKey: token,
      ConstantStrings.languageId: language ?? "1",
      ConstantStrings.activityIdKey: activityId,
      ConstantStrings.isFavKey: 0,
    }).then((response) async {
      if (response.data['code'] == "1") {
        getFavouriteList(isRefresh: true).then((value) => CommonWidgets().showToastMessage("removed_from_favourite"));
      } else if (response.data["code"] == "-1") {
        myshowLoader.value = false;
        Get.back();
      } else if (response.data["code"] == "-7") {
        CommonWidgets().showToastMessage('user_login_other_device');
        language = await SharedPref.getString(PreferenceConstants.laguagecode);

        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        update();
      } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
        CommonWidgets().showToastMessage('inactive_account');
        language = await SharedPref.getString(PreferenceConstants.laguagecode);

        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        myshowLoader.value = false;
        update();
      } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
        CommonWidgets().showToastMessage(response.data["message"]);
        language = await SharedPref.getString(PreferenceConstants.laguagecode);

        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        update();
      }
    }).catchError((error) {
      debugPrint(error.toString());

      myshowLoader.value = false;
      Get.back();
    });
  }
}
