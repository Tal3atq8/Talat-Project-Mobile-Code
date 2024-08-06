import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/enums/enum.dart';

class AlertWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final List<String>? buttonOption;
  final AlertWidgetButtonActionCallback? onCompletion;

  AlertWidget({this.title, this.message, this.buttonOption, this.onCompletion});

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  Widget? get titleWidget {
    String mainTitle = this.widget.title ?? '';
    if (mainTitle.length == 0) {
      mainTitle = ConstantStrings.appName ?? '';
    }

    if (Platform.isIOS) {
      if (mainTitle.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              mainTitle,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: ColorConstant.blackColor,
                fontSize: 17,
              ),
            ),
          ),
        );
      }
    } else if (Platform.isAndroid) {
      if (mainTitle.isNotEmpty) {
        return Text(
          mainTitle,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: ColorConstant.blackColor,
          ),
          textAlign: TextAlign.left,
        );
      }
    }
    return null;
  }

  Widget? get messageWidget {
    if ((widget.message ?? '').isNotEmpty) {
      var messageW = Text(
        widget.message ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: ColorConstant.blackColor,
        ),
      );
      return (Platform.isIOS)
          ? messageW
          : Padding(
              child: messageW,
              padding: EdgeInsets.only(top: 10.0),
            );
    }
    return null;
  }

  List<Widget> get actionWidgert {
    List<Widget> arrButtons = [];

    for (String str in (widget.buttonOption ?? [])) {
      Widget button;
      if (Platform.isIOS) {
        button = CupertinoDialogAction(
          isDestructiveAction: str.toLowerCase() == ("Cancel").toLowerCase(),
          child: Text(
            str,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: ColorConstant.blackColor,
            ),
          ),
          onPressed: () => this.onButtonPressed(str),
        );
      } else {
        button = TextButton(
          child: Text(
            str,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: ColorConstant.blackColor,
            ),
          ),
          onPressed: () => this.onButtonPressed(str),
        );
      }
      arrButtons.add(button);
    }
    return arrButtons;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: this.titleWidget,
        content: this.messageWidget,
        actions: actionWidgert,
      );
    } else {
      return AlertDialog(
        title: this.titleWidget,
        content: this.messageWidget,
        actions: actionWidgert,
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24.0, 7.0, 20.0, 12.0),
      );
    }
  }

  void onButtonPressed(String btnTitle) {
    int index = (widget.buttonOption ?? []).indexOf(btnTitle);

    //dismiss Diloag
    Navigator.of(context).pop();

    // Provide callback
    if (widget.onCompletion != null) {
      widget.onCompletion!(index);
    }
  }
}
