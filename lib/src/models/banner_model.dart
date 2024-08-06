class BannerModel {
  String? code;
  String? message;
  Result? result;

  BannerModel({this.code, this.message, this.result});

  BannerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<BannerData>? bannerData;

  Result({this.bannerData});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['banner_data'] != null) {
      bannerData = <BannerData>[];
      json['banner_data'].forEach((v) {
        bannerData!.add(BannerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (bannerData != null) {
      data['banner_data'] = bannerData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerData {
  String? id;
  String? bannerImage;
  int? itemId;
  String? itemName;
  String? advertisementType;
  dynamic? partner_id;
  ExtraAdvertisementData? extraAdvertisementData;

  BannerData(
      {this.id,
        this.bannerImage,
        this.itemId,
        this.itemName,
        this.partner_id,
        this.advertisementType,
        this.extraAdvertisementData});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerImage = json['banner_image'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    partner_id = json['partner_id'];
    advertisementType = json['advertisement_type'];
    extraAdvertisementData = json['extra_advertisement_data'] != null
        ? ExtraAdvertisementData.fromJson(json['extra_advertisement_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['banner_image'] = bannerImage;
    data['partner_id'] = partner_id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['advertisement_type'] = advertisementType;
    if (extraAdvertisementData != null) {
      data['extra_advertisement_data'] = extraAdvertisementData!.toJson();
    }
    return data;
  }
}

class ExtraAdvertisementData {
  String? id;
 dynamic itemId;
  String? extraItemName;
  String? description;
  String? bannerImage;
  List<String>? advertisementImage;
  String? address;
  dynamic latitude;
  dynamic longitude;

  ExtraAdvertisementData(
      {this.id,
        this.itemId,
        this.extraItemName,
        this.description,
        this.bannerImage,
        this.advertisementImage,
        this.address,
        this.latitude,
        this.longitude});

  ExtraAdvertisementData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    extraItemName = json['extra_item_name'];
    description = json['description'];
    bannerImage = json['banner_image'];
    advertisementImage = json['advertisement_image'].cast<String>();
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['item_id'] = itemId;
    data['extra_item_name'] = extraItemName;
    data['description'] = description;
    data['banner_image'] = bannerImage;
    data['advertisement_image'] = advertisementImage;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}