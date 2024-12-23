import 'package:agua_task/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextField extends HookWidget {
  final Color? fillColor;
  final double? width;
  final double? height;
  final TextEditingController controller;
  final String hintText;
  final TextStyle? hintTextStyle;
  final String? label;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;
  final Widget? suffix;
  final double? boarderRadius;
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.fillColor,
    this.width,
    this.height,
    required this.controller,
    required this.hintText,
    this.hintTextStyle,
    this.label,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.isPassword = false,
    this.validator,
    this.textInputType,
    this.suffix,
    this.boarderRadius,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    final errorText = useState<String?>(null);

    return SizedBox(
      width: width,
      height: maxLines != null
              ? (((height ?? 44) - 15) * (maxLines ?? 1).toDouble())
              : (height ?? 44)
          ,
      child: TextFormField(
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: ColorCode.colorList(context).customTextColor,
            ),
        maxLines: maxLines ?? 1,
        keyboardType: textInputType,
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword ? obscureText.value : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? Colors.white54,
          hintText: hintText,
          hintStyle: hintTextStyle ??
              Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xffA8B1BE),
                  ),
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodySmall,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(boarderRadius ?? 8),
            borderSide: BorderSide(
              color: Colors.grey[100]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(boarderRadius ?? 8),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(boarderRadius ?? 8),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(boarderRadius ?? 8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(boarderRadius ?? 8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: Colors.red,
              ),
          suffixIcon: suffix ??
              (isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        obscureText.value = !obscureText.value;
                      },
                    )
                  : null),
        ),
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        cursorColor: ColorCode.colorList(context).customTextColor,
        validator: (value) {
          final validationResult = validator?.call(value);
          errorText.value = validationResult;
          return validationResult;
        },
      ),
    );
  }
}
