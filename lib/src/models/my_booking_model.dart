class MyBookingModel {
  String? message;
  bool? status;
  int? code;
  Result? result;

  MyBookingModel({this.message, this.status, this.code, this.result});

  MyBookingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<ActiveBooking>? activeBooking;
  List<CompletedBooking>? completedBooking;
  List<CancelBooking>? cancelBooking;
  String? langId;

  Result({this.activeBooking, this.completedBooking, this.cancelBooking, this.langId});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['active_booking'] != null) {
      activeBooking = <ActiveBooking>[];
      json['active_booking'].forEach((v) {
        activeBooking!.add(ActiveBooking.fromJson(v));
      });
    }
    if (json['completed_booking'] != null) {
      completedBooking = <CompletedBooking>[];
      json['completed_booking'].forEach((v) {
        completedBooking!.add(CompletedBooking.fromJson(v));
      });
    }
    if (json['cancel_booking'] != null) {
      cancelBooking = <CancelBooking>[];
      json['cancel_booking'].forEach((v) {
        cancelBooking!.add(CancelBooking.fromJson(v));
      });
    }
    langId = json['lang_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (activeBooking != null) {
      data['active_booking'] = activeBooking!.map((v) => v.toJson()).toList();
    }
    if (completedBooking != null) {
      data['completed_booking'] = completedBooking!.map((v) => v.toJson()).toList();
    }
    if (cancelBooking != null) {
      data['cancel_booking'] = cancelBooking!.map((v) => v.toJson()).toList();
    }
    data['lang_id'] = langId;
    return data;
  }
}

class ActiveBooking {
  String? bookingStatus;
  int? bookingId;
  String? bookingName;
  String? bookingFromDate;
  String? bookingToDate;
  int? bookingAmount;
  String? timeSlot;
  String? activityName;
  ServiceProviderInfo? serviceProviderInfo;

  ActiveBooking(
      {this.bookingStatus,
      this.bookingId,
      this.bookingName,
      this.bookingFromDate,
      this.bookingToDate,
      this.bookingAmount,
      this.timeSlot,
      this.activityName,
      this.serviceProviderInfo});

  ActiveBooking.fromJson(Map<String, dynamic> json) {
    bookingStatus = json['booking_status'];
    bookingId = json['booking_id'];
    bookingName = json['booking_name'];
    bookingFromDate = json['booking_fromDate'];
    bookingToDate = json['booking_toDate'];
    bookingAmount = json['booking_amount'] == null ? 0 : int.parse(json['booking_amount'].toString());
    timeSlot = json['time_slot'];
    activityName = json['activity_name'];
    serviceProviderInfo =
        json['service_providerInfo'] != null ? ServiceProviderInfo.fromJson(json['service_providerInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['booking_status'] = bookingStatus;
    data['booking_id'] = bookingId;
    data['booking_name'] = bookingName;
    data['booking_fromDate'] = bookingFromDate;
    data['booking_toDate'] = bookingToDate;
    data['booking_amount'] = bookingAmount;
    data['time_slot'] = timeSlot;
    data['activity_name'] = activityName;
    if (serviceProviderInfo != null) {
      data['service_providerInfo'] = serviceProviderInfo!.toJson();
    }
    return data;
  }
}

class ServiceProviderInfo {
  int? serviceProviderId;
  String? serviceProviderName;

  ServiceProviderInfo({this.serviceProviderId, this.serviceProviderName});

  ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    return data;
  }
}

class CompletedBooking {
  String? bookingStatus;
  int? bookingId;
  String? bookingName;
  String? bookingFromDate;
  String? bookingToDate;
  int? bookingAmount;
  String? timeSlot;
  ServiceProviderInfo? serviceProviderInfo;

  CompletedBooking({
    this.bookingStatus,
    this.bookingId,
    this.bookingName,
    this.bookingFromDate,
    this.bookingToDate,
    this.bookingAmount,
    this.timeSlot,
    this.serviceProviderInfo,
  });

  CompletedBooking.fromJson(Map<String, dynamic> json) {
    bookingStatus = json['booking_status'];
    bookingId = json['booking_id'];
    bookingName = json['booking_name'];
    bookingFromDate = json['booking_fromDate'];
    bookingToDate = json['booking_toDate'];
    bookingAmount = json['booking_amount'] == null ? 0 : int.parse(json['booking_amount'].toString());
    timeSlot = json['time_slot'];
    serviceProviderInfo =
        json['service_providerInfo'] != null ? ServiceProviderInfo.fromJson(json['service_providerInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['booking_status'] = bookingStatus;
    data['booking_id'] = bookingId;
    data['booking_name'] = bookingName;
    data['booking_fromDate'] = bookingFromDate;
    data['booking_toDate'] = bookingToDate;
    data['booking_amount'] = bookingAmount;
    data['time_slot'] = timeSlot;
    if (serviceProviderInfo != null) {
      data['service_providerInfo'] = serviceProviderInfo!.toJson();
    }
    return data;
  }
}

class CancelBooking {
  String? bookingStatus;
  int? bookingId;
  String? bookingName;
  String? bookingFromDate;
  String? bookingToDate;
  int? bookingAmount;
  String? timeSlot;
  ServiceProviderInfo? serviceProviderInfo;

  CancelBooking(
      {this.bookingStatus,
      this.bookingId,
      this.bookingName,
      this.bookingFromDate,
      this.bookingToDate,
      this.bookingAmount,
      this.timeSlot,
      this.serviceProviderInfo});

  CancelBooking.fromJson(Map<String, dynamic> json) {
    bookingStatus = json['booking_status'];
    bookingId = json['booking_id'];
    bookingName = json['booking_name'];
    bookingFromDate = json['booking_fromDate'];
    bookingToDate = json['booking_toDate'];
    bookingAmount = json['booking_amount'] == null ? 0 : int.parse(json['booking_amount'].toString());
    timeSlot = json['time_slot'];
    serviceProviderInfo =
        json['service_providerInfo'] != null ? ServiceProviderInfo.fromJson(json['service_providerInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['booking_status'] = bookingStatus;
    data['booking_id'] = bookingId;
    data['booking_name'] = bookingName;
    data['booking_fromDate'] = bookingFromDate;
    data['booking_toDate'] = bookingToDate;
    data['booking_amount'] = bookingAmount;
    data['time_slot'] = timeSlot;
    if (serviceProviderInfo != null) {
      data['service_providerInfo'] = serviceProviderInfo!.toJson();
    }
    return data;
  }
}
