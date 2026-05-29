import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mevtech/core/utils/colors.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.enabled,
    this.filled,
    this.fillColor,
    this.counter,
    this.onTap,
    this.showCursor,
    this.validator,
    this.maxLength,
    this.counterText = '',
    this.onChanged,
    this.isDense = true,
  });

  final String hintText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool? enabled;
  final Widget? counter;
  final bool? filled;
  final Color? fillColor;
  final void Function()? onTap;
  final bool? showCursor;
  final String? Function(String?)? validator;
  final int? maxLength;
  final String? counterText;
  final void Function(String)? onChanged;
  final bool? isDense;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.grey,
      cursorHeight: 15,
      readOnly: readOnly,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      showCursor: showCursor,
      inputFormatters: inputFormatters,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        counterText: counterText,
        isDense: isDense,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black38,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counter: counter,
        filled: filled,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
      ),
      maxLength: maxLength,
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
