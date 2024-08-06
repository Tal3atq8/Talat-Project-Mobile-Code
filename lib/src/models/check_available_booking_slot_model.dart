class CheckAvailableBookingSlotModel {
  String? message;
  bool? status;
  dynamic code;
  List<Result>? result;

  CheckAvailableBookingSlotModel(
      {this.message, this.status, this.code, this.result});

  CheckAvailableBookingSlotModel.fromJson(Map<String, dynamic> json) {
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
  int? slotId;
  String? date;
  String? startDate;
  String? endDate;
  TimeSlot? timeSlot;
  int? availableSlot;

  Result({
    this.slotId,
    this.date,
    this.startDate,
    this.endDate,
    this.timeSlot,
    this.availableSlot,
  });

  Result.fromJson(Map<String, dynamic> json) {
    slotId = json['slot_id'];
    date = json['date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    timeSlot =
        json['time_slot'] != null ? TimeSlot.fromJson(json['time_slot']) : null;
    availableSlot = json['available_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slot_id'] = slotId;
    data['date'] = date;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    if (timeSlot != null) {
      data['time_slot'] = timeSlot!.toJson();
    }
    data['available_slot'] = availableSlot;
    return data;
  }
}

class TimeSlot {
  String? startTime;
  String? endTime;

  TimeSlot({this.startTime, this.endTime});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
