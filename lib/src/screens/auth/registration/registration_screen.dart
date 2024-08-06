import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:talat/src/screens/auth/registration/registration_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/custom_textform_field.dart';

import '../../../widgets/common_button_widget.dart';

class Registration extends StatelessWidget {
  Registration({super.key});

  DateTime? selectedDate;
  final controller = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ColorConstant.appThemeColor,
            automaticallyImplyLeading: false,
          ),
          backgroundColor: ColorConstant.appThemeColor,
          body: SingleChildScrollView(
            child: Obx(
              () => Form(
                key: controller.registrationFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(toLabelValue(ConstantStrings.identityText),
                          style: TextStyle(
                              color: ColorConstant.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: Text(
                            toLabelValue(
                                ConstantStrings.registrationSubTitleText),
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomTextFormField(
                          controller: controller.fullNameController,
                          inputFormatters: [
                            NoLeadingSpaceFormatter(),
                            FilteringTextInputFormatter.deny('  '),
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z ]")),
                            LengthLimitingTextInputFormatter(30)
                          ],
                          errorStyle:
                              TextStyle(color: ColorConstant.whiteColor),
                          width: double.infinity,
                          hintText: toLabelValue(ConstantStrings.fullNameText),
                          textInputType: TextInputType.text,
                          margin: getMargin(
                            top: 10,
                          ),
                          onChanged: (value) {
                            controller.registrationFormKey.currentState!
                                .validate();
                          },
                        ),
                      ),
                      CustomTextFormField(
                        controller: controller.emailController,
                        errorStyle: TextStyle(color: ColorConstant.whiteColor),
                        width: double.infinity,
                        hintText: toLabelValue(ConstantStrings.emailText),
                        textInputType: TextInputType.emailAddress,
                        margin: getMargin(
                          top: 10,
                        ),
                        onChanged: (value) {
                          controller.registrationFormKey.currentState!
                              .validate();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomTextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9@.]")),
                          ],
                          suffix: InkWell(
                            onTap: () {
                              controller.isShowPassword.value =
                                  !controller.isShowPassword.value;
                            },
                            child: Container(
                                margin: getMargin(
                                    left: 12, top: 12, right: 20, bottom: 12),
                                child: Icon(
                                  controller.isShowPassword.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: ColorConstant.appThemeColor,
                                )),
                          ),
                          isObscureText: !controller.isShowPassword.value,
                          controller: controller.passwordController,
                          maxLength: 8,
                          errorStyle:
                              TextStyle(color: ColorConstant.whiteColor),
                          width: double.infinity,
                          hintText: toLabelValue(ConstantStrings.passwordText),
                          onChanged: (value) {
                            controller.registrationFormKey.currentState!
                                .validate();
                          },
                          textInputType: TextInputType.visiblePassword,
                          margin: getMargin(
                            top: 10,
                          ),
                        ),
                      ),
                      CustomTextFormField(
                        width: double.infinity,
                        onTapEvent: () {
                          _showDatePicker(context);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z0-9@.]")),
                        ],
                        controller: controller.showDobController,
                        textInputType: TextInputType.none,
                        onChanged: (value) {
                          controller.registrationFormKey.currentState!
                              .validate();
                        },
                        errorStyle: TextStyle(color: ColorConstant.whiteColor),
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
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
                        hintText: toLabelValue(ConstantStrings.dateOfBirthText),
                        margin: getMargin(
                          top: 10,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, top: 40, right: 18),
                        child: Row(
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
                                          ImageConstant.selectedMaleIcon,
                                          height: 50,
                                          width: 50,
                                        )
                                      : Image.asset(
                                          ImageConstant
                                              .maleSignupUnselectedImage,
                                          height: 50,
                                          width: 50,
                                        ),
                                  const SizedBox(height: 10),
                                  Text(toLabelValue(ConstantStrings.maleText),
                                      style: TextStyle(
                                          color: controller.selected.value ==
                                                  'male'
                                              ? ColorConstant.whiteColor
                                              : ColorConstant.whiteColor,
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
                                              .femaleSignupSelectedImage,
                                          height: 50,
                                          width: 50,
                                        )
                                      : Image.asset(
                                          ImageConstant.unselectedFemaleIcon,
                                          height: 50,
                                          width: 50,
                                        ),
                                  const SizedBox(height: 10),
                                  Text(toLabelValue(ConstantStrings.femaleText),
                                      style: TextStyle(
                                          color: controller.selected.value ==
                                                  'female'
                                              ? ColorConstant.whiteColor
                                              : ColorConstant.whiteColor,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Obx(
                        () => controller.showLoader.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstant.whiteColor,
                                ),
                              )
                            : SizedBox(
                                width: Get.width,
                                height: 50,
                                child: ButtonWidget(
                                  fontSize: 14,
                                  onPressed: () {
                                    controller.signupApiCalling();
                                  },
                                  title: toLabelValue(
                                          ConstantsLabelKeys.signupText)
                                      .toString(),
                                  fontWeight: FontWeight.w300,
                                  btnColor: ColorConstant.whiteColor,
                                  txtColor: ColorConstant.appThemeColor,
                                ),
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
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
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue),
                      )),
                ),
              ),
              Container(
                height: 160,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  minimumDate: DateTime(1972, 1, 1),
                  // Set the minimum date
                  maximumDate: DateTime(DateTime.now().year - 18,
                      DateTime.now().month, DateTime.now().day),
                  dateOrder: DatePickerDateOrder.dmy,
                  initialDateTime: selectedDate ??
                      DateTime(DateTime.now().year - 18, DateTime.now().month,
                          DateTime.now().day),

                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDate = newDateTime;
                    print(DateFormat('yyyy-MM-dd').format(newDateTime));

                    controller.dobController.text =
                        DateFormat('yyyy-MM-dd').format(newDateTime);
                    controller.showDobController.text =
                        DateFormat('dd-MM-yyyy').format(newDateTime);
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
