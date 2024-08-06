import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/main.dart';
import 'package:talat/src/models/banner_model.dart';
import 'package:talat/src/models/browse_model.dart';
import 'package:talat/src/models/popular_list_model.dart';
import 'package:talat/src/screens/dashboard/tabBar/tabbar_binding.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../theme/color_constants.dart';

class DashboardController extends GetxController {
  RxInt current = 0.obs;
  final CarouselController slideControllers = CarouselController();
  RxList<BrowseModel> browseItems = RxList<BrowseModel>();
  Rx<BannerModel> bannerItems = BannerModel().obs;
  RxBool showLoader = false.obs;
  RxBool showBrowseLoader = false.obs;
  RxBool showPopularItemsLoader = false.obs;
  RxBool favShowLoader = false.obs;
  RxInt initLimit = 5.obs;
  RxInt page = 1.obs;
  RxInt popularPage = 1.obs;
  RxInt popularLimit = 5.obs;
  RxInt selectedIndex = 0.obs;
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final RefreshController popularRefreshController = RefreshController(initialRefresh: false);
  final RefreshController seeAllBrowseRefreshController = RefreshController();

  //final bannerItems=  BannerModel().obs;
  final browseActivityItems = BrowseActivityListModel().obs;
  RxList<BrowseListData> browseListData = <BrowseListData>[].obs;
  RxList<BrowseListData> dashBoardBrowseListData = <BrowseListData>[].obs;
  Rx<PopularListModel> popularActivityItems = PopularListModel().obs;
  RxList<PopularList> popularActivityItemList = <PopularList>[].obs;
  RxList<String> popularActivityItemListFav = <String>[].obs;

  String? languageID;
  String? name;

  String? usertoken;
  String? userId;
  String? latitude;
  String? longtitude;

  @override
  void onInit() async {
    super.onInit();

    getData();

    userLatLong();
    getPopularActivityList();
    getBannerList();
    getBrowseActivityList();
  }

  /// Delete FavouriteItem api Calling
  void deleteFavouriteItem(String? activityId) async {
    favShowLoader.value = true;

    try {
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
          popularActivityItemListFav.removeWhere((element) => element == activityId);
          favShowLoader(false);

          // getPopularActivityList(isRefresh: true).then((value) =>
          CommonWidgets().showToastMessage("removed_from_favourite");
        } else if (response.data["code"] == "-1") {
          favShowLoader.value = false;
          // Get.back();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          TabbarBinding().dependencies();
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

        favShowLoader.value = false;
        Get.back();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Add FavouriteItem api Calling
  void addFavouriteItem(String? activityId) async {
    favShowLoader.value = true;

    try {
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
          // favShowLoader.value = false;
          for (var element in popularActivityItemList) {
            if (element.id == activityId) {
              popularActivityItemListFav.add(element.id);
              update();
              favShowLoader.value = false;
            }
          }
          // getPopularActivityList(isRefresh: true).then(
          CommonWidgets().showToastMessage("added_to_favorite");
        } else if (response.data["code"] == "-1") {
          favShowLoader.value = false;
          Get.back();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          TabbarBinding().dependencies();
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

        favShowLoader.value = false;
        Get.back();
      });
    } catch (e) {
      debugPrint(e.toString());

      favShowLoader.value = false;
      Get.back();
    }
  }

