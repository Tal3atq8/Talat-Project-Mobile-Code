import 'package:flutter/material.dart';

class ColorConstant {
  static Color appThemeColor = fromHex('#F21F0C');
  static Color whiteColor = fromHex('#FFFFFF');
  static Color grayColor = fromHex('#726a6a');
  static Color grayTextColor = fromHex('#5D5D5D');
  static Color lightGrayColor = fromHex('#D1D1D6');
  static Color darkGrayColor = fromHex('#707070');
  static Color blackColor = fromHex('#000000');
  static Color lightTextGrayColor = fromHex('#BBBBBB');
  static Color greenColor = fromHex('#35C759');
  static Color grayBorderColor = fromHex('#AEAEB2');
  static Color grayListDataColor = fromHex('#6A6A6A');
  static Color grayLightListDataColor = fromHex('#6A6A6A');
  static Color grayDarkDataColor = fromHex('#6A6A6A');
  static Color grayTextFormFieldColor = fromHex('#EFEFEF');
  static Color whiteBackgroundColor = fromHex('#FAFAFA');
  static Color grayTextFormFieldTextColor = fromHex('#AFAFAF');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
