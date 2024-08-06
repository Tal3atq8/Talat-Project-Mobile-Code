class ResendOtpModel {
  String? code;
  String? message;
  List<Result>? result;

  ResendOtpModel({this.code, this.message, this.result});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
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
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? otp;
  String? otpExpireTime;
  String? userId;
  String? token;
  String? userType;

  Result({this.otp, this.otpExpireTime, this.userId, this.token, this.userType});

  Result.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    otpExpireTime = json['otp_expire_time'];
    userId = json['user_id'];
    token = json['token'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['otp_expire_time'] = this.otpExpireTime;
    data['user_id'] = this.userId;
    data['token'] = this.token;
    data['user_type'] = this.userType;
    return data;
  }
}
