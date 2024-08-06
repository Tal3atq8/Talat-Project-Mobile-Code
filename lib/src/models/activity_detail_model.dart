class ActivityDetailModel {
  String? message;
  bool? status;
  int? code;
  ActivityDetailResult? result;

  ActivityDetailModel({this.message, this.status, this.code, this.result});

  ActivityDetailModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    result = json['result'] != null
        ? ActivityDetailResult.fromJson(json['result'])
        : null;
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

class ActivityDetailResult {
  ServiceProviderInfo? serviceProviderInfo;
  List<Categories>? categories;

  ActivityDetailResult({this.serviceProviderInfo, this.categories});

  ActivityDetailResult.fromJson(Map<String, dynamic> json) {
    serviceProviderInfo = json['service_providerInfo'] != null
        ? ServiceProviderInfo.fromJson(json['service_providerInfo'])
        : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceProviderInfo != null) {
      data['service_providerInfo'] = serviceProviderInfo!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceProviderInfo {
  int? serviceProviderId;
  String? serviceProviderName;
  String? serviceProviderAdress;
  String? serviceProviderImage;
  List<Gallary>? gallary;

  ServiceProviderInfo(
      {this.serviceProviderId,
      this.serviceProviderName,
      this.serviceProviderAdress,
      this.serviceProviderImage,
      this.gallary});

  ServiceProviderInfo.fromJson(Map<String, dynamic> json) {
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderAdress = json['service_provider_adress'];
    serviceProviderImage = json['service_provider_image'];
    if (json['gallary'] != null ) {
      gallary = <Gallary>[];
      json['gallary'].forEach((v) {
        gallary!.add(Gallary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    data['service_provider_adress'] = serviceProviderAdress;
    data['service_provider_image'] = serviceProviderImage;
    if (gallary != null) {
      data['gallary'] = gallary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gallary {
  int? id;
  String? imageUrl;

  Gallary({this.id, this.imageUrl});

  Gallary.fromJson(Map<String, dynamic> json) {
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

class Categories {
  int? id;
  String? name;
  String? nameAr;
  String? description;
  String? descriptionAr;
  String? image;
  List<ActivityDetailItemList>? item;

  Categories(
      {this.id,
      this.name,
      this.nameAr,
      this.description,
      this.descriptionAr,
      this.image,
      this.item});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr = json['name_ar'];
    description = json['description'];
    descriptionAr = json['description_ar'];
    image = json['image'];
    if (json['item'] != null) {
      item = <ActivityDetailItemList>[];
      json['item'].forEach((v) {
        item!.add(ActivityDetailItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_ar'] = nameAr;
    data['description'] = description;
    data['description_ar'] = descriptionAr;
    data['image'] = image;
    if (item != null) {
      data['item'] = item!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivityDetailItemList {
  String? isChecked;
  int? itemId;
  String? itemName;
  String? description;
  String? address;
  String? city;
  String? state;
  String? country;
  int? initialPrice;
  int? discountedPrice;
  String? specialInstructions;
  String? typeOfActivity;
  int? capacityOfTheActivity;
  List<Images>? images;

  ActivityDetailItemList(
      {this.isChecked,
      this.itemName,
        this.itemId,
      this.description,
      this.address,
      this.city,
      this.state,
      this.country,
      this.initialPrice,
      this.discountedPrice,
      this.specialInstructions,
      this.typeOfActivity,
      this.capacityOfTheActivity,
      this.images});

  ActivityDetailItemList.fromJson(Map<String, dynamic> json) {
    isChecked = json['is_checked'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    initialPrice = json['initial_price'];
    discountedPrice = json['discounted_price'];
    specialInstructions = json['special_instructions'];
    typeOfActivity = json['type_of_activity'];
    capacityOfTheActivity = json['capacity_of_the_activity'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_checked'] = isChecked;
    data['item_name'] = itemName;
    data['item_id'] = itemId;
    data['description'] = description;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['initial_price'] = initialPrice;
    data['discounted_price'] = discountedPrice;
    data['special_instructions'] = specialInstructions;
    data['type_of_activity'] = typeOfActivity;
    data['capacity_of_the_activity'] = capacityOfTheActivity;
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
