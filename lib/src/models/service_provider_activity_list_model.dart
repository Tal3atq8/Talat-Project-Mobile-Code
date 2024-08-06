class ServiceProviderActivityListResponse {
  String? message;
  bool? status;
  int? code;
  Result? result;

  ServiceProviderActivityListResponse(
      {this.message, this.status, this.code, this.result});

  ServiceProviderActivityListResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
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
  ItemList? itemList;

  Result({this.itemList});

  Result.fromJson(Map<String, dynamic> json) {
    itemList = json['item_list'] != null
        ? ItemList.fromJson(json['item_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (itemList != null) {
      data['item_list'] = itemList!.toJson();
    }
    return data;
  }
}

class ItemList {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  ItemList(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ItemList.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
  int? id;
  String? categoryName;
  String? categoryAddress;
  String? categoryDistance;
  num? categoryAmount;
  String? categoryImage;
  String? serviceProviderImage;
  int? serviceProviderId;
  String? serviceProviderName;
  String? serviceProviderAddress;
  int? isFav;

  Data(
      {this.id,
        this.categoryName,
        this.categoryAddress,
        this.categoryDistance,
        this.categoryAmount,
        this.categoryImage,
        this.serviceProviderImage,
        this.serviceProviderId,
        this.serviceProviderName,
        this.serviceProviderAddress,
        this.isFav});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryAddress = json['category_address'];
    categoryDistance = json['category_distance'];
    categoryAmount = json['category_amount'];
    categoryImage = json['category_image'];
    serviceProviderImage = json['service_provider_image'];
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderAddress = json['service_provider_address'];
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_address'] = categoryAddress;
    data['category_distance'] = categoryDistance;
    data['category_amount'] = categoryAmount;
    data['category_image'] = categoryImage;
    data['service_provider_image'] = serviceProviderImage;
    data['service_provider_id'] = serviceProviderId;
    data['service_provider_name'] = serviceProviderName;
    data['service_provider_address'] = serviceProviderAddress;
    data['is_fav'] = isFav;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
