import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SelectedPlanContainer extends StatelessWidget {
  const SelectedPlanContainer({
    super.key,
    required this.screenWidth,
    required this.standard,
    required this.medium,
    required this.schoolName,
    this.endDate,
  });

  final double screenWidth;

  final String standard;
  final String medium;
  final String schoolName;
  final String? endDate;

  @override
  Widget build(BuildContext context) {
    const textColor = ConstantColors.headingBlue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 90,
        width: screenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ConstantColors.unselectedPlan),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       "Course End",
              //       style: TextStyle(
              //           color: textColor,
              //           fontWeight: FontWeight.w600,
              //           fontSize: 12),
              //     ),
              //     Text(
              //       endDate ?? "No Date",
              //       style: const TextStyle(
              //           color: textColor,
              //           fontWeight: FontWeight.w500,
              //           fontSize: 10),
              //     ),
              //   ],
              // ),
              const Gap(8),
              const VerticalDivider(
                color: textColor,
              ),
              const Gap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 6,
                        backgroundColor: ConstantColors.onlineDotGreen,
                      ),
                      const Gap(5),
                      Text(
                        standard,
                        style: const TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    "Medium - ${medium}\n${schoolName} ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