  /// Get BannerList api Calling
  void getBannerList() async {
    showLoader.value = true;
    try {
      await TalatService().bannerApi({ConstantStrings.languageId: languageID ?? "1"}).then((response) async {
        if (response.data['code'] == "1") {
          bannerItems.value = BannerModel.fromJson(response.data);
          update();

          // getPopularActivityList();
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
      }).catchError((error) {
        debugPrint(error.toString());
        showLoader.value = false;
      });
    } on DioError catch (e) {
      debugPrint("authenticateUser-error dio error >>>> ${e.toString()}");
      showLoader.value = false;
    }
    update();
  }

  /// Get BrowseActivityList api Calling
  void getBrowseActivityList({bool? isRefresh}) async {
    if (page.value == 1) {
      browseListData.value = [];
      dashBoardBrowseListData.value = [];
      browseActivityItems.value = BrowseActivityListModel();
    }
    if ((isRefresh == null || (!isRefresh))) {
      showBrowseLoader(true);
    }
    try {
      await TalatService().browseActivityApi({
        ConstantStrings.languageId: language ?? "1",
        ConstantStrings.userIdKey: userId,
        "limit": initLimit.value,
        "page": page.value,
      }).then((response) async {
        if (response.data['code'] == "1") {
          // if (isRefresh == null || (!isRefresh)) {
          //   showPopularItemsLoader.value = true;
          // }
          browseActivityItems.value = BrowseActivityListModel.fromJson(response.data);
          browseListData.addAll(browseActivityItems.value.result!.data!);
          if (page.value == 1 && initLimit.value == 5) {
            dashBoardBrowseListData.addAll(browseActivityItems.value.result!.data!);
          }
          update();
          showBrowseLoader(false);
          seeAllBrowseRefreshController.loadComplete();
          seeAllBrowseRefreshController.refreshCompleted();
          getPopularActivityList();
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
        showBrowseLoader(false);
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      showBrowseLoader(false);
    }
  }

  /// Get PopularActivityList api Calling
  Future<void> getPopularActivityList({bool? isRefresh}) async {
    // userLatLong();
    debugPrint(
        "userlat = ${userLat.value} ==========================  \nuserlong = ${userLong.value} ============================");
    if (isRefresh == null || (!isRefresh)) {
      showPopularItemsLoader.value = true;
    }
    try {
      await TalatService().popularActivityApi({
        ConstantStrings.languageId: languageID ?? "1",
        ConstantStrings.userIdKey: userId,
        ConstantStrings.longitudeKey: userLong.value != "" ? userLong.value : "0.0",
        ConstantStrings.latitudKey: userLat.value != "" ? userLat.value : "0.0",
        "limit": popularLimit.value,
        "page": popularPage.value
      }).then((response) async {
        if (response.data['code'] == "1") {
          popularActivityItems.value = PopularListModel.fromJson(response.data);
          favShowLoader.value = false;
          showPopularItemsLoader.value = false;
          update();
          if (popularActivityItems.value.result?.popularList != null &&
              popularActivityItems.value.result!.popularList!.isEmpty) {
            popularRefreshController.loadNoData();
          }
          if (popularPage.value == 1 && popularLimit.value == 5) {
            popularActivityItemList.clear();
            popularActivityItemListFav.clear();
            popularActivityItemList.addAll(popularActivityItems.value.result?.popularList ?? []);
          } else {
            popularActivityItemList.addAll(popularActivityItems.value.result?.popularList ?? []);
          }
          for (var element in popularActivityItemList) {
            if (element.isFav.toString() == '1' && !popularActivityItemListFav.contains(element.id)) {
              popularActivityItemListFav.add(element.id);
            }
          }
          debugPrint('$popularActivityItemListFav');
          popularRefreshController.refreshCompleted();
          popularRefreshController.loadComplete();
        } else if (response.data["code"] == "-7") {
          favShowLoader.value = false;
          // Get.back();
          CommonWidgets().showToastMessage('logout_successfully');
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
          showPopularItemsLoader(false);
          favShowLoader.value = false;
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
        showPopularItemsLoader.value = false;
        favShowLoader.value = false;
      });
    } on DioError catch (e) {
      showPopularItemsLoader.value = false;
      favShowLoader.value = false;

      debugPrint("authenticateUser-error dio error >>>> ${e.toString()}");
    }
  }

  getData() async {
    bannerItems.value = BannerModel();
    languageID = language ?? "1";
    // popularActivityItems.value = PopularListModel();

    browseActivityItems.value = BrowseActivityListModel();
    usertoken = await SharedPref.getString(PreferenceConstants.token);
    name = await SharedPref.getString(PreferenceConstants.name);
    userId = await SharedPref.getString(PreferenceConstants.userId);
  }
}

class CommonNoDataFound extends StatelessWidget {
  const CommonNoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: Get.height * 0.5,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            toLabelValue("no_data_available"),
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorConstant.blackColor, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }
}

class CommonProgressIndicator extends StatelessWidget {
  const CommonProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: ColorConstant.appThemeColor,
    ));
  }
}
