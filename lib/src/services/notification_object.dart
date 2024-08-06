import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/utils/utility.dart';

class NotificationObject {
  Map<String, dynamic>? pendingNotification;

  static String storeNotificationObject = "kNotificationObject";
  static NotificationObject currentObject = NotificationObject();

  static Future<bool> isUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeUserDetails = prefs.getString(NotificationObject.storeNotificationObject);
    return (storeUserDetails != null);
  }

  NotificationObject({this.pendingNotification});

  Future<void> updateNotificationDetails(Map<String, dynamic> jsonValue, {bool isNeedToSaveDetails = true}) async {
    pendingNotification = jsonValue;

    if (isNeedToSaveDetails && this == NotificationObject.currentObject) {
      this.saveObject();
    }
  }

  Future<void> saveObject() async {
    final userMap = this.pendingNotification;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(NotificationObject.storeNotificationObject, json.encode(userMap));
  }

  NotificationObject.fromJson(Map<String, dynamic> json) {
    pendingNotification = json;
  }

  Future<void> loadPastObjectDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storeUser = prefs.getString(NotificationObject.storeNotificationObject);

    if (storeUser != null) {
      // Load store user
      Map<String, dynamic> jsonValue = json.decode(storeUser);
      await this.updateNotificationDetails(jsonValue, isNeedToSaveDetails: false);
    }
  }

  Future<void> resetUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(NotificationObject.storeNotificationObject);

    this.pendingNotification = null;
  }
}