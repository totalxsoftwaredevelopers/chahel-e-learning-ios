import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsTextRow extends StatelessWidget {
  const DetailsTextRow(
      {super.key, required this.firstValue, required this.secondValue});

  final String firstValue;
  final String secondValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                firstValue,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ConstantColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Text(
            ":",
            style: TextStyle(
              color: ConstantColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  secondValue,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: ConstantColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
