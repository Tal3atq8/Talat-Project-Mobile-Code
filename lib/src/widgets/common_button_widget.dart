import 'package:flutter/material.dart';
import 'package:talat/src/theme/color_constants.dart';

class ButtonWidget extends StatelessWidget {
  final String title;

  final VoidCallback? onPressed;
  final Color btnColor;
  final Color txtColor;
  final FontWeight fontWeight;
  final double fontSize;

  const ButtonWidget(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.btnColor,
      required this.fontSize,
      required this.fontWeight,
      required this.txtColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(btnColor),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return ColorConstant.appThemeColor.withOpacity(0.1); //<-- SEE HERE
            }
            return null; // Defer to the widget's default.
          },
        ),
        elevation: const WidgetStatePropertyAll(0),
        // disabledBackgroundColor: btnColorRed.withOpacity(0.4),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: txtColor,
        ),
      ),
    );
  }
}
