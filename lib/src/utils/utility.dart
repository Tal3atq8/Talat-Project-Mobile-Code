import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:talat/src/utils/enums/enum.dart';
import 'package:talat/src/utils/global_constants.dart' as globals;
import 'package:talat/src/widgets/alert_box.dart';
import 'package:url_launcher/url_launcher.dart';

String toLabelValue(String key) {
  var str = "";

  for (var element in globals.labelResult) {
    if (element.key.toString().removeAllWhitespace == key.removeAllWhitespace) {
      if (globals.language == "1") {
        str = element.valueEn ?? '';
      } else {
        str = element.valueAr ?? '';
      }
    }
  }
  if (str.isEmpty) {
    for (var element in globals.labelResult) {
      if (element.key.toString().removeAllWhitespace == 'something_went_wrong') {
        if (globals.language == "1") {
          str = element.valueEn ?? '';
        } else {
          str = element.valueAr ?? '';
        }
      }
    }
  }
  return str;
}

class Logger {
  static showAlert(
      {String? title,
      String? message,
      List<String>? arrButton,
      bool barrierDismissible = true,
      AlertWidgetButtonActionCallback? callback}) {
    Widget alertDialog = AlertWidget(title: title, message: message, buttonOption: arrButton, onCompletion: callback);

    if (!barrierDismissible) {
      alertDialog = WillPopScope(
        child: alertDialog,
        onWillPop: () async {
          return false;
        },
      );
    }
  }

  static Future handleLaunchCall(dynamic data) async {
    try {
      if (data is String) {
        final Uri callLaunchUri = Uri(
          scheme: 'tel',
          path: '$data',
        );

        await launch(callLaunchUri.toString());
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future handleLaunchEmail(dynamic data) async {
    try {
      if (data is String) {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: '$data',
        );

        await launch(emailLaunchUri.toString());
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future handleUrlOpen(dynamic data) async {
    try {
      if (data is String) {
        if (!await launchUrl(
          Uri.parse(data),
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $data');
        }
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      // Logger().e("Exception :: ${e.toString()}");
    }
  }
}

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 ${toLabelValue("week_ago")}' : toLabelValue("last_week");
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ${toLabelValue("days_ago")}';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 ${toLabelValue("day_ago")}' : toLabelValue("yesterday");
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ${toLabelValue("hours_ago")}';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 ${toLabelValue("hour_ago")}' : toLabelValue("an_hour_ago");
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ${toLabelValue("minutes_ago")}';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 ${toLabelValue("minute_ago")}' : toLabelValue("a_minute_ago");
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${toLabelValue("seconds_ago")}';
    } else {
      return toLabelValue("just_now");
    }
  }
}

//Formatter For initial Space
class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}
