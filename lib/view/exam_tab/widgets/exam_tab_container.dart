import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:chahele_project/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ExamTabContainer extends StatelessWidget {
  const ExamTabContainer({
    super.key,
    required this.screenWidth,
    required this.subjectName,
    required this.chapterName,
    required this.content,
    required this.image,
    required this.chapterLength,
    this.onPressed,
  });

  final double screenWidth;
  final String subjectName;
  final String chapterName;
  final String content;
  final String image;
  final int chapterLength;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ConstantColors.black,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: screenWidth,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Opacity(
                      opacity: 0.7,
                      child: CustomCachedNetworkImage(
                        image: image,
                      ),
                    )),
              ),
              Positioned(
                right: 0,
                child: Center(
                  child: Container(
                    height: 48,
                    width: 176,
                    decoration: const BoxDecoration(
                      color: ConstantColors.syllabusStackOp80,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(9.82),
                        topLeft: Radius.circular(9.82),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            subjectName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                color: ConstantColors.headingBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapterName,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ConstantColors.headingBlue),
                ),
                const Gap(8),
                Text(
                  content,
                  style: const TextStyle(
                      color: ConstantColors.headingBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                const Gap(8),
                const Divider(
                  color: ConstantColors.greyColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ButtonWidget(
                        buttonHeight: 40,
                        buttonWidth: 113,
                        buttonColor: ConstantColors.mainBlueTheme,
                        buttonText: "Start",
                        onPressed: onPressed)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
