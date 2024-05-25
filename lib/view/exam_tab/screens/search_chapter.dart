import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/model/chapter_model.dart';
import 'package:chahele_project/model/exam_tab_model.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/exam_tab/widgets/exam_tab_container.dart';
import 'package:chahele_project/view/home_tab/screens/chapter_sections_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchChapter extends StatefulWidget {
  const SearchChapter({super.key});

  @override
  State<SearchChapter> createState() => _SearchChapterState();
}

class _SearchChapterState extends State<SearchChapter> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      final planProvider = Provider.of<PlanController>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      //FETCH PLANS BY USER
      final currentUser = authProvider.firebaseAuth.currentUser;
      if (currentUser != null) {
        planProvider.fetchUserPlans(currentUser.uid);
      }
      //--------MEDIUMS PURCHASED BY USER
      if (currentUser != null) {
        final userData = Provider.of<UserProvider>(context, listen: false).user;
        final chapterIdList =
            userData?.purchaseDetails?.map((e) => e.medId).toList() ?? [];
        courseProvider.fetchSectionForExamTab(chapterIdList);

        // final chapterIdList =
        //     userData?.purchaseDetails?.map((e) => e.medId).toList() ?? [];
        // courseProvider.fetchSectionForExamTab(chapterIdList);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final courceProvider = Provider.of<CourseProvider>(context);

    final subjectList = courceProvider.subjectListForExam;
    final chapterList = courceProvider.chapterListForExam;

    List<ExamTabModel> examTabDataList = [];

    // Combined in single list
    for (var subject in subjectList) {
      List<ChapterModel> chapters =
          chapterList.where((chapter) => chapter.subId == subject.id).toList();
      for (var chapter in chapters) {
        examTabDataList.add(
          ExamTabModel(
              subjectName: subject.subject,
              chapterName: chapter.chapter,
              chapterId: chapter.id ?? "",
              subjectId: subject.id ?? "",
              medId: subject.medId,
              image: subject.image,
              content: chapter.about),
        );
      }
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: TextField(
              decoration: InputDecoration(hintText: "Search Chapter"),
            ),
          ),
          if (examTabDataList.isEmpty && courceProvider.isLoading == true)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Lottie.asset(ConstantIcons.lottieProgress,
                    height: 100, width: 100),
              ),
            )
          else if (examTabDataList.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      "Currently you have no plans!, Purchase a plan to get exams",
                      textAlign: TextAlign.center,
                    ),
                  )),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(16),
                  itemCount: examTabDataList.length,
                  itemBuilder: (context, index) {
                    // final subjects =
                    //     courceProvider.subjectListForExam[index];
                    // final chapters =
                    //     courceProvider.chapterListForExam[index];

                    return ExamTabContainer(
                      chapterLength: courceProvider.chapterListForExam.length,
                      screenWidth: screenWidth,
                      chapterName: examTabDataList[index].chapterName,
                      content: examTabDataList[index].content,
                      image: examTabDataList[index].image,
                      subjectName: examTabDataList[index].subjectName,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SectionsScreen(
                                index: index,
                                id: examTabDataList[index].chapterId),
                          ),
                        );
                      },
                    );
                  }),
            )
        ],
      ),
    );
  }
}
