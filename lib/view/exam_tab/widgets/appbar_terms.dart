import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class AppBarTandC extends StatelessWidget {
  const AppBarTandC({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16))),
      surfaceTintColor: ConstantColors.white,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      toolbarHeight: 124,
      pinned: true,
      forceElevated: true,
      centerTitle: false,
      backgroundColor: ConstantColors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.4),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AGREEMENT",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ConstantColors.black.withOpacity(0.5)),
          ),
          const Gap(8),
          Text(
            "Exam Terms & Conditions",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ConstantColors.black.withOpacity(0.9)),
          ),
          const Gap(8),
          // Text(
          //   "Last updated on 5/12/2022",
          //   style: TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w400,
          //       color: ConstantColors.black.withOpacity(0.5)),
          // ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(
            ConstantIcons.chahelLogoSmallSvg,
            width: 54,
            height: 60,
          ),
        )
      ],
    );
  }
}
