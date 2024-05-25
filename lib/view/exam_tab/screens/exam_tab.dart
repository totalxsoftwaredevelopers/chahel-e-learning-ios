import 'dart:developer';

import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/exam_tab/widgets/exam_tab_container.dart';
import 'package:chahele_project/view/home_tab/screens/chapter_sections_screen.dart';
import 'package:chahele_project/view/profile_tab/widgets/profile_card.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ExamTabScreen extends StatefulWidget {
  const ExamTabScreen({super.key});

  @override
  State<ExamTabScreen> createState() => _ExamTabScreenState();
}

class _ExamTabScreenState extends State<ExamTabScreen> {
  // final searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);

      final planProvider = Provider.of<PlanController>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      //FETCH PLANS BY USER
      final currentUser = authProvider.firebaseAuth.currentUser;
      if (currentUser != null) {
        await planProvider.fetchUserPlans(currentUser.uid);
      }
      //--------MEDIUMS PURCHASED BY USER
      if (currentUser != null) {
        final userData = Provider.of<UserProvider>(context, listen: false).user;
        final chapterIdList =
            userData?.purchaseDetails?.map((e) => e.medId).toList() ?? [];
        await courseProvider.fetchSectionForExamTab(chapterIdList);
        courseProvider.combinedList();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    log(courseProvider.examTabDataList.length.toString());

    // final subjectList = courseProvider.subjectListForExam;
    // final chapterList = courseProvider.chapterListForExam;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          authProvider.firebaseAuth.currentUser == null
              ? const HeadingAppBar(heading: "Exams", isBackButtomn: false)
              : SliverAppBar(
                  automaticallyImplyLeading: false,
                  surfaceTintColor: ConstantColors.white,
                  expandedHeight: 100,
                  pinned: true,
                  forceElevated: true,
                  centerTitle: false,
                  backgroundColor: ConstantColors.white,
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.4),
                  title: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "Exams",
                      style: TextStyle(
                          color: ConstantColors.headingBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  bottom: PreferredSize(
                      preferredSize: Size(screenWidth, 60),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Search Chapter",
                              hintStyle: const TextStyle(fontSize: 15),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: const BorderSide()),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: const BorderSide(),
                              ),
                            ),
                            onChanged: (value) {
                              courseProvider.onSearchChanged(value);
                            },
                          ),
                        ),
                      )),
                ),
          if (authProvider.firebaseAuth.currentUser == null)
            SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const ContinueToLoginCont(
                        content: "Please Login to choose Exams"),
                  ),
                ))
          else if (courseProvider.searchResult.isEmpty &&
              courseProvider.isLoading == true)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Lottie.asset(ConstantIcons.lottieProgress,
                    height: 100, width: 100),
              ),
            )
          else if (courseProvider.searchResult.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "No Exams Found",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(16),
                itemCount: courseProvider.searchResult.length,
                itemBuilder: (context, index) {
                  return ExamTabContainer(
                    chapterLength: courseProvider.chapterListForExam.length,
                    screenWidth: screenWidth,
                    chapterName: courseProvider.searchResult[index].chapterName,
                    content: courseProvider.searchResult[index].content,
                    image: courseProvider.searchResult[index].image,
                    subjectName: courseProvider.searchResult[index].subjectName,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SectionsScreen(
                            index: index,
                            id: courseProvider.searchResult[index].chapterId,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
