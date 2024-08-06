import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:talat/src/models/generalSetting_model.dart';

import '../models/banner_model.dart';
import '../models/get_category_activity_detail_model.dart';
import '../models/label_model.dart';
import '../models/user_deati_model.dart';

String? language = "1";

GeneralSettingModel? generalSetting;

RxList<LabelResult> labelResult = <LabelResult>[].obs;

RxString providerName = "".obs;
RxString providerID = "".obs;
RxString itemID = "".obs;
RxString categoryID = "".obs;
RxString specialInstruction = "".obs;
RxString userLat = "".obs;
RxString userLong = "".obs;
RxString searchUserLong = "".obs;
RxString searchUserLat = "".obs;
RxString activityID = "".obs;
RxString activityName = "".obs;
RxString bookingID = "".obs;
RxString firebaseToken = "".obs;
RxString isFromCalendar = "".obs;
RxString selectedStartDate = "".obs;
RxString selectedEndDate = "".obs;
RxString selectedSlot = "".obs;
RxString serviceProviderName = "".obs;
RxString serviceProviderNumber = "".obs;
RxString isNotLoggedIn = "".obs;
LatLng? showLocation;
Rx<ExtraAdvertisementData> extraAdvertisementData = ExtraAdvertisementData().obs;
Rx<ActivityDetailItem> activityDetailItem = ActivityDetailItem().obs;
Rx<UserDetailModel> userDetailModel = UserDetailModel().obs;
