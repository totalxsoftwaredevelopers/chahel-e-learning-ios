import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/choose_tab/choose_screen_alternate.dart';
import 'package:chahele_project/view/home_tab/screens/subjects_screen.dart';
import 'package:chahele_project/view/home_tab/widgets/rec_stack_container.dart';
import 'package:chahele_project/widgets/customAlertDialogue.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MediumScreen extends StatefulWidget {
  const MediumScreen({super.key, required this.id, required this.index});
  final String id;
  final int index;

  @override
  State<MediumScreen> createState() => _MediumScreenState();
}

class _MediumScreenState extends State<MediumScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CourseProvider>(context, listen: false)
          .fetchMediumData(widget.id);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer3<CourseProvider, AuthenticationProvider, PlanController>(
        builder: (context, standardProvider, authProvider, planController, _) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            HeadingAppBar(
                heading: standardProvider.standardsList[widget.index].standard,
                isBackButtomn: true),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.separated(
                separatorBuilder: (context, index) => const Gap(16),
                itemCount: standardProvider.mediumList.length,
                itemBuilder: (context, index) => RecStackContainer(
                    isStdContainerEnable: false,
                    onPressed: () {
                      // log(widget.id);

                      if (authProvider.firebaseAuth.currentUser == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        bool hasPurchasedPlan = planController
                                .userData?.purchaseDetails
                                ?.any((detail) =>
                                    detail.medId ==
                                        standardProvider.mediumList[index].id &&
                                    detail.stdId == widget.id) ??
                            false;
                        if (hasPurchasedPlan) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubjectScreen(
                                index: index,
                                id: standardProvider.mediumList[index].id!,
                              ),
                            ),
                          );
                        } else {
                          customAlertDailogue(
                            context: context,
                            message:
                                "No Courses Added\n Are You Want To Add New Course?",
                            onYes: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseAlternate(),
                                  )).then((value) {
                                Navigator.pop(context);
                              });
                            },
                          );
                        }
                      }
                    },
                    isLockIconEnabled: !(planController
                            .userData?.purchaseDetails
                            ?.any((detail) =>
                                detail.medId ==
                                    standardProvider.mediumList[index].id &&
                                detail.stdId == widget.id) ??
                        false),
                    screenWidth: screenWidth,
                    image: standardProvider.mediumList[index].image,
                    content: standardProvider.mediumList[index].medium),
              ),
            )
          ],
        ),
      );
    });
  }
}
