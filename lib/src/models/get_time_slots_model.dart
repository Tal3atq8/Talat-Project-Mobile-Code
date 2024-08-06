class GetTimeSlotsResponseModel {
  String? message;
  bool? status;
  dynamic? code;
  List<Result>? result;

  GetTimeSlotsResponseModel(
      {this.message, this.status, this.code, this.result});

  GetTimeSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  dynamic id;
  dynamic timeSlot;
  int? availableSlot;

  Result({this.id, this.timeSlot, this.availableSlot});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeSlot = json['time_slot'];
    availableSlot = json['available_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time_slot'] = timeSlot;
    data['available_slot'] = availableSlot;
    return data;
  }
}
