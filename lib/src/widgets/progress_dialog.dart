import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:talat/src/theme/color_constants.dart';

import '../utils/utility.dart';

Future<void> onLoading(BuildContext context) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => true,
          child: const Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SpinKitWave(color: Colors.white, size: 40.0),
          )));
  await Future<int>.delayed(const Duration(seconds: 1));
}

Future<void> onNewLoading(BuildContext context) async {
  Timer? timer = Timer(const Duration(seconds: 4), () {
    Get.back();
  });
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => true,
          child: const Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator(color: Colors.red))),
          ))).then((value) {
    // dispose the timer in case something else has triggered the dismiss.
    timer?.cancel();
    timer = null;
  });
  await Future<int>.delayed(const Duration(seconds: 1));
}

class CommonWidgets {
  customSnackBar(String? title, String msg) {
    Get.closeAllSnackbars();
    Get.closeCurrentSnackbar();
    Get.snackbar(
      "",
      "",
      // icon: const Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black,
      borderRadius: 20,
      titleText: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Text(toLabelValue(msg), style: TextStyle(color: ColorConstant.whiteColor)),
      ),
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(15),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      // dismissDirection: SnackDismissDirection.HORIZONTAL,
      // forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  showToastMessage(String msg, {bool? isShortToast}) {
    return Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      toastLength: isShortToast != null && isShortToast ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG,
      msg: toLabelValue(msg),
    );
  }
// showToastMessage(String msg) {
//   return Fluttertoast.showToast(
//     msg: msg,
//   );
// }
}

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackSpace,
        child: SpinKitRipple(
          color: ColorConstant.appThemeColor,
          size: 100,
          borderWidth: 8.0,
        ));
  }

  Future<bool> _onBackSpace() async {
    return false;
  }
}
