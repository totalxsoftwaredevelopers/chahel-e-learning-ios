import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';

class HeadingAppBar extends StatelessWidget {
  const HeadingAppBar({
    super.key,
    required this.heading,
    required this.isBackButtomn,
  });
  final String heading;
  final bool isBackButtomn;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: ConstantColors.white,
        leading: isBackButtomn
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios)),
              )
            : null,
        expandedHeight: 60,
        pinned: true,
        forceElevated: true,
        centerTitle: false,
        backgroundColor: ConstantColors.white,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.4),
        title: Text(
          heading,
          style: const TextStyle(
              color: ConstantColors.headingBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ));
  }
}
