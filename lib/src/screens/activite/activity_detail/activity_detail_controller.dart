import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../../models/get_category_activity_detail_model.dart';
import '../../../utils/global_constants.dart';

class ActivityDetailController extends GetxController with GetTickerProviderStateMixin {
  TextEditingController instructionController = TextEditingController();
  List<GlobalKey> keyCategories = <GlobalKey>[];
  RxBool showLoader = false.obs;
  RxList<List<bool>>? isChecked = <List<bool>>[].obs;
  final ScrollController categoriesController = ScrollController();
  final ScrollController productsController = ScrollController();
  final Map<String, List<String>> categories = <String, List<String>>{};

  final scrollcontroller = ScrollController();

  int categoryIdx = 0;
  RxBool openBottomSheet = false.obs;
  RxBool isSelected = false.obs;
  RxBool isOpenBottomSheet = false.obs;
  RxBool isEnableItem = false.obs;
  RxString isSelectedId = "".obs;
  RxInt current = 0.obs;
  RxInt selectCategoryIndex = 0.obs;
  RxString selectItemIndex = "".obs;
  RxString selectItemIndexId = "".obs;
  String? token;
  String? name;
  String? userId;
  String? username;

  RxString providerId = "".obs;
  RxString providerName = "".obs;
  RxString providerNumber = "".obs;
  dynamic servicesProviderId = Get.arguments ?? 0;
  RxInt currentPage = 0.obs;
  RxString amount = "".obs;
  RxString categoryitemiddata = "".obs;
  RxString selectedname = "".obs;

  RxString itmeid = "".obs;

  Rx<GetCategoryActivityDetailsResponse> categoryActivityDetailModel = GetCategoryActivityDetailsResponse().obs;

  void toggleContainerVisibility() {
    isOpenBottomSheet.value = !isOpenBottomSheet.value;
  }

  final CarouselController slideControllers = CarouselController();

  final nightCampingCheckedItems = <String>[].obs;

  List<Widget> myTabs = [];
  List<Widget> myContainer = [];
  TabController? tabController;

  @override
  void onInit() async {
    super.onInit();

    token = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);

    username = await SharedPref.getString(PreferenceConstants.name);

    categoryActivityDetail();
    update();
  }

  void categoryActivityDetail() async {
    showLoader.value = true;
    await TalatService().categoryActivityDetailApi({
      "service_provider_id": providerID.value,
      "user_type": "1",
      "device_type": "1",
      "item_id": itemID.value,
      "language_id": language ?? "1",
    }).then((response) async {
      if (response.data['code'] == 200) {
        categoryActivityDetailModel.value = GetCategoryActivityDetailsResponse.fromJson(response.data);

        showLoader(false);
        update();
        print("My Tabs=>>>>>>>>>>>>${myTabs.length}");
      } else if (response.data["code"] == "-7") {
        CommonWidgets().showToastMessage('user_login_other_device');
        language = await SharedPref.getString(PreferenceConstants.laguagecode);
        showLoader(false);
        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        update();
      } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
        CommonWidgets().showToastMessage('inactive_account');
        language = await SharedPref.getString(PreferenceConstants.laguagecode);
        showLoader(false);
        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        update();
        showLoader(false);
      } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
        showLoader.value = false;
        CommonWidgets().showToastMessage(response.data["message"]);
        language = await SharedPref.getString(PreferenceConstants.laguagecode);

        await SharedPref.clearSharedPref();
        await SharedPref.setString(PreferenceConstants.laguagecode, language);
        Get.offAllNamed(AppRouteNameConstant.tabScreen);
        update();
      }
      if (response.data['message'] == "service_provider_not_found") {
        CommonWidgets().customSnackBar("Error", 'Service Provider not found');
      }
    }).catchError((error) {
      debugPrint(error.toString());
      showLoader.value = false;
    });
  }

  @override
  void onClose() {
    super.onClose();
    tabController?.dispose();
  }
}
