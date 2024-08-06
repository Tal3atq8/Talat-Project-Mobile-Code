import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NotificationSettingModel {
  const NotificationSettingModel({this.id, this.title, this.desc, this.isEnableItem});

  final int? id;
  final String? title;
  final String? desc;
  final RxBool? isEnableItem;
}

class NotificationSettingListModel {
  String? code;
  String? message;
  List<Result>? result;

  NotificationSettingListModel({this.code, this.message, this.result});

  NotificationSettingListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  List<NotificationSettingList>? notificationSettingList;

  Result({this.notificationSettingList});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['notificationSetting_list'] != null) {
      notificationSettingList = <NotificationSettingList>[];
      json['notificationSetting_list'].forEach((v) {
        notificationSettingList!.add(new NotificationSettingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (notificationSettingList != null) {
      data['notificationSetting_list'] = notificationSettingList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationSettingList {
  String? notificationName;
  String? notificationDec;
  String? notificationIsEnable;

  NotificationSettingList({this.notificationName, this.notificationDec, this.notificationIsEnable});

  NotificationSettingList.fromJson(Map<String, dynamic> json) {
    notificationName = json['notification_name'];
    notificationDec = json['notification_dec'];
    notificationIsEnable = json['notification_isEnable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_name'] = notificationName;
    data['notification_dec'] = notificationDec;
    data['notification_isEnable'] = notificationIsEnable;
    return data;
  }
}
