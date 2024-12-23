import 'package:flutter/material.dart';

class ColorList {
  final Color? primary;
  final Color? secondary;
  final Color? labelColor;
  final Color? success;
  final Color? borderColor;
  final Color? ratingColor;
  final Color? customTextColor;
  final Color? bgColor;

  ColorList({this.primary, this.secondary, this.labelColor, this.success, this.borderColor, this.ratingColor, this.customTextColor, this.bgColor});

  factory ColorList.light() {
    return ColorList(
      primary: const Color(0xFFbae5f5),
      secondary: const Color(0xFFE83D3D),
      labelColor: const Color(0xFF6C7584),
      borderColor: const Color(0xFFE5E8EC),
      success: const Color(0xFF007C5A),
      ratingColor: const Color(0xFFF0A500),
      customTextColor: const Color(0xFF1D2F47),
      bgColor: const Color(0xFFbae5f5),
    );
  }

  factory ColorList.dark() {
    return ColorList(
      primary: const Color(0xFFbae5f5),
      secondary: const Color(0xFFE83D3D),
      labelColor: const Color(0xFF6C7584),
      borderColor: const Color(0xFFE5E8EC),
      success: const Color(0xFF007C5A),
      ratingColor: const Color(0xFFF0A500),
      customTextColor: const Color(0xFF1D2F47),
      bgColor: const Color(0xFFbae5f5),
    );
  }
}

class ColorCode {
  static ColorList colorList(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? ColorList.light() : ColorList.dark();
  }
}
