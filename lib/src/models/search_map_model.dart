class MapModel {
  String? code;
  String? message;
  List<MapResult>? result;

  MapModel({this.code, this.message, this.result});

  MapModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <MapResult>[];
      json['result'].forEach((v) {
        result!.add(MapResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MapResult {
  String? id;
  String? address;
  String? activity_name;
  String? amount;
  String? itemImage;
  String? main_image;
  String? latitude;
  String? longitude;
  String? distance;
  String? providerId;
  String? providerName;
  String? serviceProviderImage;
  int? isFav;

  MapResult(
      {this.id,
      this.address,
      this.amount,
      this.itemImage,
      this.latitude,
      this.longitude,
      this.distance,
      this.providerId,
        this.activity_name,
        this.main_image,
      this.providerName,
      this.serviceProviderImage,
      this.isFav});

  MapResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    amount = json['amount'];
    itemImage = json['item_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    main_image = json['main_image'];
    activity_name = json['activity_name'];
    distance = json['distance'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    serviceProviderImage = json['service_provider_image'];
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['address'] = address;
    data['amount'] = amount;
    data['item_image'] = itemImage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['activity_name'] = activity_name;
    data['distance'] = distance;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['service_provider_image'] = serviceProviderImage;
    data['is_fav'] = isFav;
    return data;
  }
}
