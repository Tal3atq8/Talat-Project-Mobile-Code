class AvailableDaysModel {
  String? code;
  String? message;
  List<AvailableStartEndDate>? result;

  AvailableDaysModel({this.code, this.message, this.result});

  AvailableDaysModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <AvailableStartEndDate>[];
      json['result'].forEach((v) {
        result!.add(AvailableStartEndDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableStartEndDate {
  String? startDate;
  String? endDate;

  AvailableStartEndDate({this.startDate, this.endDate});

  AvailableStartEndDate.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    return data;
  }
}
