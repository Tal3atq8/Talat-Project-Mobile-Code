import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talat/src/theme/color_constants.dart';

import '../utils/size_utils.dart';

class GrayCustomTextFormField extends StatelessWidget {
  GrayCustomTextFormField({
    this.shape,
    this.padding,
    this.variant,
    this.onTapEvent,
    this.fontStyle,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    // this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.prefix,
    this.counterText,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.validator,
    this.readOnly = false,
    this.inputFormatters,
  });

  TextFormFieldShape? shape;

  TextFormFieldPadding? padding;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;

  // FocusNode? focusNode;
  GestureTapCallback? onTapEvent;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  int? maxLength;

  String? hintText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  bool? readOnly;

  String? counterText;

  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: getHorizontalSize(width ?? 0),
      margin: margin,
      child: TextFormField(
        controller: controller,
        onTap: onTapEvent,
        // focusNode: focusNode,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: _buildDecoration(),
        validator: validator,
        readOnly: readOnly!,
        inputFormatters: inputFormatters,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      focusedErrorBorder: _setBorderStyle(),
      errorBorder: _setBorderStyle(),
      prefixIcon: prefix,
      counterText: counterText,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(
          color: ColorConstant.grayTextFormFieldTextColor,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      default:
        return ColorConstant.grayTextFormFieldColor;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.None:
        return false;
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT13:
        return getPadding(
          left: 2,
          top: 20,
          bottom: 13,
        );
      default:
        return getPadding(
          left: 2,
          top: 4,
          right: 12,
          bottom: 4,
        );
    }
  }
}

enum TextFormFieldShape {
  CircleBorder24,
}

enum TextFormFieldPadding {
  PaddingT14,
  PaddingT13,
}

enum TextFormFieldVariant {
  None,
  OutlineGray40066,
}

enum TextFormFieldFontStyle {
  OutfitRegular14,
}
