import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/exam_tab/screens/exam_screen.dart';
import 'package:chahele_project/view/exam_tab/widgets/appbar_terms.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ExamTandCScreen extends StatefulWidget {
  const ExamTandCScreen({
    super.key,
    required this.sectionId,
    required this.index,
  });
  final String sectionId;
  final int index;

  @override
  State<ExamTandCScreen> createState() => _ExamTandCScreenState();
}

class _ExamTandCScreenState extends State<ExamTandCScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CourseProvider>(context, listen: false)
          .fetchExamData(widget.sectionId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final examProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const AppBarTandC(),
        const SliverGap(24),
        SliverToBoxAdapter(
          child: Container(
            width: screenWidth,
            height: 159,
            decoration: BoxDecoration(
                color: ConstantColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 7,
                      offset: const Offset(0, 1),
                      color: ConstantColors.black.withOpacity(0.15))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(16),

              //Exam Details
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EXAM DETAILS",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ConstantColors.black.withOpacity(0.7)),
                  ),
                  const Gap(16),
                  ExamDetailsRow(
                      text:
                          ("${examProvider.sectionList[widget.index].totalTime ?? "0"} Minutes"),
                      icon: ConstantIcons.timeIcon),
                  const Gap(16),
                  ExamDetailsRow(
                      text:
                          ("${examProvider.sectionList[widget.index].totalMark ?? "0"} Marks"),
                      icon: ConstantIcons.markIcon),
                  const Gap(16),
                  ExamDetailsRow(
                      text:
                          ("${examProvider.sectionList[widget.index].numberOfquestion ?? "0"} Questions"),
                      icon: ConstantIcons.questionIcon),
                ],
              ),
            ),
          ),
        ),
        const SliverGap(16),

        //Exam Terms
        SliverToBoxAdapter(
          child: Container(
            width: screenWidth,
            decoration: BoxDecoration(
                color: ConstantColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 7,
                      offset: const Offset(0, 1),
                      color: ConstantColors.black.withOpacity(0.15))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CHAHEL Exam terms",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ConstantColors.black.withOpacity(0.7)),
                  ),
                  const Gap(24),
                  const Text(
                    "Topics",
                    style: TextStyle(
                        color: ConstantColors.headingBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  const Gap(8),
                  Text(
                    examProvider.sectionList[widget.index].topic ?? "No Topic",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: ConstantColors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 12),
                  ),
                  const Gap(8),
                  const Text(
                    "Terms",
                    style: TextStyle(
                        color: ConstantColors.headingBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  const Gap(8),
                  Text(
                    "■  Each questions contains four options",
                    style: TextStyle(
                        color: ConstantColors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  Text(
                    "■  Follow allocated time limits meticulously for each section",
                    style: TextStyle(
                        color: ConstantColors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  Text(
                    "■  Score in the top 80% to to pass the exam",
                    style: TextStyle(
                        color: ConstantColors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const Gap(8),
                  Text(
                    "■  Read questions carefully",
                    style: TextStyle(
                        color: ConstantColors.black.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ButtonWidget(
                  buttonHeight: 42,
                  buttonWidth: screenWidth,
                  buttonColor: ConstantColors.mainBlueTheme,
                  buttonText: "Agree & Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamScreen(
                          index: widget.index,
                          sectionId: widget.sectionId,
                          examProvider: examProvider,
                        ),
                      ),
                    );
                  },
                ),
                const Gap(8),
                OutlineButtonWidget(
                  buttonHeight: 42,
                  buttonWidth: screenWidth,
                  buttonColor: const Color(0xffF5F5F5),
                  buttonText: "Cancel",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        )
      ],
    ));
  }
}

//Exam Details
class ExamDetailsRow extends StatelessWidget {
  const ExamDetailsRow({
    super.key,
    required this.text,
    required this.icon,
  });
  final String text;
  final String icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 14,
          width: 14,
        ),
        const Gap(14),
        Text(
          text,
          style: const TextStyle(
              color: ConstantColors.headingBlue,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
