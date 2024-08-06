import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talat/src/screens/change_password_screen/change_password_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/custom_textform_field.dart';
import 'package:talat/src/widgets/progress_dialog.dart';

import '../../utils/common_widgets.dart';
import '../../widgets/common_text_style.dart';

class ChangePassword extends StatelessWidget {
  String? confirmPass;
  String? newPassword;

  ChangePassword({Key? key}) : super(key: key);
  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldNavigate = true;

        if (shouldNavigate) {
          Get.back();

          return true;
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: CustomAppbarNoSearchBar(
          title: toLabelValue(ConstantsLabelKeys.changePasswordText).toString(),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16),
                  child: Text(
                    toLabelValue(ConstantsLabelKeys.setAccountPassword).toString(),
                    style: txtStyleTitleBoldBlack20w300(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 20, right: 16),
                  child: CustomTextFormField(
                    // readOnly: false,
                    controller: controller.passwordController,
                    width: double.infinity,
                    hintText: toLabelValue(ConstantsLabelKeys.currentPassword).toString(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@]")),
                    ],
                    onChanged: (value) {},
                    suffix: InkWell(
                      onTap: () {
                        controller.isShowPassword.value = !controller.isShowPassword.value;
                      },
                      child: Container(
                          margin: getMargin(left: 12, top: 12, right: 20, bottom: 12),
                          child: Icon(
                            controller.isShowPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: ColorConstant.appThemeColor,
                          )),
                    ),
                    isObscureText: !controller.isShowPassword.value,
                    textInputType: TextInputType.visiblePassword,
                    margin: getMargin(
                      top: 10,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
                  child: CustomTextFormField(
                    readOnly: false,
                    width: double.infinity,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@]")),
                    ],
                    suffix: InkWell(
                      onTap: () {
                        controller.isNewShowPassword.value = !controller.isNewShowPassword.value;
                      },
                      child: Container(
                          margin: getMargin(left: 12, top: 12, right: 16, bottom: 12),
                          child: Icon(
                            controller.isNewShowPassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: ColorConstant.appThemeColor,
                          )),
                    ),
                    isObscureText: !controller.isNewShowPassword.value,
                    onChanged: (value) {},
                    controller: controller.newPasswordController,
                    hintText: toLabelValue(ConstantsLabelKeys.newPassword).toString(),
                    textInputType: TextInputType.visiblePassword,
                    margin: getMargin(
                      top: 10,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
                  child: CustomTextFormField(
                    width: double.infinity,
                    suffix: InkWell(
                      onTap: () {
                        controller.isConfirmShowPassword.value = !controller.isConfirmShowPassword.value;
                      },
                      child: Container(
                          margin: getMargin(left: 12, top: 12, right: 16, bottom: 12),
                          child: Icon(
                            controller.isConfirmShowPassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: ColorConstant.appThemeColor,
                          )),
                    ),
                    isObscureText: !controller.isConfirmShowPassword.value,
                    onChanged: (value) {},
                    readOnly: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@]")),
                    ],
                    controller: controller.confirmPasswordController,
                    hintText: toLabelValue(ConstantsLabelKeys.confirmPassword).toString(),
                    textInputType: TextInputType.visiblePassword,
                    margin: getMargin(
                      top: 10,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 28.0, left: 18, right: 18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstant.appThemeColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            //padding: EdgeInsets.symmetric(horizontal: 110, vertical: 16),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          if (controller.passwordController.text == "") {
                            CommonWidgets().customSnackBar("", 'please_enter_currentpass');
                          } else if (controller.passwordController.text.characters.length < 8) {
                            CommonWidgets().customSnackBar("", 'passwor_must_be_more_than_8_characters');
                          } else if (controller.newPasswordController.text == "") {
                            CommonWidgets().customSnackBar("", 'please_enter_new_pass');
                          } else if (controller.newPasswordController.text.characters.length < 8) {
                            CommonWidgets().customSnackBar("", 'passwor_must_be_more_than_8_characters');
                          } else if (controller.newPasswordController.text == controller.passwordController.text) {
                            CommonWidgets().customSnackBar("", 'pass_should_not_same');
                          } else if (controller.confirmPasswordController.text == "") {
                            CommonWidgets().customSnackBar("", 'enter_confirm_pass');
                          } else if (controller.confirmPasswordController.text.characters.length < 8) {
                            CommonWidgets().customSnackBar("", 'passwor_must_be_more_than_8_characters');
                          } else if (controller.confirmPasswordController.text !=
                              controller.newPasswordController.text) {
                            CommonWidgets().customSnackBar("", 'confirm_pass_must_match_new');
                          } else {
                            controller.onChangePasswordTap();
                            if (controller.showLoader.value) onNewLoading(context);
                          }
                        },
                        child: Text(
                          toLabelValue(ConstantsLabelKeys.changePasswordText).toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
