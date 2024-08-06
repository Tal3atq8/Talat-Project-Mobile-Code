import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/models/search_map_model.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/utils/preference/preferences.dart';

import '../../utils/preference/preference_keys.dart';
import '../../widgets/progress_dialog.dart';

class MapScreenController extends GetxController {
  Completer<GoogleMapController> markerController = Completer();
  RxBool isVisibleData = false.obs;

  Rx<MapModel> mapResponse = MapModel().obs;
  Rx<MapResult> mapResponseResult = MapResult().obs;
  Rx<MapResult> selectedMapResponseResult = MapResult().obs;
  TextEditingController searchText = TextEditingController();
  RxSet<Marker> markers = <Marker>{}.obs;
  BitmapDescriptor? customMarker;

  // Set<Marker> markers = Set();
  String? usertoken;
  String? userId;
  String? selectedId;

  @override
  void onInit() async {
    super.onInit();
    usertoken = await SharedPref.getString(PreferenceConstants.token);
    userId = await SharedPref.getString(PreferenceConstants.userId);
  }

  /// Get PopularActivityList api Calling
  Future<void> getSearchMap() async {
    try {
      await TalatService().searchPlace({
        ConstantStrings.languageId: language ?? "1",
        "latitude": userLat.value,
        "longitude": userLong.value,
      }).then((response) async {
        if (response.data['code'] == "1") {
          mapResponse.value = MapModel.fromJson(response.data);
          // await addMarkerIcon();
          update();
        } else if (response.data["code"] == "-7") {
          // Get.back();
          CommonWidgets().showToastMessage('user_login_other_device');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        } else if (response.data["code"] == "-1" && response.data["message"] == "inactive_account") {
          CommonWidgets().showToastMessage('inactive_account');
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
          // showLoader(false);
        } else if (response.data["code"] == "-4" && response.data["message"] == "delete_account") {
          CommonWidgets().showToastMessage(response.data["message"]);
          language = await SharedPref.getString(PreferenceConstants.laguagecode);

          await SharedPref.clearSharedPref();
          await SharedPref.setString(PreferenceConstants.laguagecode, language);
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
          // await SharedPref.setString(PreferenceConstants.laguagecode, '1');
          update();
        }
      }).catchError((error) {
        debugPrint(error.toString());
      });
    } on DioError catch (e) {
      debugPrint("authenticateUsererror dio error >>>> ${e.toString()}");
    }
  }
}
