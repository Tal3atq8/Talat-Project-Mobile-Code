class CategoryItemModel {
  String? message;
  bool? status;
  int? code;
  Result? result;

  CategoryItemModel({this.message, this.status, this.code, this.result});

  CategoryItemModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['code'] = this.code;
    if (result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  ItemList? itemList;

  Result({this.itemList});

  Result.fromJson(Map<String, dynamic> json) {
    itemList = json['item_list'] != null ? new ItemList.fromJson(json['item_list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.itemList != null) {
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
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
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
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  String? categoryName;
  String? categoryAddress;
  dynamic categoryDistance;
  num? categoryAmount;
  String? categoryImage;
  String? main_image;
  String? serviceProviderImage;
  dynamic serviceProviderId;
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
      this.main_image,
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
    main_image = json['main_image'];
    serviceProviderImage = json['service_provider_image'];
    serviceProviderId = json['service_provider_id'];
    serviceProviderName = json['service_provider_name'];
    serviceProviderAddress = json['service_provider_address'];
    isFav = json['is_fav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['category_address'] = this.categoryAddress;
    data['category_distance'] = this.categoryDistance;
    data['category_amount'] = this.categoryAmount;
    data['category_image'] = this.categoryImage;
    data['main_image'] = this.main_image;
    data['service_provider_image'] = this.serviceProviderImage;
    data['service_provider_id'] = this.serviceProviderId;
    data['service_provider_name'] = this.serviceProviderName;
    data['service_provider_address'] = this.serviceProviderAddress;
    data['is_fav'] = this.isFav;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
