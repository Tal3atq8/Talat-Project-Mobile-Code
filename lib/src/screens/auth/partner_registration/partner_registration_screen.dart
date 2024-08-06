import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talat/src/screens/auth/partner_registration/partner_registration_screen_controller.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_label.dart';
import 'package:talat/src/utils/size_utils.dart';
import 'package:talat/src/utils/utility.dart';
import 'package:talat/src/utils/validations.dart';
import 'package:talat/src/widgets/custom_textform_field.dart';

import '../../../theme/constant_strings.dart';
import '../../../widgets/common_text_style.dart';

class PartnerRegistration extends GetWidget<PartnerRegistrationController> {
  PartnerRegistration({super.key});
  @override
  final controller = Get.put(PartnerRegistrationController());
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: ColorConstant.appThemeColor,
        appBar: AppBar(
          backgroundColor: ColorConstant.appThemeColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                size: 20,
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body: Stack(
          children: [
            IgnorePointer(
              ignoring: controller.showLoader.value ? true : false,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(toLabelValue('welcome'),
                          style: TextStyle(
                              color: ColorConstant.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(toLabelValue('reach_new_customer'),
                          style: TextStyle(
                              color: ColorConstant.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w300)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18.0, top: 20, right: 18),
                      child: CustomTextFormField(
                        width: double.infinity,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-Z' ']")),
                          FilteringTextInputFormatter.deny(RegExp("  "))
                        ],
                        controller: controller.providerNameController,
                        errorStyle: TextStyle(color: ColorConstant.whiteColor),
                        hintText: toLabelValue('provider_name'),
                        textInputType: TextInputType.text,
                        margin: getMargin(
                          top: 10,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return toLabelValue("enter_provider_name");
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: CustomTextFormField(
                        width: double.infinity,
                        errorStyle: TextStyle(color: ColorConstant.whiteColor),
                        controller: controller.emailController,
                        inputFormatters: const [],
                        hintText: toLabelValue('email'),
                        textInputType: TextInputType.emailAddress,
                        margin: getMargin(
                          top: 10,
                        ),
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null ||
                              (!isValidEmail(value, isRequired: true))) {
                            return toLabelValue("enter_valid_email");
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: CustomTextFormField(
                        controller: controller.phoneNumberController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9)
                        ],
                        prefix: SizedBox(
                          width: Get.width * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
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
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18.0, top: 0, right: 18),
                      child: CustomTextFormField(
                        onTapEvent: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 600));
                          RenderObject? object =
                              globalKey.currentContext?.findRenderObject();
                          if (object != null) {
                            object.showOnScreen();
                          }
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(120)
                        ],
                        width: double.infinity,
                        controller: controller.businessController,
                        errorStyle: TextStyle(color: ColorConstant.whiteColor),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return toLabelValue(
                                ConstantsLabelKeys.enter_description);
                          }
                          return null;
                        },
                        maxLines: 6,
                        hintText: toLabelValue(
                            ConstantsLabelKeys.somethimg_about_business),
                        textInputType: TextInputType.text,
                        margin: getMargin(
                          top: 10,
                        ),
                      ),
                    ),
                    Padding(
                      key: globalKey,
                      padding: const EdgeInsets.only(
                          left: 18.0, top: 40, right: 18, bottom: 40),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          minimumSize: MaterialStateProperty.all(
                              const Size.fromHeight(50)),
                          backgroundColor: MaterialStateProperty.all(
                              ColorConstant.whiteColor),
                          textStyle: MaterialStateProperty.all(const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
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
                        onPressed: () {
                          FocusManager.instance.primaryFocus!.unfocus();
                          controller.onSignupTap();
                        },
                        child: Text(
                          toLabelValue(ConstantsLabelKeys.submitText)
                              .toString(),
                          style: TextStyle(
                              fontFamily: GoogleFonts.lato().fontFamily,
                              color: ColorConstant.appThemeColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.showLoader.value)
              Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.appThemeColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
