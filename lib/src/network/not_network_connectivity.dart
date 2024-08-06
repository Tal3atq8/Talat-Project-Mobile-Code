import 'package:flutter/material.dart';
import 'package:talat/src/theme/image_constants.dart';

class NoNetworkConnectivity extends StatefulWidget {
  const NoNetworkConnectivity({
    super.key,
  });

  @override
  State<NoNetworkConnectivity> createState() => _NoNetworkConnectivityState();
}

class _NoNetworkConnectivityState extends State<NoNetworkConnectivity> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            ImageConstant.noInternet,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
