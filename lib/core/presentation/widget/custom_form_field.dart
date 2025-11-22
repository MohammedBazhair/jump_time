import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/extensions.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    this.validator,
    required this.hintText,
    this.maxLength,
    this.textInputType,
    this.inputFormatters,
    this.helperText,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final int? maxLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final TextInputAction? textInputAction;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: context.textTheme.labelMedium,
      inputFormatters: inputFormatters,
      cursorColor: const Color(0xFF41677F).withOpacity(.5),
      cursorErrorColor: const Color(0xFF41677F).withOpacity(.5),
      cursorRadius: const Radius.circular(10),
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText ?? ' ',
      ),
      textInputAction: textInputAction,
      validator: validator,
      keyboardType: textInputType,

      maxLength: maxLength,
    );
  }
}
