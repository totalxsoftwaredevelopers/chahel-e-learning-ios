import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/banner_controller.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/choose_tab/choose_screen_alternate.dart';
import 'package:chahele_project/view/home_tab/screens/medium_screen.dart';
import 'package:chahele_project/view/home_tab/screens/standard_screen.dart';
import 'package:chahele_project/view/home_tab/screens/subjects_screen.dart';
import 'package:chahele_project/view/home_tab/screens/user_mediums_screen.dart';
import 'package:chahele_project/view/home_tab/widgets/ad_slider.dart';
import 'package:chahele_project/view/home_tab/widgets/rec_stack_container.dart';
import 'package:chahele_project/view/home_tab/widgets/square_stack_container.dart';
import 'package:chahele_project/view/notification_screen/screens/notification_screen.dart';
import 'package:chahele_project/widgets/customAlertDialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final planProvider = Provider.of<PlanController>(context, listen: false);
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      // CHECK THE PLAN IS EXPIRED
      if (authProvider.firebaseAuth.currentUser != null) {
        Provider.of<PlanController>(context, listen: false)
            .checkAndDeleteExpiredPlans(
                authProvider.firebaseAuth.currentUser!.uid);
      }
      //FETCH PLANS BY USER
      final currentUser = authProvider.firebaseAuth.currentUser;
      if (currentUser != null) {
        planProvider.fetchUserPlans(currentUser.uid);
      }
      //--------MEDIUMS PURCHASED BY USER
      if (currentUser != null) {
        final planProvider =
            Provider.of<PlanController>(context, listen: false);

        final userData = Provider.of<UserProvider>(context, listen: false).user;
        final stdIdList =
            userData?.purchaseDetails?.map((e) => e.stdId).toList() ?? [];
        planProvider.fetchUserPlansMedium(stdIdList);

        final mediumIdList =
            userData?.purchaseDetails?.map((e) => e.medId).toList() ?? [];
        planProvider.fetchUserPlansMedium(mediumIdList);
      }
      //FETCH STANDARD
      Provider.of<CourseProvider>(context, listen: false).fetchStandards();
      //FETCH AD BANNER
      Provider.of<BannerController>(context, listen: false).fetchBanner();
      //FETCH MEDIUM BY LIMIT

      Provider.of<CourseProvider>(context, listen: false).fetchAllMedium();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final planProvider = Provider.of<PlanController>(context);
    final standardProvider = Provider.of<CourseProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final bannerProvider = Provider.of<BannerController>(context);

    // final stdList = planProvider.stdList;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          fetchPurchasedMediums();
          final currentUser = authProvider.firebaseAuth.currentUser;
          if (currentUser != null) {
            planProvider.fetchUserPlans(currentUser.uid);
          }
        },
        child: CustomScrollView(
          slivers: [
            //--------------------///////////////////// APP BAR
            SliverAppBar(
              surfaceTintColor: ConstantColors.white,
              expandedHeight: 60,
              pinned: true,
              forceElevated: true,
              centerTitle: true,
              backgroundColor: ConstantColors.white,
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.4),
              title: SizedBox(
                height: 42,
                width: 136,
                child: SvgPicture.asset(ConstantImage.appBarLogoSvg),
              ),
              actions: [
                standardProvider.liveModel!.isLiveNow == true
                    ? GestureDetector(
                        onTap: () {
                          standardProvider
                              .launchZoomLink(standardProvider.liveModel!.link);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const SizedBox(
                              width: 70,
                              height: 35,
                              // color: Colors.amber,
                            ),
                            Positioned(
                                right: 15,
                                child: Lottie.asset(
                                    "assets/lottie/go-live-lottie.json",
                                    height: 70,
                                    width: 70)),
                            const Positioned(
                                left: 35,
                                child: Text(
                                  "Live",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffe33956)),
                                ))
                          ],
                        ),
                      )
                    : const Gap(0),
                const Gap(10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    ConstantIcons.notificationSvg,
                    height: 26,
                    width: 24,
                  ),
                ),
                const Gap(20)
              ],
            ),
            const SliverGap(16),

            //--------------------///////////////////// AD SLIDER
            bannerProvider.banners.isEmpty
                ? SliverGap(0)
                : SliverToBoxAdapter(
                    child: AdSlider(screenWidth: screenWidth),
                  ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    //Standard Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Standard's",
                          style: TextStyle(
                              color: ConstantColors.headingBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const StandardScreen(),
                                ));
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                                // decoration: TextDecoration.underline,
                                // decorationColor: ConstantColors.viewAll,
                                decorationThickness: 2,
                                color: ConstantColors.viewAll,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    //--------------------///////////////////// STANDARDS

                    GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 15.81,
                              crossAxisSpacing: 15.81,
                              crossAxisCount: 3),
                      itemCount: standardProvider.standardsList.length > 6
                          ? 6
                          : standardProvider.standardsList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MediumScreen(
                                    index: index,
                                    id: standardProvider
                                        .standardsList[index].id!),
                              ));
                        },
                        child: SquareStackContainer(
                          content:
                              standardProvider.standardsList[index].standard,
                          image: standardProvider.standardsList[index].image,
                        ),
                      ),
                    ),

                    //--------------------///////////////////// USER PURCHSED MEDIUMS

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Medium",
                          style: TextStyle(
                              color: ConstantColors.headingBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        planProvider.mediumList.length > 3
                            ? TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserMediumScreen(),
                                      ));
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(
                                      color: ConstantColors.viewAll,
                                      // decoration: TextDecoration.underline,
                                      // decorationColor: ConstantColors.viewAll,
                                      decorationThickness: 2,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : const Gap(0)
                      ],
                    ),
                    authProvider.firebaseAuth.currentUser != null &&
                            planProvider.mediumList.isNotEmpty
                        ? ListView.separated(
                            separatorBuilder: (context, index) => const Gap(16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: planProvider.mediumList.length > 3
                                ? 3
                                : planProvider.mediumList.length,
                            itemBuilder: (context, index) {
                              final medium = planProvider.mediumList[index];
                              final std = planProvider.stdList[index];

                              return RecStackContainer(
                                isLockIconEnabled: false,
                                isStdContainerEnable: true,
                                onPressed: () {
                                  authProvider.firebaseAuth.currentUser == null
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SubjectScreen(
                                                id: medium.id!, index: index),
                                          ),
                                        );
                                },
                                screenWidth: screenWidth,
                                image: medium.image,
                                content: medium.medium,
                                standard: std.standard,
                              );
                            },
                          )
                        : standardProvider.isLoading == true
                            ? Center(
                                child: Lottie.asset(
                                    ConstantIcons.lottieProgress,
                                    height: 100,
                                    width: 100),
                              )

                            //---------------///////////// WHEN SKIP LOGIN
                            : ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Gap(16),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: standardProvider.allMediums.length,
                                itemBuilder: (context, index) {
                                  return RecStackContainer(
                                    isLockIconEnabled: true,
                                    isStdContainerEnable: true,
                                    onPressed: () {
                                      authProvider.firebaseAuth.currentUser ==
                                              null
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            )
                                          : customAlertDailogue(
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
                                    },
                                    screenWidth: screenWidth,
                                    image: standardProvider
                                        .allMediums[index].image,
                                    content: standardProvider
                                        .allMediums[index].medium,
                                    standard: standardProvider
                                        .standardsList[index].standard,
                                  );
                                },
                              ),
                    if (planProvider.mediumList.isEmpty &&
                        standardProvider.isLoading == true)
                      Center(
                        child: Lottie.asset(ConstantIcons.lottieProgress,
                            height: 100, width: 100),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void fetchPurchasedMediums() {
    final planProvider = Provider.of<PlanController>(context, listen: false);

    final userData = Provider.of<UserProvider>(context, listen: false).user;
    final stdIdList =
        userData?.purchaseDetails?.map((e) => e.stdId).toList() ?? [];
    planProvider.fetchUserPlansMedium(stdIdList);

    final mediumIdList =
        userData?.purchaseDetails?.map((e) => e.medId).toList() ?? [];
    planProvider.fetchUserPlansMedium(mediumIdList);
  }
}
