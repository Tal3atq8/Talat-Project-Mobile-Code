class LabelModel {
  String? code;
  String? message;
  String? updatedDate;
  List<LabelResult>? result;

  LabelModel({this.code, this.message, this.updatedDate, this.result});

  LabelModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    updatedDate = json['updated_date'];
    if (json['result'] != null) {
      result = <LabelResult>[];
      json['result'].forEach((v) {
        result!.add(new LabelResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['updated_date'] = this.updatedDate;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabelResult {
  String? key;
  String? valueEn;
  String? valueAr;

  LabelResult({this.key, this.valueEn, this.valueAr});

  LabelResult.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    valueEn = json['value_en'];
    valueAr = json['value_ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value_en'] = this.valueEn;
    data['value_ar'] = this.valueAr;
    return data;
  }
}
