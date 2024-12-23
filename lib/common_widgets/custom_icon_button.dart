import 'package:agua_task/core/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final Color? buttonColor;
  final Color? iconColor;
  final double? buttonSize;
  final double? iconSize;
  const CustomIconButton({super.key, required this.icon, required this.onTap, this.buttonColor, this.iconColor, this.buttonSize, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: buttonSize ?? 38,
        width: buttonSize ?? 38,
        decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor ?? ColorCode.colorList(context).primary),
        child: Icon(icon, color: iconColor ?? Colors.white, size: iconSize),
      ),
    );
  }
}
