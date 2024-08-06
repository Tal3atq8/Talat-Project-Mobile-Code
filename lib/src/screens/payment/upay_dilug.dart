import 'package:flutter/material.dart';
import 'package:flutter_upayments/src/u_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UpayDialogs extends StatefulWidget {
  final Map<String, dynamic> arguments = Get.arguments;

  paymentDetails? data;
  String? weblink;
  Function(
    bool status,
    Map TransactionDetails,
    String message,
  )? OnSuccess;
  Function(
    bool status,
    Map TransactionDetails,
    String message,
  )? OnFailure;

  UpayDialogs({Key? key, this.data, this.OnFailure, this.OnSuccess, this.weblink}) : super(key: key);

  @override
  _UpayDialogsState createState() => _UpayDialogsState();
}

class _UpayDialogsState extends State<UpayDialogs> {
  final Map<String, dynamic> arguments = Get.arguments;

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    var prefixUrl = ConstantStrings.prefixUrl;

    var successUrl = "$prefixUrl/payment-success";
    var failureUrl = "$prefixUrl/payment-error";

    // var successUrl = "https://example.com/success.html";
    // var failureUrl = "https://example.com/error.html";

    if (request.url.contains(failureUrl)) {
      var data = Uri.dataFromString(request.url);
// debugPrint(data.queryParametersAll);
      Map val = data.queryParametersAll;
      Fluttertoast.showToast(
              msg: "Something Went Wrong!\nTry Again Later",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0)
          .then((value) => arguments['OnFailure'](false, val, "Payment Failed"));

      return NavigationDecision.prevent;
    }
    if (request.url.startsWith(successUrl)) {
      var data = Uri.dataFromString(request.url);
// debugPrint(data.queryParametersAll);
      Map val = data.queryParametersAll;
      Fluttertoast.showToast(
              msg: "Payment Completed Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0)
          .then((value) {
        arguments['OnSuccess'](false, val, 'Payment succeed');
      });
      Navigator.pop(context);

      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  )),
            ),
            WebView(
              initialUrl: arguments['weblink'],
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: _interceptNavigation,
            ),
          ],
        ),
      ),
    );
  }
}
