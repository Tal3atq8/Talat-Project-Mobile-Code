import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/screens/auth/login/login_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/enums/enum.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/widgets/common_text_style.dart';
import 'package:talat/src/widgets/custom_textform_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          bool shouldNavigate = true;
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
            actions: [
              GestureDetector(
                onTap: () {
                  Get.offAllNamed(AppRouteNameConstant.tabScreen);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25, top: 20, left: 25),
                  child: Text(toLabelValue(ConstantsLabelKeys.skipButton).toString(),
                      style: TextStyle(color: ColorConstant.whiteColor, fontSize: 16, fontWeight: FontWeight.w300)),
                ),
              ),
            ],
          ),
          backgroundColor: ColorConstant.appThemeColor,
          body: Obx(
            () => ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 50),
                // SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: Text(toLabelValue(ConstantsLabelKeys.getMobileNoText).toString(),
                      maxLines: 2,
                      style: TextStyle(color: ColorConstant.whiteColor, fontSize: 24, fontWeight: FontWeight.w300)),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 40, right: 16),
                  child: Text(toLabelValue(ConstantsLabelKeys.otpVerifyGetText),
                      style: txtStyleNormalGray14(color: ColorConstant.whiteColor)),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextFormField(
                    controller: controller.phoneNumberController,
                    readOnly: controller.isMobileRead.value,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        debugPrint(value);
                        controller.isEmailRead(true) && controller.isPasswordRead(true);
                      } else {
                        controller.isEmailRead(false) && controller.isPasswordRead(false);
                        // controller.isEmailRead(false);
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(9)
                    ],
                    prefix: SizedBox(
                      width: Get.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          const SizedBox(
                            width: 12,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child:
                                SvgPicture.asset("assets/icons/kuwait2.svg", height: 26, width: 20, fit: BoxFit.cover),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 22),
                  child: Row(children: <Widget>[
                    Flexible(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                          child: Divider(
                            color: ColorConstant.whiteColor,
                          )),
                    ),
                    Text("OR",
                        style: TextStyle(color: ColorConstant.whiteColor, fontSize: 14, fontWeight: FontWeight.w400)),
                    Flexible(
                      child: Container(
                          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Divider(
                            color: ColorConstant.whiteColor,
                            // height: 50,
                          )),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextFormField(
                    controller: controller.emailController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.isMobileRead.value = true;
                      } else {
                        controller.isMobileRead.value = false;
                      }
                      debugPrint('${controller.isMobileRead.value}');
                    },
                    inputFormatters: const [],
                    errorStyle: TextStyle(color: ColorConstant.whiteColor),
                    width: double.infinity,
                    readOnly: controller.isEmailRead.value,
                    hintText: toLabelValue(ConstantStrings.emailText),
                    textInputType: TextInputType.emailAddress,
                    margin: getMargin(
                      top: 10,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
                  child: CustomTextFormField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.isMobileRead.value = true;
                      } else {
                        controller.isMobileRead.value = false;
                      }
                    },
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
                    controller: controller.passwordController,
                    errorStyle: TextStyle(color: ColorConstant.whiteColor),
                    width: double.infinity,
                    hintText: toLabelValue(ConstantStrings.passwordText),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]")),
                    ],
                    readOnly: controller.isEmailRead.value,
                    textInputType: TextInputType.visiblePassword,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
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
                              controller.isLogedIn(controller.selectedCountryCode.value);

                              if (controller.showLoader.value == true) {
                                // onLoading(context);
                              }
                            },
                            child: Text(
                              toLabelValue(ConstantsLabelKeys.loginText).toString(),
                              style: TextStyle(
                                  color: ColorConstant.appThemeColor, fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: language == '1' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRouteNameConstant.forgotPasswordScreen,
                          );
                        },
                        child: Text(
                          toLabelValue(ConstantsLabelKeys.forgotpassword).toString(),
                          style: TextStyle(color: ColorConstant.whiteColor, fontSize: 14, fontWeight: FontWeight.w400),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: ColorConstant.appThemeColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 16),
              child: ListTile(
                title: Text(toLabelValue(ConstantsLabelKeys.byUsingText).toString(),
                    style: TextStyle(color: ColorConstant.whiteColor, fontSize: 12, fontWeight: FontWeight.w300)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Get.toNamed(AppRouteNameConstant.cmsScreen);
                          Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.termsandcondition);
                        },
                        child: Text(toLabelValue(ConstantsLabelKeys.termsConditions).toString(),
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w300)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2),
                        child: Text(toLabelValue(ConstantsLabelKeys.andText).toString(),
                            style:
                                TextStyle(color: ColorConstant.whiteColor, fontSize: 12, fontWeight: FontWeight.w300)),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRouteNameConstant.cmsScreen, arguments: CmsType.privacypolicy);
                        },
                        child: Text(toLabelValue(ConstantsLabelKeys.privacyPoilicy).toString(),
                            style: TextStyle(
                                color: ColorConstant.whiteColor,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w300)),
                      ),
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
}
