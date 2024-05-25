import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';

//Colored Button
class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.buttonColor,
    required this.buttonText,
    this.onPressed,
    this.textColor = ConstantColors.white,
  });
  final double buttonHeight;
  final double buttonWidth;
  final Color buttonColor;
  final String buttonText;
  final Color? textColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(buttonColor),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: textColor),
          )),
    );
  }
}

//Outline Button
class OutlineButtonWidget extends StatelessWidget {
  const OutlineButtonWidget({
    super.key,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.buttonColor,
    required this.buttonText,
    this.textColor = ConstantColors.headingBlue,
    this.onPressed,
    this.borderColor = ConstantColors.headingBlue,
  });

  final double buttonHeight;
  final double buttonWidth;
  final Color buttonColor;
  final String buttonText;
  final Color? textColor;
  final Color borderColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            buttonColor,
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          side: MaterialStatePropertyAll(
            BorderSide(color: borderColor),
          ),
          fixedSize: MaterialStatePropertyAll(
            Size.fromHeight(buttonHeight),
          ),
          maximumSize: MaterialStatePropertyAll(
            Size.fromWidth(buttonWidth),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ));
  }
}
