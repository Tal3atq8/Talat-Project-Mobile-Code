class GetCategoryActivityDetailsResponse {
  String? message;
  bool? status;
  int? code;
  Result? result;

  GetCategoryActivityDetailsResponse({this.message, this.status, this.code, this.result});

  GetCategoryActivityDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  ServiceProviderInfo? serviceProviderInfo;
  List<Categories>? categories;
  ActivityDetailItem? activityDetailItem;

  Result({this.serviceProviderInfo, this.categories, this.activityDetailItem});

  Result.fromJson(Map<String, dynamic> json) {
    serviceProviderInfo =
        json['service_providerInfo'] != null ? ServiceProviderInfo.fromJson(json['service_providerInfo']) : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    activityDetailItem = json['item'] != null ? ActivityDetailItem.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceProviderInfo != null) {
      data['service_providerInfo'] = serviceProviderInfo!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (activityDetailItem != null) {
      data['item'] = activityDetailItem!.toJson();
    }
    return data;
  }
}

class ServiceProviderInfo {
  int? serviceProviderId;
  String? serviceProviderName;
  int? serviceProviderNumber;
  String? serviceProviderAdress;
  String? serviceProviderImage;

  ServiceProviderInfo(
      {this.serviceProviderId,
      this.serviceProviderName,
      this.serviceProviderNumber,
      this.serviceProviderAdress,
      this.serviceProviderImage});

  ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderNumber = json['service_provider_number'];
    serviceProviderAdress = json['service_provider_adress'];
    serviceProviderImage = json['service_provider_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    data['service_provider_number'] = serviceProviderNumber;
    data['service_provider_adress'] = serviceProviderAdress;
    data['service_provider_image'] = serviceProviderImage;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? description;
  String? image;

  Categories({this.id, this.name, this.description, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}

class ActivityDetailItem {
  int? itemId;
  String? itemName;
  String? description;
  String? address;
  String? city;
  String? state;
  String? country;
  dynamic initialPrice;
  dynamic discountedPrice;
  String? specialInstruction;
  double? latitude;
  double? longitude;
  String? typeOfActivity;
  List<Images>? images;
  int? noOfPeople;
  dynamic is_location;

  ActivityDetailItem(
      {this.itemId,
      this.itemName,
      this.description,
      this.address,
      this.city,
      this.state,
      this.country,
      this.initialPrice,
      this.discountedPrice,
      this.specialInstruction,
      this.latitude,
      this.longitude,
      this.typeOfActivity,
      this.images,
      this.is_location,
      this.noOfPeople});

  ActivityDetailItem.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    initialPrice = json['initial_price'];
    discountedPrice = json['discounted_price'];
    specialInstruction = json['special_instruction'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    is_location = json['is_location'];
    typeOfActivity = json['type_of_activity'];
    noOfPeople = json['no_of_people'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['description'] = description;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['initial_price'] = initialPrice;
    data['discounted_price'] = discountedPrice;
    data['special_instruction'] = specialInstruction;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['type_of_activity'] = typeOfActivity;
    data['no_of_people'] = noOfPeople;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? imageUrl;

  Images({this.id, this.imageUrl});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}
