class CmsModel {
  String? code;
  String? message;
  List<Result>? result;

  CmsModel({this.code, this.message, this.result});

  CmsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  String? cmsTitle;
  String? cmsDescription;

  Result({this.id, this.cmsTitle, this.cmsDescription});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cmsTitle = json['cms_title'];
    cmsDescription = json['cms_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['cms_title'] = cmsTitle;
    data['cms_description'] = cmsDescription;
    return data;
  }
}