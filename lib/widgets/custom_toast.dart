import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

successToast(BuildContext context, String message) {
  FToast ftoast = FToast();
  ftoast.init(context);

  Widget toast = Container(
    // width: 300,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ConstantColors.white,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(ConstantIcons.checkLottie, height: 30, width: 30),

        const Gap(10),
        //message

        Expanded(
          child: Center(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: ConstantColors.mainBlueTheme,
                  fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    ),
  );

  ftoast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}

failedToast(BuildContext context, String message) {
  FToast ftoast = FToast();
  ftoast.init(context);

  Widget toast = Container(
    // width: 300,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ConstantColors.white,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(ConstantIcons.closeLottie, height: 30, width: 30),
        const Gap(10),
        //message
        Expanded(
          child: Text(message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: ConstantColors.black, fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );

  ftoast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}

customToast(
    {required BuildContext context,
    required String message,
    IconData? icon,
    Color? iconColor}) {
  FToast ftoast = FToast();
  ftoast.init(context);

  Widget toast = Container(
    width: double.infinity,
    height: 40,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: ConstantColors.white,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon!,
          color: iconColor!,
        ),
        const Gap(10),
        //message

        Text(
          message,
          maxLines: 2,
          overflow: TextOverflow.clip,
          style: const TextStyle(
              color: ConstantColors.mainBlueTheme, fontWeight: FontWeight.w500),
        )
      ],
    ),
  );

  ftoast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 2),
  );
}
