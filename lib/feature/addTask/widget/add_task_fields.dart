import 'package:flutter/material.dart';
import 'package:taskati/core/utils/text_style.dart';

class AddTaskFields extends StatelessWidget {
  const AddTaskFields({
    super.key,
    this.controller,
    required this.title,
    this.hint,
    this.icon,
    this.maxlines,
    this.readOnlyBool,
    this.onTap,
  });
  final String title;
  final String? hint;
  final Icon? icon;
  final int? maxlines;
  final bool? readOnlyBool;
  final Function()? onTap;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTitleTextStyle(context, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          onTap: onTap,
          readOnly: readOnlyBool ?? false,
          maxLines: maxlines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: getSmallTextStyle(context),
            suffixIcon: icon,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
