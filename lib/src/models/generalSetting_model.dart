class GeneralSettingModel {
  String? code;
  String? message;
  List<Result>? result;

  GeneralSettingModel({this.code, this.message, this.result});

  GeneralSettingModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? currency;
  int? countryCode;
  String? noData;
  String? passwordMinCount;
  String? otpTimerSeconds;
  String? contactUsEmail;
  String? contactUsMobileNo;
  String? contactUsAddress;
  Null latitude;
  Null longitude;
  String? instagramLink;
  String? facebookLink;
  String? twitterLink;
  String? youtubeLink;
  String? whatsappLink;

  Result(
      {this.currency,
      this.countryCode,
      this.noData,
      this.passwordMinCount,
      this.otpTimerSeconds,
      this.contactUsEmail,
      this.contactUsMobileNo,
      this.contactUsAddress,
      this.latitude,
      this.longitude,
      this.instagramLink,
      this.facebookLink,
      this.twitterLink,
      this.youtubeLink,
      this.whatsappLink});

  Result.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    countryCode = json['country_code'];
    noData = json['no_data'];
    passwordMinCount = json['password_min_count'];
    otpTimerSeconds = json['otp_timer_seconds'];
    contactUsEmail = json['contact_us_email'];
    contactUsMobileNo = json['contact_us_mobile_no'];
    contactUsAddress = json['contact_us_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    instagramLink = json['instagram_link'];
    facebookLink = json['facebook_link'];
    twitterLink = json['twitter_link'];
    youtubeLink = json['youtube_link'];
    whatsappLink = json['whatsapp_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['country_code'] = this.countryCode;
    data['no_data'] = this.noData;
    data['password_min_count'] = this.passwordMinCount;
    data['otp_timer_seconds'] = this.otpTimerSeconds;
    data['contact_us_email'] = this.contactUsEmail;
    data['contact_us_mobile_no'] = this.contactUsMobileNo;
    data['contact_us_address'] = this.contactUsAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['instagram_link'] = this.instagramLink;
    data['facebook_link'] = this.facebookLink;
    data['twitter_link'] = this.twitterLink;
    data['youtube_link'] = this.youtubeLink;
    data['whatsapp_link'] = this.whatsappLink;
    return data;
  }
}
