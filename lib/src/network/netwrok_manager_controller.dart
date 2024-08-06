import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talat/main.dart';
import 'package:talat/src/app_routes/app_routes.dart';

import '../models/generalSetting_model.dart';
import '../services/talat_services.dart';
import '../utils/global_constants.dart';

class GetXNetworkManager extends GetxController {
  /// this variable 0 = No Internet, 1 = connected to WIFI ,2 = connected to Mobile Data.
  int connectionType = 0;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateState);
  }

  callLabelsAndGeneralSetting() {
    labelAPi();
    TalatService().generalSettings().then((response) {
      generalSetting = GeneralSettingModel.fromJson(response.data);
      debugPrint('$generalSetting');
    });
  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  Future<void> GetConnectionType() async {
    var connectivityResult;
    try {
      connectivityResult = await (_connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return _updateState(connectivityResult);
  }

  // state update, of network, if you are connected to WIFI connectionType will get set to 1,
  // and update the state to the consumer of that variable.
  _updateState(ConnectivityResult result) {
    debugPrint("Network result ========>  $result");
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType = 1;
        callLabelsAndGeneralSetting();

        update();
        Get.back();
        break;
      case ConnectivityResult.mobile:
        connectionType = 2;
        callLabelsAndGeneralSetting();
        update();
        Get.back();
        break;
      case ConnectivityResult.other:
        connectionType = 3;
        callLabelsAndGeneralSetting();
        update();
        Get.back();
        break;
      case ConnectivityResult.none:
        connectionType = 0;

        Get.toNamed(AppRouteNameConstant.networkScreen);
        update();
        break;

      default:
        Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }
  }
}
