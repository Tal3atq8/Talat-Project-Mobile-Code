import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/color_constants.dart';
import '../../../theme/constant_label.dart';
import '../../../theme/constant_strings.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/utility.dart';
import '../../../widgets/common_text_style.dart';
import '../../../widgets/custom_textform_field.dart';
import 'forgot_password_page_controller.dart';

class ForgotPassword extends GetWidget<ForgotPasswordController> {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: ColorConstant.appThemeColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                size: 18,
                Icons.arrow_back_ios,
                color: ColorConstant.whiteColor,
              )),
        ),
        backgroundColor: ColorConstant.appThemeColor,
        body: Obx(
          () => ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Text(toLabelValue(ConstantsLabelKeys.forgotpassword).toString(),
                    maxLines: 2,
                    style: TextStyle(color: ColorConstant.whiteColor, fontSize: 24, fontWeight: FontWeight.w300)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 40, right: 16),
                child: Text(toLabelValue(ConstantsLabelKeys.enter_email_to_receive_password),
                    style: txtStyleNormalGray14(color: ColorConstant.whiteColor)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextFormField(
                  controller: controller.emailController,
                  errorStyle: TextStyle(color: ColorConstant.whiteColor),
                  width: double.infinity,
                  hintText: toLabelValue(ConstantStrings.emailText),
                  textInputType: TextInputType.emailAddress,
                  margin: getMargin(
                    top: 10,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: controller.showLoader.value
                      ? Center(
                          child: CircularProgressIndicator(
                          color: ColorConstant.whiteColor,
                        ))
                      : ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            minimumSize: MaterialStateProperty.all(const Size.fromHeight(50)),
                            backgroundColor: MaterialStateProperty.all(ColorConstant.whiteColor),
                            textStyle:
                                MaterialStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            ),
                            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.blue[100]; //<-- SEE HERE
                                }
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            FocusManager.instance.primaryFocus!.unfocus();
                            controller.onForgotTap();

                            if (controller.showLoader.value == true) {}
                          },
                          child: Text(
                            toLabelValue(ConstantsLabelKeys.submitText).toString(),
                            style: TextStyle(
                                color: ColorConstant.appThemeColor, fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
