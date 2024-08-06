import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/auth/login/login_screen_controller.dart';
import 'package:talat/src/screens/auth/otp/otp_screen_controller.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/utility.dart';

import '../../../theme/color_constants.dart';

class Otp extends GetWidget<OtpController> {
  Otp({Key? key}) : super(key: key);
  @override
  final controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldNavigate = true;

        if (shouldNavigate) {
          Get.delete<OtpController>();
          Get.delete<LoginController>();
          Get.offNamed(AppRouteNameConstant.loginScreen);

          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appThemeColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.delete<OtpController>();
                Get.delete<LoginController>();
                Get.back();
              },
              icon: Icon(
                size: 18,
                Icons.arrow_back_ios,
                color: ColorConstant.whiteColor,
              )),
        ),
        backgroundColor: ColorConstant.appThemeColor,
        body: Form(
          key: controller.otpFormKey,
          child: controller.showLoader.value == true
              ? const SizedBox(
                  height: 10,
                  width: 10,
                  child: Center(
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,

                        /// Required, The loading type of the widget
                        colors: [Colors.white],

                        /// Optional, The color collections
                        strokeWidth: 2,

                        /// Optional, The stroke of the line, only applicable to widget which contains line
                        backgroundColor: Colors.transparent,

                        /// Optional, Background of the widget
                        pathBackgroundColor: Colors.black

                        /// Optional, the stroke backgroundColor
                        ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(toLabelValue(ConstantStrings.weHaveText),
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: Text(
                            toLabelValue(ConstantStrings.pleaseEnterOtpText),
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w100)),
                      ),
                      Obx(() {
                        print(controller.isLoading.value);
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 4, right: 16),
                          child: Text(
                              '${ConstantStrings.countryCodeKuwait}  ${controller.phoneNo}',
                              style: TextStyle(
                                  color: ColorConstant.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300)),
                        );
                      }),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: PinFieldAutoFill(
                            cursor: Cursor(
                              width: 2,
                              height: 30,
                              color: Colors.white,
                              enabled: true,
                            ),
                            //autoFocus: true,
                            enableInteractiveSelection: true,
                            controller: controller.otpController,
                            keyboardType: TextInputType.number,
                            currentCode: controller.start.value == 0
                                ? null
                                : controller.hintOtp.value,
                            decoration: UnderlineDecoration(
                              textStyle: const TextStyle(color: Colors.white),
                              colorBuilder:
                                  FixedColorBuilder(ColorConstant.whiteColor),
                            ),
                            codeLength: 6,
                            onCodeChanged: (code) {
                              controller.otpCode.value = code.toString();
                            },
                            onCodeSubmitted: (val) {},
                          ),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 48.0),
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          '${strDigits(Duration(seconds: controller.start.value).inMinutes.remainder(60))}:${strDigits(Duration(seconds: controller.start.value).inSeconds.remainder(60))}',
                                      style: TextStyle(
                                          color: ColorConstant.whiteColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                controller.start.value == 0
                                    ? controller.onReSendOtpTap()
                                    : null;

                                if (controller.start.value == 0) {
                                  controller.start.value = 120;
                                  controller.startTimer();
                                }
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: toLabelValue(
                                            ConstantsLabelKeys.didnt_get_code),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300)),
                                    TextSpan(
                                        text:
                                            ' ${toLabelValue(ConstantStrings.tryAgainText)}',
                                        style: TextStyle(
                                            color: controller.start.value == 0
                                                ? ColorConstant.whiteColor
                                                : ColorConstant.grayBorderColor,
                                            fontSize: 14,
                                            fontWeight:
                                                controller.start.value == 0
                                                    ? FontWeight.bold
                                                    : FontWeight.w300)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox(height: 0.0)),
                    ]),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() {
              return Container(
                padding: const EdgeInsets.only(bottom: 24, right: 16, left: 16),
                child: controller.showLoader.value
                    ? CircularProgressIndicator(
                        color: ColorConstant.whiteColor,
                      )
                    : ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              ColorConstant.whiteColor),
                          elevation: MaterialStateProperty.all(0),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10)),
                          textStyle: MaterialStateProperty.all(TextStyle(
                              fontSize: 16,
                              color: ColorConstant.appThemeColor,
                              fontWeight: FontWeight.bold)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.blue[100]; //<-- SEE HERE
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        // style: ElevatedButton.styleFrom(

                        onPressed: () {
                          controller.onOtpTap();
                        },
                        child: Text(
                          toLabelValue(ConstantsLabelKeys.nextButton)
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                              color: ColorConstant.appThemeColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

String strDigits(int n) => n.toString().padLeft(2, '0');
