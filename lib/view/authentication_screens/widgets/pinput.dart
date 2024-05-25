import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinputWidget extends StatelessWidget {
  const PinputWidget({
    super.key,
    required this.onSubmitted,
    required this.controller,
  });
  final void Function(String) onSubmitted;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(20),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Pinput(
      defaultPinTheme: defaultPinTheme,
      length: 6,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      closeKeyboardWhenCompleted: true,
      onSubmitted: onSubmitted,
      controller: controller,
    );
  }
}
