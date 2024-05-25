import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    super.key,
    this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.name,
    this.validator,
  });
  final TextEditingController? controller;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        // inputFormatters: <TextInputFormatter>[
        //   UpperCaseTextFormatter
        // ],
        validator: validator,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly!,
        cursorColor: ConstantColors.black,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ConstantColors.black.withOpacity(0.7)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          filled: true,
          fillColor: ConstantColors.white,
          border: OutlineInputBorder(
            borderSide:
                const BorderSide(color: ConstantColors.headingBlue, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
