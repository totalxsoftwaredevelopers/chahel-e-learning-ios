import 'dart:developer';
import 'dart:io';

import 'package:android_permission/android_permission.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/exam_tab/screens/terms_and_conditions.dart';
import 'package:chahele_project/view/home_tab/screens/video_player_screen.dart';
import 'package:chahele_project/view/home_tab/screens/view_pdf.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:chahele_project/widgets/cached_network_image.dart';
import 'package:chahele_project/widgets/custom_loading.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SectionsScreen extends StatefulWidget {
  const SectionsScreen({super.key, required this.index, required this.id});
  final int index;
  final String id;

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  final ScrollController scrollController = ScrollController();
  String? filePath;
  @override
  void initState() {
    final provider = context.read<CourseProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider
        ..clearSectionData()
        ..fetchSections(widget.id);
    });
    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0 &&
          provider.isLoading == false) {
        log("moredata called");

        provider.fetchSections(widget.id);
      }
    });
    super.initState();
  }
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<CourseProvider>(context, listen: false)
  //       ..clearSectionData()
  //       ..fetchSections(widget.id);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionProvider = Provider.of<CourseProvider>(context);

    // sectionProvider.sectionList.sort(
    //   (a, b) => a.sectionNumber.compareTo(b.sectionNumber),
    // );

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          const HeadingAppBar(heading: "Sections", isBackButtomn: true),
          if (sectionProvider.sectionList.isEmpty &&
              sectionProvider.isLoading == true)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Lottie.asset(ConstantIcons.lottieProgress,
                    height: 100, width: 100),
              ),
            )
          else if (sectionProvider.sectionList.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text("No Section Found!")),
            )
          else
            SliverList.builder(
              itemCount: sectionProvider.sectionList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Section Name
                      Text(
                        "${sectionProvider.sectionList[index].sectionNumber} - ${sectionProvider.sectionList[index].sectionName}",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: ConstantColors.headingBlue),
                      ),
                      const Gap(16),
                      //Video
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                  videoUrl: sectionProvider
                                      .sectionList[index].videoUrl,
                                  sectionName: sectionProvider
                                      .sectionList[index].sectionName),
                            ),
                          );
                        },
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: 200,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.7,
                                child: CustomCachedNetworkImage(
                                  image:
                                      sectionProvider.sectionList[index].image,
                                ),
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  ConstantIcons.playIconSvg,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      //Description
                      Text(
                        sectionProvider.sectionList[index].description,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: ConstantColors.black.withOpacity(0.7)),
                      ),
                      const Gap(16),
                      //Exam Page
                      ButtonWidget(
                        buttonHeight: 42,
                        buttonWidth: screenWidth,
                        buttonColor: ConstantColors.headingBlue,
                        buttonText: "Go To Exam Page",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamTandCScreen(
                                sectionId:
                                    sectionProvider.sectionList[index].id!,
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),

                      const Gap(16),
                      ButtonWidget(
                        buttonHeight: 42,
                        buttonWidth: screenWidth,
                        buttonColor: ConstantColors.mainBlueTheme,
                        buttonText: "View Notes",
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPdfScreen(
                                    pdfUrl: sectionProvider
                                        .sectionList[index].pdfUrl,
                                    lesson: sectionProvider
                                        .sectionList[index].sectionName),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (sectionProvider.isLoading == true &&
              sectionProvider.sectionList.isNotEmpty)
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

  Future<void> downloadPdfPermission(String pdfUrl, String fileName,
      {required VoidCallback onSucess, required VoidCallback onFailure}) async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      await downloadPdf(pdfUrl, fileName);
      onSucess.call();
    } else {
      log("Permission not granted");
      onFailure.call();
    }
  }

  Future<void> downloadPdf(String url, String name) async {
    final responce = await http.get(Uri.parse(url));
    final bytes = responce.bodyBytes;
    final fileName = '$name.pdf';

    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/$fileName';
    final file = File(filePath ?? "No Path");

    await file.writeAsBytes(bytes);
  }
}
