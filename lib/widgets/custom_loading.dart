// ignore_for_file: sized_box_for_whitespace

import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void customLoading(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: Stack(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 60,
                child: Container(
                  height: 150,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ConstantColors.white),
                ),
              ),
              Container(
                child: Lottie.asset(ConstantIcons.loadingBookLottie,
                    height: 250, width: 250),
              ),
              Positioned(
                bottom: 60,
                child: Text(
                  message,
                  style: const TextStyle(
                      color: ConstantColors.black, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
