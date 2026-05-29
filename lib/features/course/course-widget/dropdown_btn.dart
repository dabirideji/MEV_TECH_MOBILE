import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mevtech/core/utils/colors.dart';

class DropdownBtn extends StatelessWidget {
  const DropdownBtn({
    required this.items,
    super.key,
    this.value,
    this.hint,
    this.onChanged,
  });

  final int? value;
  final List<int> items;
  final String? hint;
  final void Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.primaryLight1,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isDense: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          hint: Text(
            hint ?? '',
            style: TextStyle(fontSize: 12.sp),
          ),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          value: value,
          items: items.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value',
                style: TextStyle(fontSize: 13.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class MyDropdownButton extends StatelessWidget {
  const MyDropdownButton({
    required this.items,
    super.key,
    this.value,
    this.hint,
    this.onChanged,
  });

  final String? value;
  final List<String> items;
  final String? hint;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // dropdownColor: Colors.red.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          hint: Text(hint ?? ''),
          menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
          value: value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 13.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          // disabledHint: Text(value),
        ),
      ),
    );
  }
}

class CustomDropdownButton extends StatelessWidget {
  const CustomDropdownButton({
    required this.items,
    super.key,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.enabled = true,
  });

  final List<String> items;
  final String? initialValue;
  final String? hintText;
  final void Function(String?)? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(1, 1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: DropdownFlutter<String>(
        enabled: enabled,
        itemsListPadding: EdgeInsets.only(top: 5.h),
        decoration: CustomDropdownDecoration(
            hintStyle: TextStyle(
              fontSize: 13.sp,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
            listItemDecoration: ListItemDecoration(
              selectedColor: Colors.grey.shade300,
            )),
        hideSelectedFieldWhenExpanded: true,
        excludeSelected: false,
        hintText: hintText,
        items: items,
        initialItem: initialValue,
        onChanged: onChanged,
      ),
    );
  }
}
