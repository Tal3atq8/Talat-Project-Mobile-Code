class SearchModel {
  String? message;
  bool? status;
  int? code;
  List<SearchModelResult>? result;

  SearchModel({this.message, this.status, this.code, this.result});

  SearchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    code = json['code'];
    if (json['result'] != null) {
      result = <SearchModelResult>[];
      json['result'].forEach((v) {
        result!.add(new SearchModelResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchModelResult {
  int? id;
  String? name;
  dynamic initialPrice;
  String? type;
  int? userId;
  String? userName;
  String? address;
  String? providerPhoto;
  String? itemImage;
  String? nameAr;
  String? profilePhoto;

  SearchModelResult(
      {this.id,
      this.name,
      this.initialPrice,
      this.type,
      this.userId,
      this.userName,
      this.address,
      this.providerPhoto,
      this.itemImage,
      this.nameAr,
      this.profilePhoto});

  SearchModelResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    initialPrice = json['initial_price'];
    type = json['type'];
    userId = json['user_id'];
    userName = json['user_name'];
    address = json['address'];
    providerPhoto = json['provider_photo'];
    itemImage = json['item_image'];
    nameAr = json['name_ar'];
    profilePhoto = json['profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['initial_price'] = initialPrice;
    data['type'] = type;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['address'] = address;
    data['provider_photo'] = providerPhoto;
    data['item_image'] = itemImage;
    data['name_ar'] = nameAr;
    data['profile_photo'] = profilePhoto;
    return data;
  }
}
