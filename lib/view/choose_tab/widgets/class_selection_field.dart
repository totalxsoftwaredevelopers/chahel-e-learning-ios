import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

Future<dynamic> classSelectionField(
    {required BuildContext context,
    required double screenWidth,
    required List<DropdownMenuItem<String>>? syllabusItems,
    required List<DropdownMenuItem<String>>? classItems,
    // required String classValue,
    // required String syllabusValue,
    required void Function()? onPressed,
    required String syllabusValue,
    required String classValue}) {
  return showDialog(
      context: context,
      builder: (context) => Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Consumer<PlanController>(
                  builder: (context, planController, _) {
                    return Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ConstantColors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Standard",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ConstantColors.headingBlue),
                            ),
                            const Gap(8),
                            DropdownButton(
                                isExpanded: true,
                                value: planController.dropClassValue,
                                items: classItems,
                                onChanged: (String? classValue) {
                                  planController.dropClassValue = classValue!;
                                }),
                            const Gap(8),
                            const Text(
                              "Medium",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ConstantColors.headingBlue),
                            ),
                            const Gap(8),
                            DropdownButton(
                              items: syllabusItems,
                              value: planController.dropMediumValue,
                              onChanged: (String? syllabusValue) {
                                planController.dropMediumValue = syllabusValue!;
                              },
                            ),
                            const Gap(16),
                            ButtonWidget(
                                buttonHeight: 42,
                                buttonWidth: screenWidth,
                                buttonColor: ConstantColors.headingBlue,
                                buttonText: "Choose My Plan",
                                onPressed: onPressed)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ));
}
