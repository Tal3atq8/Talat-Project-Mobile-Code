class ServiceList {
  String? code;
  String? message;
  Result? result;

  ServiceList({this.code, this.message, this.result});

  ServiceList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  List<ServicesList>? servicesList;

  Result({this.servicesList});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['services_list'] != null) {
      servicesList = <ServicesList>[];
      json['services_list'].forEach((v) {
        servicesList!.add(new ServicesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.servicesList != null) {
      data['services_list'] = this.servicesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServicesList {
  String? id;
  String? servicesName;

  ServicesList({this.id, this.servicesName});

  ServicesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicesName = json['services_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['services_name'] = this.servicesName;
    return data;
  }
}
