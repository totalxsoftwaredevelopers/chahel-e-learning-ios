import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/bottom_navigation_bar/bottom_nav_widget.dart';
import 'package:chahele_project/view/home_tab/screens/chapter_sections_screen.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ExamResultScreen extends StatelessWidget {
  const ExamResultScreen(
      {super.key,
      required this.selectedOption,
      required this.totalQuestion,
      required this.totalscore,
      required this.questionsAnswered,
      required this.index,
      required this.averageMark});

  final List<int?> selectedOption;
  final int totalQuestion;
  final int totalscore;
  final int questionsAnswered;
  final int index;
  final int averageMark;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<String> optionLabels = ["A", "B", "C", "D"];
    final examProvider = Provider.of<CourseProvider>(context);

    int optionLength = examProvider.randomQuestions![index].options.length;
    int questionCount = examProvider.randomQuestions!.length;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            const HeadingAppBar(heading: "Your Result", isBackButtomn: false),
            const SliverGap(8),
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              primary: true,
              flexibleSpace: Container(
                height: 100,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: ConstantColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        color: ConstantColors.black.withOpacity(0.1))
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Questions :- $totalQuestion",
                            style: const TextStyle(
                                color: ConstantColors.headingBlue,
                                fontWeight: FontWeight.w500),
                          ),
                          const Gap(5),
                          Text(
                            "Questions Answered :- $questionsAnswered",
                            style: const TextStyle(
                                color: ConstantColors.headingBlue,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              "Your Score",
                              style: TextStyle(
                                  color: ConstantColors.headingBlue,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "$totalscore",
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: ConstantColors.headingBlue,
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // const SliverGap(16),

            //Question List
            SliverList.separated(
              separatorBuilder: (context, index) => const Gap(8),
              itemCount: questionCount,
              itemBuilder: (context, questionIndex) => Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: ConstantColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                      color: ConstantColors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Question ${questionIndex + 1}",
                        style: const TextStyle(
                            color: ConstantColors.headingBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Text(
                          examProvider
                                  .randomQuestions?[questionIndex].question ??
                              "No Question Found",
                          style: const TextStyle(
                              color: ConstantColors.headingBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                      const Gap(8),
                      const Text(
                        "Options",
                        style: TextStyle(
                            color: ConstantColors.headingBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),

                      //Option List
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Gap(8),
                        itemCount: optionLength,
                        itemBuilder: (context, optionIndex) => Container(
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: examProvider.randomQuestions?[questionIndex]
                                        .answer ==
                                    optionIndex
                                ? Colors.green.withOpacity(0.7)
                                : selectedOption[questionIndex] == optionIndex
                                    ? optionIndex ==
                                            examProvider
                                                .randomQuestions![questionIndex]
                                                .answer
                                        ? Colors.green.withOpacity(0.7)
                                        : Colors.red.withOpacity(0.7)
                                    : ConstantColors.unselectedIndex,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${optionLabels[optionIndex]}) ${examProvider.randomQuestions![questionIndex].options[optionIndex]}",
                                    style: const TextStyle(
                                        color: ConstantColors.headingBlue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Rewatch Button
          ],
        ),
        bottomNavigationBar: Container(
          width: screenWidth,
          decoration: BoxDecoration(
              color: ConstantColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 4, color: ConstantColors.black.withOpacity(0.3))
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Rewatch Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SectionsScreen(
                              index: index,
                              id: examProvider.sectionList[index].chapterId),
                        ),
                        (route) => route.isFirst);
                  },
                  child: Container(
                    height: 40,
                    width: screenWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ConstantColors.mainBlueTheme),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.replay,
                            color: ConstantColors.white,
                            size: 20,
                          ),
                          Gap(5),
                          Text(
                            "Rewatch Section",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: ConstantColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                //Go to home Button
                totalscore >= averageMark
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigationWidget(),
                              ),
                              (route) => false);
                        },
                        child: Container(
                          height: 40,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ConstantColors.mainBlueTheme),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  ConstantIcons.homeSelectedSvg,
                                  // ignore: deprecated_member_use
                                  color: ConstantColors.white,
                                  height: 18,
                                  width: 18,
                                ),
                                const Gap(7),
                                const Text(
                                  "Go to Home",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ConstantColors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Gap(0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
