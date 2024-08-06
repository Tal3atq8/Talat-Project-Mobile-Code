import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/widgets/common_text_style.dart';

import '../utils/size_utils.dart';

class SearchTextFormField extends StatelessWidget {
  SearchTextFormField({
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.onChanged,
    this.onTap,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.hintText,
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
  ValueChanged<String>? onChanged;
  Function()? onTap;
  ValueChanged<String>? onSubmit;
  TextEditingController? controller;

  FocusNode? focusNode;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  int? maxLength;

  String? hintText;

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
        onChanged: onChanged,
        onTap: onTap,
        focusNode: focusNode,
        style: _setFontTextStyle(),
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
      prefixIcon: _setPrefix(),
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
        return txtStyleNormalLightGray14();
    }
  }

  _setFontTextStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(
          color: ColorConstant.blackColor,
          fontSize: getFontSize(
            14,
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
            6.00,
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
          top: 6,
          bottom: 6,
        );
      default:
        return getPadding(
          left: 2,
          top: 0,
          right: 12,
          bottom: 0,
        );
    }
  }

  _setPrefix() {
    return Icon(
      Icons.search,
      size: 20,
      color: ColorConstant.grayTextFormFieldTextColor,
    );
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
