import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

Future<dynamic> customAlertDailogue(
    {required BuildContext context,
    AuthenticationProvider? provider,
    required String message,
    required final void Function()? onYes,
    String icon = ConstantIcons.warningIconSvg}) {
  return showDialog(
      context: context,
      builder: (context) => Material(
            type: MaterialType.transparency,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    height: 214,
                    decoration: BoxDecoration(
                      color: ConstantColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                        width: 66,
                        child: SvgPicture.asset(icon),
                      ),
                      const Gap(16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: ConstantColors.headingBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      const Gap(32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonWidget(
                            buttonHeight: 33,
                            buttonWidth: 113,
                            buttonColor: ConstantColors.buttonScndColor,
                            buttonText: "No",
                            textColor: ConstantColors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Gap(23),
                          ButtonWidget(
                              buttonHeight: 33,
                              buttonWidth: 113,
                              buttonColor: ConstantColors.mainBlueTheme,
                              buttonText: "Yes",
                              onPressed: onYes),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
}
