class PayNowSuccessModel {
  final String message;
  final bool status;
  final int code;
  final Result result;

  PayNowSuccessModel({
    required this.message,
    required this.status,
    required this.code,
    required this.result,
  });

  factory PayNowSuccessModel.fromJson(Map<String, dynamic> json) {
    return PayNowSuccessModel(
      message: json["message"],
      status: json["status"],
      code: json["code"],
      result: Result.fromJson(json["result"]),
    );
  }
}

class Result {
  final String paymentUrl;
  dynamic total_amount;
  dynamic commissonPer;

  Result({required this.paymentUrl, this.total_amount, this.commissonPer});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        paymentUrl: json["payment_url"], total_amount: json['total_amount'], commissonPer: json['commisson_per']);
  }
}
