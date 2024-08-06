library custom_check_box;

import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  // final Color checkedIconColor;
  // final Color checkedFillColor;
  final String? checkedIcon;
  // final Color uncheckedIconColor;
  // final Color uncheckedFillColor;
  final String? uncheckedIcon;
  final double? borderWidth;
  final double? checkBoxSize;
  final bool shouldShowBorder;
  final Color? borderColor;
  final double? borderRadius;
  final double? splashRadius;
  final Color? splashColor;
  final String? tooltip;
  final MouseCursor? mouseCursors;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.checkedIcon,
    this.uncheckedIcon,
    this.borderWidth,
    this.checkBoxSize,
    this.shouldShowBorder = false,
    this.borderColor,
    this.borderRadius,
    this.splashRadius,
    this.splashColor,
    this.tooltip,
    this.mouseCursors,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late bool _checked;
  late CheckStatus _status;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  void _init() {
    _checked = widget.value;
    if (_checked) {
      _status = CheckStatus.checked;
    } else {
      _status = CheckStatus.unchecked;
    }
  }

  Widget _buildIcon() {
    late String iconData;

    switch (_status) {
      case CheckStatus.checked:
        iconData = widget.checkedIcon!;
        break;
      case CheckStatus.unchecked:
        iconData = widget.uncheckedIcon!;
        break;
    }

    return Container(
      height: 16,
      width: 16,
      padding: EdgeInsets.zero,
      // decoration: BoxDecoration(
      // borderRadius:
      //     BorderRadius.all(Radius.circular(widget.borderRadius ?? 6)),
      // border: Border.all(
      //   color: widget.shouldShowBorder
      //       ? (widget.borderColor ?? Colors.transparent.withOpacity(0.6))
      //       : (!widget.value
      //           ? (widget.borderColor ?? Colors.transparent.withOpacity(0.6))
      //           : Colors.transparent),
      //   width: widget.shouldShowBorder ? widget.borderWidth ?? 0.0 : 0.0,
      // ),
      //     ),
      child: Image.asset(
        iconData,
        // color: iconColor,
        width: widget.checkBoxSize ?? 18,
        height: widget.checkBoxSize ?? 18,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.centerLeft,
      icon: _buildIcon(),
      onPressed: () => widget.onChanged(!_checked),
      splashRadius: widget.splashRadius,
      splashColor: widget.splashColor,
      tooltip: widget.tooltip,
      mouseCursor: widget.mouseCursors ?? SystemMouseCursors.click,
    );
  }
}

enum CheckStatus {
  checked,
  unchecked,
}
