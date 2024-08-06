class BookingDetailResponseModel {
  String? message;
  bool? status;
  dynamic code;
  Result? result;

  BookingDetailResponseModel({this.message, this.status, this.code, this.result});

  BookingDetailResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  BookingDetail? bookingDetail;
  ItemDetail? itemDetail;
  ProviderDetail? providerDetail;
  dynamic customerInstructions;
  int? noOfPersons;

  Result({this.bookingDetail, this.itemDetail, this.providerDetail, this.customerInstructions, this.noOfPersons});

  Result.fromJson(Map<String, dynamic> json) {
    bookingDetail = json['booking_detail'] != null ? BookingDetail.fromJson(json['booking_detail']) : null;
    itemDetail = json['item_detail'] != null ? ItemDetail.fromJson(json['item_detail']) : null;
    providerDetail = json['provider_detail'] != null ? ProviderDetail.fromJson(json['provider_detail']) : null;
    customerInstructions = json['customer_instructions'];
    noOfPersons = json['no_of_persons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookingDetail != null) {
      data['booking_detail'] = bookingDetail!.toJson();
    }
    if (itemDetail != null) {
      data['item_detail'] = itemDetail!.toJson();
    }
    if (providerDetail != null) {
      data['provider_detail'] = providerDetail!.toJson();
    }
    data['customer_instructions'] = customerInstructions;
    data['no_of_persons'] = noOfPersons;
    return data;
  }
}

class BookingDetail {
  dynamic bookingId;
  String? transactionId;
  String? bookingType;
  String? bookingName;
  String? bookingPaymentMethod;
  String? bookingScheduleDate;
  String? bookingFromDate;
  String? bookingToDate;
  String? timeSlot;
  String? cancelReason;
  String? cancelType;
  String? cancelDate;

  BookingDetail(
      {this.bookingId,
      this.transactionId,
      this.bookingType,
      this.bookingName,
      this.bookingPaymentMethod,
      this.bookingScheduleDate,
      this.bookingFromDate,
      this.bookingToDate,
      this.timeSlot,
      this.cancelReason,
      this.cancelType,
      this.cancelDate});

  BookingDetail.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    transactionId = json['transaction_id'];
    bookingType = json['booking_type'];
    bookingName = json['booking_name'];
    bookingPaymentMethod = json['booking_payment_method'];
    bookingScheduleDate = json['booking_scheduleDate'];
    bookingFromDate = json['booking_fromDate'];
    bookingToDate = json['booking_toDate'];
    timeSlot = json['time_slot'];
    cancelReason = json['cancel_reason'];
    cancelType = json['cancel_type'];
    cancelDate = json['cancel_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['transaction_id'] = transactionId;
    data['booking_type'] = bookingType;
    data['booking_name'] = bookingName;
    data['booking_payment_method'] = bookingPaymentMethod;
    data['booking_scheduleDate'] = bookingScheduleDate;
    data['booking_fromDate'] = bookingFromDate;
    data['booking_toDate'] = bookingToDate;
    data['time_slot'] = timeSlot;
    data['cancel_reason'] = cancelReason;
    data['cancel_type'] = cancelType;
    data['cancel_date'] = cancelDate;
    return data;
  }
}

class ItemDetail {
  int? itemId;
  String? itemName;
  String? itemImage;
  String? itemAddress;
  dynamic is_location;
  dynamic itemLatitude;
  dynamic itemLongitude;
  dynamic itemAmount;
  String? itemInstructions;
  dynamic rating;

  ItemDetail(
      {this.itemId,
      this.itemName,
      this.itemImage,
      this.itemAddress,
      this.itemLatitude,
      this.is_location,
      this.itemLongitude,
      this.itemAmount,
      this.itemInstructions,
      this.rating});

  ItemDetail.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    is_location = json['item_is_location'];
    itemAddress = json['item_address'];
    itemLatitude = json['item_latitude'];
    itemLongitude = json['item_longitude'];
    itemAmount = json['item_amount'];
    itemInstructions = json['item_instructions'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_image'] = itemImage;
    data['item_address'] = itemAddress;
    data['item_latitude'] = itemLatitude;
    data['item_longitude'] = itemLongitude;
    data['item_amount'] = itemAmount;
    data['item_instructions'] = itemInstructions;
    data['rating'] = rating;
    return data;
  }
}

class ProviderDetail {
  int? serviceProviderId;
  String? serviceProviderName;
  String? serviceProviderCountryCode;
  int? serviceProviderMobile;
  String? serviceProviderAddress;
  int? serviceProviderLatitude;
  int? serviceProviderLongitude;

  ProviderDetail(
      {this.serviceProviderId,
      this.serviceProviderName,
      this.serviceProviderCountryCode,
      this.serviceProviderMobile,
      this.serviceProviderAddress,
      this.serviceProviderLatitude,
      this.serviceProviderLongitude});

  ProviderDetail.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_providerId'];
    serviceProviderName = json['service_providerName'];
    serviceProviderCountryCode = json['service_providerCountryCode'];
    serviceProviderMobile = json['service_providerMobile'];
    serviceProviderAddress = json['service_providerAddress'];
    serviceProviderLatitude = json['service_providerLatitude'];
    serviceProviderLongitude = json['service_providerLongitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_providerId'] = serviceProviderId;
    data['service_providerName'] = serviceProviderName;
    data['service_providerCountryCode'] = serviceProviderCountryCode;
    data['service_providerMobile'] = serviceProviderMobile;
    data['service_providerAddress'] = serviceProviderAddress;
    data['service_providerLatitude'] = serviceProviderLatitude;
    data['service_providerLongitude'] = serviceProviderLongitude;
    return data;
  }
}
