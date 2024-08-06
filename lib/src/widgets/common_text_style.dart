import 'package:flutter/material.dart';

import '../theme/color_constants.dart';

TextStyle txtStyleNormalBlack14() {
  return TextStyle(
      color: ColorConstant.blackColor,
      fontSize: 14,
      fontWeight: FontWeight.w400);
}

TextStyle txtStyleNormalBlack10() {
  return const TextStyle(
      fontSize: 10, color: Colors.black, fontWeight: FontWeight.normal);
}

TextStyle txtStyleTitleBoldBlack18() {
  return TextStyle(
      color: ColorConstant.blackColor,
      fontSize: 18,
      fontWeight: FontWeight.bold);
}

TextStyle txtStyleTitleBoldBlack20() {
  return TextStyle(
      color: ColorConstant.blackColor,
      fontSize: 20,
      fontWeight: FontWeight.bold);
}

TextStyle txtStyleTitleBoldBlack20w300() {
  return TextStyle(
      color: ColorConstant.blackColor,
      fontSize: 20,
      fontWeight: FontWeight.w300);
}

TextStyle txtStyleTitleBoldBlack14(
    {Color? color, TextDecoration? textDecoration}) {
  return TextStyle(
      color: color ?? ColorConstant.blackColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      decoration: textDecoration);
}

TextStyle txtStyleTitleValueGray14({Color? color}) {
  return TextStyle(
      color: color ?? ColorConstant.blackColor,
      fontSize: 14,
      fontWeight: FontWeight.bold);
}

TextStyle hintGray14({Color? color}) {
  return TextStyle(
    color: color ?? ColorConstant.grayBorderColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}

TextStyle txtStyleTitleBoldBlack16({Color? color}) {
  return TextStyle(
      color: color ?? ColorConstant.blackColor,
      fontSize: 16,
      fontWeight: FontWeight.bold);
}

TextStyle txtStyleTextStyleGreen14() {
  return TextStyle(
      color: ColorConstant.greenColor,
      fontSize: 14,
      fontWeight: FontWeight.normal);
}

TextStyle txtStyleTextStyleGreen12() {
  return TextStyle(
      color: ColorConstant.greenColor,
      fontSize: 12,
      fontWeight: FontWeight.normal);
}

TextStyle textStyleGreen12() {
  return TextStyle(
      color: ColorConstant.greenColor,
      fontSize: 12,
      fontWeight: FontWeight.normal);
}

TextStyle txtStyleTitleBoldBlack12({Color? color}) {
  return TextStyle(
      color: color ?? ColorConstant.blackColor,
      fontSize: 12,
      fontWeight: FontWeight.bold);
}

TextStyle txtStyleNormalGray14({Color? color}) {
  return TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: color ?? ColorConstant.darkGrayColor,
  );
}

TextStyle txtStyleNormalLightGray14() {
  return TextStyle(
    color: ColorConstant.grayTextFormFieldTextColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

TextStyle txtStyleNormalGray12({Color? color}) {
  return TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: color ?? ColorConstant.darkGrayColor,
  );
}

TextStyle txtStyleTitleNormalBlack16() {
  return TextStyle(fontWeight: FontWeight.normal, fontSize: 16);
}
