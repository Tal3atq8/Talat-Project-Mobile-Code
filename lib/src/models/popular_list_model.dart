class PopularListModel {
  String? code;
  String? message;
  Result? result;

  PopularListModel({this.code, this.message, this.result});

  PopularListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<PopularList>? popularList;

  Result({this.popularList});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['popular_list'] != null) {
      popularList = <PopularList>[];
      json['popular_list'].forEach((v) {
        popularList!.add(PopularList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (popularList != null) {
      data['popular_list'] = popularList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PopularList {
  dynamic id;
  dynamic providerId;
  dynamic providerName;
  dynamic address;
  dynamic amount;
  dynamic serviceProviderImage;
  dynamic itemImage;
  dynamic activityName;
  dynamic distance;
  dynamic isFav;

  PopularList(
      {this.id,
      this.providerId,
      this.providerName,
      this.address,
      this.amount,
      this.serviceProviderImage,
      this.itemImage,
      this.activityName,
      this.distance,
      this.isFav});

  PopularList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    address = json['address'];
    amount = json['amount'];
    serviceProviderImage = json['service_provider_image'];
    itemImage = json['item_image'];
    distance = json['distance'];
    activityName = json['activity_name'];
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['address'] = address;
    data['amount'] = amount;
    data['service_provider_image'] = serviceProviderImage;
    data['item_image'] = itemImage;
    data['distance'] = distance;
    data['activity_name'] = activityName;
    data['is_fav'] = isFav;
    return data;
  }
}
