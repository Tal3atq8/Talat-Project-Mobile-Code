class EditProfileMode {
  String? code;
  String? message;
  List<Result>? result;
  User? user;

  EditProfileMode({this.code, this.message, this.result, this.user});

  EditProfileMode.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Result {
  String? userId;
  String? token;
  List<SelectedServies>? selectedServies;

  Result({this.userId, this.token, this.selectedServies});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    token = json['token'];
    if (json['selected_servies'] != null) {
      selectedServies = <SelectedServies>[];
      json['selected_servies'].forEach((v) {
        selectedServies!.add(new SelectedServies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['token'] = this.token;
    if (this.selectedServies != null) {
      data['selected_servies'] =
          this.selectedServies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedServies {
  String? id;
  String? name;

  SelectedServies({this.id, this.name});

  SelectedServies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class User {
  dynamic? id;
  dynamic? userType;
  String? name;
  String? email;
  String? phoneCode;
  dynamic? phone;
  String? profilePhoto;
  String? countryImageUrl;
  String? dateOfBirth;
  String? gender;
  int? deviceType;
  String? otp;
  String? otpExpireTime;
  int? isOtpVerify;
  int? serviceId;
  String? businessInfo;
  String? emailVerifiedAt;
  int? loginType;
  String? authId;
  int? isActive;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? isVerified;
  String? deviceToken;

  User(
      {this.id,
      this.userType,
      this.name,
      this.email,
      this.phoneCode,
      this.phone,
      this.profilePhoto,
      this.countryImageUrl,
      this.dateOfBirth,
      this.gender,
      this.deviceType,
      this.otp,
      this.otpExpireTime,
      this.isOtpVerify,
      this.serviceId,
      this.businessInfo,
      this.emailVerifiedAt,
      this.loginType,
      this.authId,
      this.isActive,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isVerified,
      this.deviceToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    name = json['name'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phone = json['phone'];
    profilePhoto = json['profile_photo'];
    countryImageUrl = json['country_image_url'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    deviceType = json['device_type'];
    otp = json['otp'];
    otpExpireTime = json['otp_expire_time'];
    isOtpVerify = json['is_otp_verify'];
    serviceId = json['service_id'];
    businessInfo = json['business_info'];
    emailVerifiedAt = json['email_verified_at'];
    loginType = json['login_type'];
    authId = json['auth_id'];
    isActive = json['is_active'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    isVerified = json['is_verified'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['phone'] = this.phone;
    data['profile_photo'] = this.profilePhoto;
    data['country_image_url'] = this.countryImageUrl;
    data['date_of_birth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['device_type'] = this.deviceType;
    data['otp'] = this.otp;
    data['otp_expire_time'] = this.otpExpireTime;
    data['is_otp_verify'] = this.isOtpVerify;
    data['service_id'] = this.serviceId;
    data['business_info'] = this.businessInfo;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['login_type'] = this.loginType;
    data['auth_id'] = this.authId;
    data['is_active'] = this.isActive;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['is_verified'] = this.isVerified;
    data['device_token'] = this.deviceToken;
    return data;
  }
}
