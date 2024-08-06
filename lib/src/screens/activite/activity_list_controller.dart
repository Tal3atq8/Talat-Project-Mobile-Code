import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/models/category_item_model.dart';
import 'package:talat/src/screens/filter/filter_controller.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';

class ActivityListController extends GetxController {
  Rx<CategoryItemModel> categoryItem = CategoryItemModel().obs;

  final filterController = Get.find<FilterController>();
  RxInt limit = 10.obs;
  RxString page = "1".obs;
  RxBool showLoader = true.obs;
  RxBool favLoader = false.obs;
  RxInt isSelected = 0.obs;
  String? token;
  String? userId;
  String? name;
  RxString filter = "".obs;
  RxBool myshowLoader = false.obs;
  RxBool isLoading = false.obs;

  final RefreshController activityRefreshController = RefreshController(initialRefresh: false);

  RxString id = "".obs;
  RxString activityName = "".obs;

  @override
  void onInit() async {
    super.onInit();
    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
    filter.value = await SharedPref.getString(PreferenceConstants.apply);
    id.value;

    name = await SharedPref.getString(PreferenceConstants.name);

    categoryItem.value = CategoryItemModel();
    fetchActivityItemList();
  }

  void addFavouriteItem(String? activityId) async {
    favLoader.value = true;

    await TalatService().removeFavApi({
      ConstantStrings.userTypeKey: '1',
      ConstantStrings.deviceTypeKey: '1',
      ConstantStrings.userIdKey: userId,
      ConstantStrings.deviceTokenKey: token,
      ConstantStrings.languageId: language ?? "1",
      ConstantStrings.activityIdKey: activityId,
      ConstantStrings.isFavKey: 1,
    }).then((response) async {
      if (response.data['code'] == "1") {
        fetchActivityItemList(isRefresh: true).then((value) => CommonWidgets().showToastMessage("added_to_favorite"));
        update();
      } else if (response.data["code"] == "-1") {}
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  /// Delete FavouriteItem api Calling
  void deleteFavouriteItem(String? activityId) async {
    favLoader.value = true;
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
        fetchActivityItemList(isRefresh: true)
            .then((value) => CommonWidgets().showToastMessage("removed_from_favourite"));
        update();
      } else if (response.data["code"] == "-1") {}
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  /// Activity list api calling
  Future<void> fetchActivityItemList({bool? isRefresh}) async {
    String errorMsg = "";
    if (isRefresh == null || (isRefresh != null && !isRefresh)) {
      myshowLoader.value = true;
    }
    try {
      await TalatService().categoryListApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.userIdKey: userId,
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.longitudeKey: userLong.value != "" ? userLong.value : "0.0",
        ConstantStrings.latitudKey: userLat.value != "" ? userLat.value : "0.0",
        ConstantStrings.categoryIdKey: activityID.value,
        ConstantStrings.limitKey: limit.value,
        ConstantStrings.filerKey: filter.value,
        "min_price": filterController.minControllers.value.text,
        "max_price": filterController.maxController.value.text,
        "distance": filterController.distanceController.value.text,
        "page": page.value,
      }).then((response) async {
        if (response.data['code'] == 200) {
          categoryItem.value = CategoryItemModel.fromJson(response.data);
          showLoader.value = false;
          favLoader.value = false;

          update();
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
          update();
          showLoader(false);
          favLoader.value = false;
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          showLoader.value = false;
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader.value = false;
        favLoader.value = false;
        CommonWidgets().showToastMessage('something_went_wrong');
        Get.back();
        myshowLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    activityRefreshController.refreshCompleted();
    myshowLoader.value = false;
  }
}
