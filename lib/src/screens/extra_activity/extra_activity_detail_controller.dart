import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/models/activity_detail_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../app_routes/app_routes.dart';
import '../../utils/global_constants.dart';

class ExtraActivityDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  TextEditingController inductionController = TextEditingController();

  RxBool showLoader = false.obs;
  RxList<bool>? isChecked = <bool>[].obs;
  RxBool openBottomSheet = false.obs;
  RxList<String> imageList = <String>[].obs;
  RxBool isselected = false.obs;
  RxBool isOpenBottomSheet = false.obs;
  RxBool isEnableItem = false.obs;
  RxInt current = 0.obs;
  RxString latitude = "".obs;
  RxString longitude = "".obs;
  RxString address = "".obs;
  RxString userName = "".obs;
  RxString userDes = "".obs;
  String? token;
  String? name;
  String? userId;

  RxInt providerId = 0.obs;
  dynamic servicesProviderId = Get.arguments ?? 0;
  RxInt currentPage = 0.obs;
  RxString amount = "".obs;
  RxString categoryitemiddata = "".obs;
  RxString selectedname = "".obs;
  RxString itmeid = "".obs;
  Rx<ActivityDetailModel> activityDetailModel = ActivityDetailModel().obs;
  void toggleContainerVisibility() {
    isOpenBottomSheet.value = !isOpenBottomSheet.value;
  }

  final CarouselController slideControllers = CarouselController();
  PageController? pageController;
  final nightCampingCheckedItems = <String>[].obs;
  RxList<Categories> categories = RxList<Categories>();

  List<Widget> myTabs = [];
  TabController? tabcontroller;
  final List<String> imgList = [
    ImageConstant.nightCampingImage,
    ImageConstant.userGuideSliderFirst,
    ImageConstant.userGuideSliderSecond,
    ImageConstant.nightCampingImage,
    ImageConstant.userGuideSliderFirst,
  ];

  handleTabSelection() {
    if (tabcontroller!.indexIsChanging) {
      update();
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
    tabcontroller?.addListener(handleTabSelection);
    activityDetailData();
    activityDetailModel.value = ActivityDetailModel();

    update();
  }

  ///Activity Detail Api calling
  void activityDetailData() async {
    showLoader.value = true;
    dynamic providerId = Get.arguments;
    try {
      await TalatService().activityDetailApi({
        ConstantStrings.providerKey: providerId,
        ConstantStrings.languageId: language ?? "1",
      }).then((response) async {
        if (response.data['code'] == 200) {
          activityDetailModel.value = ActivityDetailModel.fromJson(response.data);
          tabcontroller = TabController(vsync: this, length: activityDetailModel.value.result?.categories?.length ?? 0);

          myTabs = List.generate(
              activityDetailModel.value.result?.categories?.length ?? 0,
              (index) => Tab(
                    text: activityDetailModel.value.result?.categories?[index].name,
                  ));

          isChecked!.value =
              List.generate(activityDetailModel.value.result?.categories?.first.item?.length ?? 0, (index) => false);
          debugPrint("My Tabs=>>>>>>>>>>>>${myTabs.length}");
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
        if (response.data['message'] == "service_provider_not_found") {
          CommonWidgets().customSnackBar("Error", 'service provider not found');
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

  void bookingSucces(String ammount, String selectedUsername, String itmeid, String categoryitemid) async {
    showLoader.value = true;
    try {
      await TalatService().bookingConfirmApi({
        ConstantStrings.userTypeKey: '1',
        ConstantStrings.deviceTypeKey: '1',
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.deviceTokenKey: token,
        ConstantStrings.userIdKey: userId,
        ConstantStrings.bookingAmountKey: ammount,
        ConstantStrings.providerIdKey: providerId.value,
        ConstantStrings.mycategoryIdKey: itmeid,
        ConstantStrings.categoryitemid: itmeid,
        ConstantStrings.itemName: selectedUsername,
        ConstantStrings.bookingStartDate: "21-06-2023",
        ConstantStrings.bookingEndDate: "22-06-2023",
        ConstantStrings.bookingTimeKey: "10:00",
        ConstantStrings.instructionKey: inductionController.text ,
      }).then((response) async {
        if (response.data['code'] == 200) {
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
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
    showLoader.value = false;
    update();
  }
}
