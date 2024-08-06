class ReviewModel {
  const ReviewModel(
      {this.id, this.title,this.desc,this.rate,this.dateTime});

  final int? id;
  final String? title;
  final String? desc;
  final String? rate;
  final String? dateTime;
}
class ReviewListModel {
  String? code;
  String? message;
  List<Result>? result;

  ReviewListModel({this.code, this.message, this.result});

  ReviewListModel.fromJson(Map<String, dynamic> json) {
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
  List<RatingReviewList>? ratingReviewList;

  Result({this.ratingReviewList});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['rating_review_list'] != null) {
      ratingReviewList = <RatingReviewList>[];
      json['rating_review_list'].forEach((v) {
        ratingReviewList!.add(new RatingReviewList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ratingReviewList != null) {
      data['rating_review_list'] =
          this.ratingReviewList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingReviewList {
  dynamic id;
  String? userName;
  num? ratings;
  String? review;
  String? dateTime;

  RatingReviewList(
      {this.id, this.userName, this.ratings, this.review, this.dateTime});

  RatingReviewList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    ratings = json['ratings'];
    review = json['review'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['ratings'] = this.ratings;
    data['review'] = this.review;
    data['date_time'] = this.dateTime;
    return data;
  }
}