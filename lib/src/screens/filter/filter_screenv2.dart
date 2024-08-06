import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/activite/activity_list_binding.dart';
import 'package:talat/src/screens/activite/activity_list_controller.dart';
import 'package:talat/src/screens/filter/filter_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/preference/preference_keys.dart';
import 'package:talat/src/utils/preference/preferences.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_button_widget.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

class FilterV2 extends StatelessWidget {
  FilterV2({Key? key}) : super(key: key);
  final controller = Get.find<FilterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: CustomAppbarNoSearchBar(
          title: toLabelValue(ConstantStrings.sortText),
        ),
        bottomNavigationBar: Container(
          height: Get.height * 0.09,
          color: ColorConstant.whiteColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 42,
                width: Get.width * 0.4,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorConstant.whiteColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: ColorConstant.appThemeColor),
                          borderRadius: BorderRadius.circular(10.0)),
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 40, vertical: 16),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  onPressed: () async {
                    await SharedPref.removeSharedPref(PreferenceConstants.apply);
                    ActivityListBinding().dependencies();
                    controller.minControllers.clear();
                    controller.maxController.clear();
                    controller.distanceController.clear();
                    controller.clearText();
                    String? remove = "";
                    controller.selected.value = remove;
                    Get.find<ActivityListController>().filter.value = remove;
                    Get.find<ActivityListController>().update();
                    Get.find<ActivityListController>().fetchActivityItemList();

                    Get.back();
                    await SharedPref.setString(PreferenceConstants.apply, remove);
                  },
                  child: Text(
                    toLabelValue(ConstantStrings.clearText),
                    style: TextStyle(color: ColorConstant.appThemeColor, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(
                height: 42,
                width: Get.width * 0.4,
                child: ButtonWidget(
                    title: toLabelValue("apply_label"),
                    onPressed: () async {
                      checkFilterValidation();
                    },
                    btnColor: ColorConstant.appThemeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    txtColor: ColorConstant.whiteColor),
              )
            ],
          ),
        ),
        body: GetBuilder<FilterController>(
          builder: (controller) {
            return Container(
              decoration: const BoxDecoration(),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                /// Hide category list

                SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.options.length,
                        padding: const EdgeInsets.only(top: 18),
                        itemBuilder: (BuildContext context, int index) {
                          var items = controller.options[index];
                          return Obx(
                            () => RadioListTile(
                              dense: true,
                              title: Text(
                                items.title ?? "",
                                style: TextStyle(
                                    color: ColorConstant.blackColor, fontSize: 12, fontWeight: FontWeight.normal),
                              ),
                              value: items.id!,
                              activeColor: ColorConstant.appThemeColor,
                              groupValue: controller.selected.value,
                              onChanged: (String? value) {
                                controller.select(value!);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ]),
            );
          },
        ));
  }

  Widget categoryList() {
    return Container(
      height: Get.height,
      width: Get.width * 0.35,
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: controller.filterCategorylist.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                controller.selectedFilterIndex.value = index;
                controller.update();
              },
              child: Container(
                color: controller.selectedFilterIndex.value == index
                    ? ColorConstant.whiteColor
                    : ColorConstant.grayTextFormFieldColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Text(
                        controller.filterCategorylist[index],
                        style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }

  checkFilterValidation() async {
    String errorMsg = "";

    if (controller.maxController.value.text.isNotEmpty || controller.minControllers.value.text.isNotEmpty) {
      if (controller.minControllers.value.text.isNotEmpty && controller.maxController.value.text.isEmpty) {
        errorMsg = "maximun_price_cannot_empty";
      } else if (controller.maxController.value.text.isNotEmpty && controller.minControllers.value.text.isEmpty) {
        errorMsg = "minimum_price_cannot_empty";
      } else if (int.parse(controller.minControllers.value.text.toString()) >
          int.parse(controller.maxController.value.text.toString())) {
        errorMsg = "mini_price_greater_than_max_price";
      }
    }
    if (errorMsg != "") {
      CommonWidgets().customSnackBar("title", errorMsg);
    } else {
      await SharedPref.setString(PreferenceConstants.apply, controller.selected.value);
      ActivityListBinding().dependencies();
      Get.find<ActivityListController>().filter.value = controller.selected.value;
      Get.find<ActivityListController>().fetchActivityItemList();
      Get.find<ActivityListController>().showLoader(true);
      Get.find<ActivityListController>().update();

      Get.back();
    }
  }
}
