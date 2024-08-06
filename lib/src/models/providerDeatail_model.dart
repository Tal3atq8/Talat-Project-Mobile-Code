import 'activity_detail_model.dart';

class ProviderDetailModel {
  String? message;
  bool? status;
  int? code;
  Result? result;

  ProviderDetailModel({this.message, this.status, this.code, this.result});

  ProviderDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? serviceProviderId;
  String? serviceProviderName;
  String? serviceProviderAdress;
  String? aboutBusiness;
  String? activityImage;
  String? serviceProviderEmail;
  dynamic? serviceProviderPhone;
  dynamic? distance;
  List<Gallary>? gallary;
  List<Review>? review;

  Result(
      {this.serviceProviderId,
      this.serviceProviderName,
      this.serviceProviderAdress,
      this.serviceProviderPhone,
      this.aboutBusiness,
      this.activityImage,
      this.distance,
      this.serviceProviderEmail,
      this.gallary,
      this.review});

  Result.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_providerId'];
    serviceProviderName = json['service_providerName'];
    serviceProviderAdress = json['service_providerAdress'];
    aboutBusiness = json['about_business'];
    activityImage = json['activity_image'];
    serviceProviderEmail = json['service_providerEmail'];
    serviceProviderPhone = json['service_providerPhone'];
    distance = json['distance'];
    if (json['gallary'] != null) {
      gallary = <Gallary>[];
      json['gallary'].forEach((v) {
        gallary!.add(Gallary.fromJson(v));
      });
    }
    if (json['review'] != null) {
      review = <Review>[];
      json['review'].forEach((v) {
        review!.add(Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_providerId'] = serviceProviderId;
    data['service_providerName'] = serviceProviderName;
    data['service_providerAdress'] = serviceProviderAdress;
    data['about_business'] = aboutBusiness;
    data['service_providerEmail'] = serviceProviderEmail;
    data['service_providerPhone'] = serviceProviderPhone;
    data['activity_image'] = activityImage;
    data['distance'] = distance;
    if (gallary != null) {
      data['gallary'] = gallary!.map((v) => v.toJson()).toList();
    }
    if (review != null) {
      data['review'] = review!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  String? customerName;
  int? itemName;
  int? providerName;
  num? ratings;
  String? review;
  String? createdAt;

  Review(
      {this.customerName,
      this.itemName,
      this.providerName,
      this.ratings,
      this.review,
      this.createdAt});

  Review.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    itemName = json['item_name'];
    providerName = json['provider_name'];
    ratings = json['ratings'];
    review = json['review'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['item_name'] = itemName;
    data['provider_name'] = providerName;
    data['ratings'] = ratings;
    data['review'] = review;
    data['created_at'] = createdAt;
    return data;
  }
}
