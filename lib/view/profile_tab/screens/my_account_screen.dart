import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/choose_tab/widgets/selected_plan.dart';
import 'package:chahele_project/view/profile_tab/widgets/details_text_row.dart';
import 'package:chahele_project/view/profile_tab/widgets/profile_card.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<MyAccountScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final planController =
          Provider.of<PlanController>(context, listen: false);

      if (authProvider.firebaseAuth.currentUser != null) {
        planController
            .fetchUserPlans(authProvider.firebaseAuth.currentUser!.uid);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final planController = Provider.of<PlanController>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeadingAppBar(heading: "My Account", isBackButtomn: true),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            sliver: authProvider.firebaseAuth.currentUser == null
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                            content: "Please Login to choose your Course"),
                      ),
                    ),
                  )
                : planController.userData!.purchaseDetails != null &&
                        planController.userData!.purchaseDetails!.isNotEmpty
                    ? SliverList.separated(
                        separatorBuilder: (context, index) => const Gap(8),
                        itemCount:
                            planController.userData!.purchaseDetails!.length,
                        itemBuilder: (context, index) {
                          final endDate = planController
                              .userData!.purchaseDetails![index].endDate!
                              .toDate();
                          //------End Date in DD-MM-YYYY Format
                          final formattedDate =
                              DateFormat("dd-MM-yyyy").format(endDate);

                          //------End Date in Month Year Format
                          final formattedDateInMonth =
                              DateFormat.yMMMd().format(endDate);

                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Material(
                                  type: MaterialType.transparency,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: ConstantColors.white,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    "Course Details",
                                                    style: TextStyle(
                                                      color: ConstantColors
                                                          .headingBlue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const Gap(20),
                                                  DetailsTextRow(
                                                    firstValue: "Name",
                                                    secondValue: planController
                                                            .userData?.name ??
                                                        "User",
                                                  ),
                                                  const Gap(10),
                                                  DetailsTextRow(
                                                    firstValue: "Age",
                                                    secondValue: planController
                                                            .userData?.age ??
                                                        "Not Provided",
                                                  ),
                                                  const Gap(10),
                                                  DetailsTextRow(
                                                    firstValue: "School Name",
                                                    secondValue: planController
                                                            .userData
                                                            ?.schoolName ??
                                                        "No School Found",
                                                  ),
                                                  const Gap(10),
                                                  DetailsTextRow(
                                                    firstValue: "Standard",
                                                    secondValue: planController
                                                        .userData!
                                                        .purchaseDetails![index]
                                                        .standard!,
                                                  ),
                                                  const Gap(10),
                                                  DetailsTextRow(
                                                    firstValue: "Medium",
                                                    secondValue: planController
                                                        .userData!
                                                        .purchaseDetails![index]
                                                        .medium!,
                                                  ),
                                                  const Gap(10),
                                                  DetailsTextRow(
                                                      firstValue:
                                                          "Course Exp Date",
                                                      secondValue:
                                                          formattedDate),
                                                  const Gap(10),
                                                  DetailsTextRow(
                                                      firstValue:
                                                          "Course Duration",
                                                      secondValue: planController
                                                                  .userData!
                                                                  .purchaseDetails![
                                                                      index]
                                                                  .planDuration ==
                                                              1
                                                          ? "${planController.userData!.purchaseDetails![index].planDuration} Month"
                                                          : "${planController.userData!.purchaseDetails![index].planDuration} Months"),
                                                  const Gap(30),
                                                  ButtonWidget(
                                                    buttonHeight: 40,
                                                    buttonWidth: 150,
                                                    buttonColor: ConstantColors
                                                        .headingBlue,
                                                    buttonText: "Close",
                                                    textColor:
                                                        ConstantColors.white,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: SelectedPlanContainer(
                              schoolName: planController.userData!.schoolName!,
                              standard: planController
                                  .userData!.purchaseDetails![index].standard!,
                              medium: planController
                                  .userData!.purchaseDetails![index].medium!,
                              screenWidth: screenWidth,
                              endDate: formattedDateInMonth,
                            ),
                          );
                        },
                      )
                    : const SliverToBoxAdapter(
                        child: Center(
                          child: Text("Currently you have no course!"),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
