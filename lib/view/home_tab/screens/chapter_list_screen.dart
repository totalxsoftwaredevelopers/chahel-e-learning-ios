import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/home_tab/screens/chapter_sections_screen.dart';
import 'package:chahele_project/view/home_tab/widgets/chapter_list_tile_container.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({super.key, required this.index, required this.id});
  final int index;
  final String id;

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<CourseProvider>(context, listen: false)
        ..clearChapterData()
        ..fetchChapter(widget.id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chapterProvider = Provider.of<CourseProvider>(context);

    chapterProvider.chapterList.sort(
      //chapterNumber
      (a, b) => a.sectionNumber.compareTo(b.sectionNumber),
    );

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          HeadingAppBar(
              heading: chapterProvider.subjectList[widget.index].subject,
              isBackButtomn: true),
          if (chapterProvider.chapterList.isEmpty &&
              chapterProvider.isLoading == true)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Lottie.asset(ConstantIcons.lottieProgress,
                    height: 100, width: 100),
              ),
            )
          else if (chapterProvider.chapterList.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text("No Chapter Found!")),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(8),
                itemCount: chapterProvider.chapterList.length,
                itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SectionsScreen(
                              index: index,
                              id: chapterProvider.chapterList[index].id!,
                            ),
                          ));
                    },
                    child: ChapterListTile(
                        chapterNumber:
                            chapterProvider.chapterList[index].sectionNumber,
                        chapterName: chapterProvider.chapterList[index].chapter,
                        description: chapterProvider.chapterList[index].about,
                        index: index)),
              ),
            ),
          if (chapterProvider.isLoading == true)
            SliverToBoxAdapter(
              child: Center(
                child: Lottie.asset(ConstantIcons.lottieProgress,
                    height: 100, width: 100),
              ),
            )
        ],
      ),
    );
  }
}
