class UserDetailModel {
  String? code;
  String? message;
  List<Result>? result;

  UserDetailModel({this.code, this.message, this.result});

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  dynamic userId;
  dynamic name;
  dynamic email;
  dynamic password;
  dynamic isRegister;
  dynamic dob;
  dynamic notificationStatus;
  dynamic gender;
  dynamic mobileNo;
  dynamic countryCode;
  dynamic countryImageUrl;
  dynamic userType;
  dynamic isMobileVerified;
  dynamic otp;
  dynamic otpExpireTime;
  dynamic languageId;
  dynamic token;
  String? providerRequestStatus;
  String? providerRequestAccept;
  List<SelectedServies>? selectedServies;

  Result(
      {this.userId,
      this.name,
      this.email,
      this.password,
      this.isRegister,
      this.dob,
      this.providerRequestStatus,
      this.providerRequestAccept,
      this.gender,
      this.mobileNo,
      this.countryCode,
      this.countryImageUrl,
      this.userType,
      this.isMobileVerified,
      this.otp,
      this.otpExpireTime,
      this.languageId,
      this.token,
      this.selectedServies});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    notificationStatus = json['notification_status'];
    isRegister = json['is_register'];
    dob = json['dob'];
    gender = json['gender'];
    mobileNo = json['mobile_no'];
    providerRequestStatus = json['provider_request_status'];
    providerRequestAccept = json['provider_request_accept'];
    countryCode = json['country_code'];
    countryImageUrl = json['country_image_url'];
    userType = json['user_type'];
    isMobileVerified = json['is_mobile_verified'];
    otp = json['otp'];
    otpExpireTime = json['otp_expire_time'];
    languageId = json['language_id'];
    token = json['token'];
    if (json['selected_servies'] != null) {
      selectedServies = <SelectedServies>[];
      json['selected_servies'].forEach((v) {
        selectedServies!.add(SelectedServies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['notification_status'] = email;
    data['password'] = password;
    data['is_register'] = isRegister;
    data['dob'] = dob;
    data['gender'] = gender;
    data['mobile_no'] = mobileNo;
    data['country_code'] = countryCode;
    data['country_image_url'] = countryImageUrl;
    data['user_type'] = userType;
    data['is_mobile_verified'] = isMobileVerified;
    data['provider_request_status'] = providerRequestStatus;
    data['provider_request_accept'] = providerRequestAccept;
    data['otp'] = otp;
    data['otp_expire_time'] = otpExpireTime;
    data['language_id'] = languageId;
    data['token'] = token;
    if (selectedServies != null) {
      data['selected_servies'] = selectedServies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
//   if (this.selectedServies != null) {
//     data['selected_servies'] =
//         this.selectedServies!.map((v) => v.toJson()).toList();
//   }
//   return data;
// }
}

class SelectedServies {
  dynamic id;
  dynamic name;

  SelectedServies({this.id, this.name});

  SelectedServies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
