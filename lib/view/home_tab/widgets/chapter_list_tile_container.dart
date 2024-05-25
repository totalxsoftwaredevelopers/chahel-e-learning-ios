import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChapterListTile extends StatelessWidget {
  const ChapterListTile({
    super.key,
    required this.index,
    required this.chapterName,
    required this.description,
    required this.chapterNumber,
  });
  final int index;
  final String chapterName;
  final String description;
  final int chapterNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ConstantColors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(-1, 1),
                color: ConstantColors.black.withOpacity(0.1))
          ]),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Chapter Name
                  Text(
                    "${chapterNumber} - $chapterName",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  //Description
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: ConstantColors.black.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ),
          //Image
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              color: ConstantColors.buttonScndColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(ConstantIcons.playIconSvg),
            ),
          )
        ],
      ),
    );
  }
}
