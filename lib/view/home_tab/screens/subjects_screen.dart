import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/home_tab/screens/chapter_list_screen.dart';
import 'package:chahele_project/view/home_tab/widgets/rec_stack_container.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key, required this.id, required this.index});
  final String id;
  final int index;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false)
          .fetchSubjects(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<CourseProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeadingAppBar(heading: "Subjects", isBackButtomn: true),
          if (provider.subjectList.isEmpty && provider.isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Lottie.asset(ConstantIcons.lottieProgress,
                    height: 100, width: 100),
              ),
            )
          else if (provider.subjectList.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text("No Subject Found!")),
            )
          else
            SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(16),
                  itemCount: provider.subjectList.length,
                  itemBuilder: (context, index) => RecStackContainer(
                    isLockIconEnabled: false,
                    isStdContainerEnable: false,
                    screenWidth: screenWidth,
                    content: provider.subjectList[index].subject,
                    image: provider.subjectList[index].image,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterListScreen(
                                id: provider.subjectList[index].id!,
                                index: index),
                          ));
                    },
                  ),
                ))
        ],
      ),
    );
  }
}
