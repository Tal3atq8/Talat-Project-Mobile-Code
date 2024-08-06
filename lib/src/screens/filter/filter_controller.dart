import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:talat/src/models/filter_model.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';

class FilterController extends GetxController
    with GetSingleTickerProviderStateMixin {
  int currentIndex = 0;
  RxList<FilterListModel> filterOptions = RxList<FilterListModel>();

  RxInt selectedFilterIndex = 0.obs;
  RxString selectedCategoryOptionIndex = "0".obs;
  RxList selectedBrandIndexes = [].obs;
  TextEditingController minControllers = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController distanceController = TextEditingController();

  void clearText() {
    minControllers.clear();
    maxController.clear();
    distanceController.clear();
  }

  RxString selected =
      "".obs; // the selected option, initialized with an empty string
  List<String> filterCategorylist = [
    toLabelValue(ConstantStrings.sortText),
  ];

  void select(String option) {
    selected.value = option;
    update(); // update the selected option
  }

  @override
  void onInit() async {
    super.onInit();
    selected.value = await SharedPref.getString(PreferenceConstants.apply);
    // laguagecode;

    update();
  }

  RxInt selectedValue = 0.obs;

  List<FilterListModel> options = [
    FilterListModel(id: "1", title: toLabelValue("a_to_z")),
    FilterListModel(id: "2", title: toLabelValue("z_to_a")),
    // FilterListModel(id: "3", title: toLabelValue("price_low_to_high")),
    // FilterListModel(id: "4", title: toLabelValue("price_high_to_low")),
    FilterListModel(id: "5", title: toLabelValue("relevence")),
    FilterListModel(id: "6", title: toLabelValue("popular_label")),
    // FilterListModel(id: "7", title: toLabelValue("customer_ratings")),
    FilterListModel(id: "8", title: toLabelValue("distance_label")),
  ];

  void updateSelectedValue(int value) {
    selectedValue.value = value;
  }

  List<Widget> filterTab = [
    const Center(child: Text('Sort By')),
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  Widget get currentPage => filterTab[currentIndex];
}

class CustomRadio {
  final int id;
  final String text;

  CustomRadio({required this.id, required this.text});
}
