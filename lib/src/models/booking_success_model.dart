class BookingSuccessModel {
  String? message;
  bool? status;
  int? code;
  Result? result;

  BookingSuccessModel({this.message, this.status, this.code, this.result});

  BookingSuccessModel.fromJson(Map<String, dynamic> json) {
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
  int? bookingId;
  String? noOfPersons;
  ServiceProviderInfo? serviceProviderInfo;

  Result({this.bookingId, this.serviceProviderInfo});

  Result.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    noOfPersons = json['no_of_persons'];
    serviceProviderInfo =
        json['service_providerInfo'] != null ? ServiceProviderInfo.fromJson(json['service_providerInfo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['no_of_persons'] = noOfPersons;
    if (serviceProviderInfo != null) {
      data['service_providerInfo'] = serviceProviderInfo!.toJson();
    }
    return data;
  }
}

class ServiceProviderInfo {
  int? serviceProviderId;
  String? serviceProviderName;
  String? serviceProviderAdress;
  String? serviceProviderImage;

  ServiceProviderInfo(
      {this.serviceProviderId, this.serviceProviderName, this.serviceProviderAdress, this.serviceProviderImage});

  ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderAdress = json['service_provider_adress'];
    serviceProviderImage = json['service_provider_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    data['service_provider_adress'] = serviceProviderAdress;
    data['service_provider_image'] = serviceProviderImage;
    return data;
  }
}
