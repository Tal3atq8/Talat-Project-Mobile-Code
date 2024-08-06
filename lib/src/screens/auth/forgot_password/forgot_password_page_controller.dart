import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/talat_services.dart';
import '../../../theme/constant_strings.dart';
import '../../../widgets/progress_dialog.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();

  final forgotFormKey = GlobalKey<FormState>();
  RxBool showLoader = false.obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 3000), () {});
  }

  ///Forgot Password Api calling

  void onForgotTap() async {
    String errorMessage = "";
    if (emailController.text.isEmpty) {
      errorMessage = "enter_email";
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      errorMessage = "enter_valid_email_address";
    }
    if (errorMessage == "") {
      showLoader.value = true;
      try {
        await TalatService().forgotPassword({
          ConstantStrings.emailKey: emailController.text
        }).then((response) async {
          print(response.data);
          if (response.data['code'].toString() == "200" &&
              response.data['status'] == true) {
            CommonWidgets().showToastMessage(response.data["message"]);
            Get.back();
          } else {
            CommonWidgets().showToastMessage(response.data["message"]);
          }
        }).catchError((error) {
          debugPrint(error.toString());
          showLoader(false);
        });
      } on DioError catch (e) {
        debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
      }
      showLoader(false);
    } else {
      CommonWidgets().customSnackBar("title", errorMessage);
    }
  }
}
