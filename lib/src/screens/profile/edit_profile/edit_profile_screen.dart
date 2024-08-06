import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen_controller.dart';
import 'package:talat/src/screens/profile/edit_profile/edit_profile_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/common_widgets.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/utils/validations.dart';
import 'package:talat/src/widgets/common_button_widget.dart';
import 'package:talat/src/widgets/custom_textform_field.dart';

import '../../../widgets/common_text_style.dart';

const double spaceBetweenTextField = 14;

class EditProfile extends GetWidget<EditProfileController> {
  EditProfile({Key? key}) : super(key: key);
  DateTime? selectedDate;

  final serviceProviderController = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: CustomAppbarNoSearchBar(
          title: toLabelValue(ConstantsLabelKeys.myProfileText).toString(),
        ),
        body: GetBuilder<EditProfileController>(builder: (controller) {
          return Obx(() {
            return Stack(
              children: [
                IgnorePointer(
                    ignoring: controller.showLoader.value ? true : false,
                    child: controller.viewProfile != null
                        ? SingleChildScrollView(
                            child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    toLabelValue(
                                        ConstantStrings.accountInformationText),
                                    style: txtStyleTitleBoldBlack20w300(),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                CustomTextFormField(
                                  controller: controller.phoneNumberController,
                                  readOnly: true,
                                  readOnlyBgColor: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(9)
                                  ],
                                  prefix: SizedBox(
                                    width: Get.width * 0.3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: SvgPicture.asset(
                                                  "assets/icons/kuwait2.svg",
                                                  height: 26,
                                                  width: 20,
                                                  fit: BoxFit.cover),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Text(
                                              ConstantStrings.countryCodeKuwait,
                                              style: txtStyleNormalBlack14(),
                                            )
                                          ]),
                                    ),
                                  ),
                                  width: double.infinity,
                                  hintText: toLabelValue("mobile_number"),
                                  textInputType: TextInputType.number,
                                  margin: getMargin(
                                    top: 10,
                                  ),
                                ),
                                const SizedBox(height: spaceBetweenTextField),
                                CustomTextFormField(
                                  width: double.infinity,
                                  // focusNode: FocusNode(),
                                  hintText: toLabelValue("full_name"),
                                  controller: controller.fullNameController,
                                  textInputType: TextInputType.text,
                                  errorStyle: TextStyle(
                                      color: ColorConstant.appThemeColor),
                                  inputFormatters: [
                                    NoLeadingSpaceFormatter(),
                                    FilteringTextInputFormatter.deny('  '),
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z ]")),
                                    LengthLimitingTextInputFormatter(30)
                                  ],
                                  margin: getMargin(
                                    top: 10,
                                  ),
                                ),
                                const SizedBox(height: spaceBetweenTextField),
                                CustomTextFormField(
                                  width: double.infinity,
                                  // focusNode: FocusNode(),
                                  controller: controller.emailController,
                                  readOnly: true,
                                  readOnlyBgColor: true,
                                  hintText: toLabelValue("email_address"),
                                  validator: (value) {
                                    if (value == null ||
                                        (!isValidEmail(value,
                                            isRequired: true))) {
                                      return "Please enter valid email";
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.emailAddress,
                                  errorStyle: TextStyle(
                                      color: ColorConstant.appThemeColor),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[a-zA-Z0-9@.]")),
                                  ],
                                  margin: getMargin(
                                    top: 10,
                                  ),
                                ),
                                const SizedBox(height: spaceBetweenTextField),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 36),
                                  child: CustomTextFormField(
                                    width: double.infinity,
                                    onTapEvent: () {
                                      print("HJklsajdkajskjdk");
                                      _showDatePicker(context);
                                    },
                                    controller: controller.showDobController,
                                    textInputType: TextInputType.none,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z0-9@.]")),
                                    ],
                                    errorStyle: TextStyle(
                                        color: ColorConstant.appThemeColor),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Date Of Birth";
                                      }
                                      return null;
                                    },
                                    // focusNode: FocusNode(),
                                    suffix: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            _showDatePicker(context);
                                          },
                                          child: Image.asset(
                                            ImageConstant.calendarIcon,
                                            height: 2,
                                            width: 2,
                                          )),
                                    ),
                                    hintText: "",
                                    margin: getMargin(
                                      top: 10,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.select("male");
                                      },
                                      child: Column(
                                        children: [
                                          controller.selected.value == 'male'
                                              ? Image.asset(
                                                  ImageConstant
                                                      .editUserSelectedMaleIcon,
                                                  height: 50,
                                                  width: 50,
                                                )
                                              : Image.asset(
                                                  ImageConstant
                                                      .unselectedMaleEditProfileImage,
                                                  height: 50,
                                                  width: 50,
                                                ),
                                          const SizedBox(height: 10),
                                          Text(
                                              toLabelValue(
                                                  ConstantStrings.maleText),
                                              style: TextStyle(
                                                  color: controller
                                                              .selected.value ==
                                                          'male'
                                                      ? ColorConstant
                                                          .appThemeColor
                                                      : ColorConstant
                                                          .lightTextGrayColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    GestureDetector(
                                      onTap: () {
                                        controller.select("female");
                                      },
                                      child: Column(
                                        children: [
                                          controller.selected.value == 'female'
                                              ? Image.asset(
                                                  ImageConstant
                                                      .selectedFemaleEditProfileImage,
                                                  height: 50,
                                                  width: 50,
                                                )
                                              : Image.asset(
                                                  ImageConstant
                                                      .unselectedFemaleIcon,
                                                  height: 50,
                                                  width: 50,
                                                ),
                                          const SizedBox(height: 10),
                                          Text(
                                              toLabelValue(
                                                  ConstantStrings.femaleText),
                                              style: TextStyle(
                                                  color: controller
                                                              .selected.value ==
                                                          'female'
                                                      ? ColorConstant
                                                          .appThemeColor
                                                      : ColorConstant
                                                          .lightTextGrayColor,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: SizedBox(
                                      width: Get.width,
                                      height: 46,
                                      child: ButtonWidget(
                                        title: toLabelValue(
                                            ConstantStrings.updateAccount),
                                        onPressed: () {
                                          controller.update();
                                          controller.editProfile();
                                        },
                                        btnColor: ColorConstant.appThemeColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        txtColor: ColorConstant.whiteColor,
                                      )),
                                )),
                                const SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  height: 42,
                                  width: Get.width,
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color:
                                                  ColorConstant.appThemeColor),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8))),
                                      onPressed: () {
                                        controller.openDialog();
                                      },
                                      child: Text(
                                        toLabelValue("account_delete_button"),
                                        style: TextStyle(
                                            color: ColorConstant.appThemeColor),
                                      )),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ))
                        : controller.showLoader.value == false
                            ? const CommonNoDataFound()
                            : const SizedBox()),
                if (controller.showLoader.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.appThemeColor,
                    ),
                  ),
              ],
            );
          });
        }));
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 28.0, top: 28),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: ColorConstant.appThemeColor),
                      )),
                ),
              ),
              SizedBox(
                height: 160,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime(1972, 1, 1),
                  // Set the minimum date
                  maximumDate: DateTime(DateTime.now().year - 18,
                      DateTime.now().month, DateTime.now().day),
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: controller.userDateOFBirth ??
                      DateTime(DateTime.now().year - 18, DateTime.now().month,
                          DateTime.now().day),
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDate = newDateTime;
                    print(DateFormat('yyyy-MM-dd').format(newDateTime));

                    serviceProviderController.dobController.text =
                        DateFormat('yyyy-MM-dd').format(newDateTime);
                    serviceProviderController.showDobController.text =
                        DateFormat('dd-MM-yyyy').format(newDateTime);
                    //Get.back();

                    //controller.dobController.text = DateFormat.yMMMd().format(newDateTime);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
