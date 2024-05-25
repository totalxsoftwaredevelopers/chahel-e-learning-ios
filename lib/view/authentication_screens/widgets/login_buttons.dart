import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({
    super.key,
    required this.screenWidth,
    required this.text,
    this.onPressed,
  });

  final double screenWidth;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        backgroundColor: const MaterialStatePropertyAll(
          ConstantColors.lightBlueTheme,
        ),
        fixedSize: const MaterialStatePropertyAll(
          Size.fromHeight(43),
        ),
        maximumSize: MaterialStatePropertyAll(
          Size.fromWidth(screenWidth),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: ConstantColors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
