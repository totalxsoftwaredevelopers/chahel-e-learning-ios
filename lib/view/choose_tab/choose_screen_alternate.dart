import 'dart:developer';

import 'package:chahele_project/app_data.dart';
import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/payment_gateway_controller.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/model/medium_model.dart';
import 'package:chahele_project/model/standard_model.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/bottom_navigation_bar/bottom_nav_widget.dart';
import 'package:chahele_project/view/choose_tab/subscription_screen.dart';
import 'package:chahele_project/view/choose_tab/widgets/selected_plan.dart';
import 'package:chahele_project/view/home_tab/screens/subjects_screen.dart';
import 'package:chahele_project/view/profile_tab/widgets/profile_card.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChooseAlternate extends StatefulWidget {
  const ChooseAlternate({
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseAlternate> createState() => _ChooseAlternateState();
}

class _ChooseAlternateState extends State<ChooseAlternate> {
  int selectedIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PaymentGatewayProvider>(context, listen: false)
          .fetchGatewayKeys();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final planController = Provider.of<PlanController>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final gatewayProvider = Provider.of<PaymentGatewayProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeadingAppBar(heading: "Your Courses", isBackButtomn: false),
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
                            content: "Please Login to choose your course"),
                      ),
                    ),
                  )
                : planController.userData?.purchaseDetails != null &&
                        planController.userData!.purchaseDetails!.isNotEmpty
                    ? SliverList.separated(
                        separatorBuilder: (context, index) => const Gap(8),
                        itemCount:
                            planController.userData!.purchaseDetails!.length,
                        itemBuilder: (context, index) {
                          final endDate = planController
                              .userData!.purchaseDetails![index].endDate!
                              .toDate();
                          final formattedDateInMonth =
                              DateFormat.yMMMd().format(endDate);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubjectScreen(
                                        index: index,
                                        id: planController.userData!
                                            .purchaseDetails![index].medId!),
                                  ));
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  authProvider.firebaseAuth.currentUser == null
                      ? const Gap(0)
                      : Column(
                          children: [
                            ButtonWidget(
                              buttonHeight: 42,
                              buttonWidth: 200,
                              buttonColor: ConstantColors.mainBlueTheme,
                              buttonText: "Join",
                              onPressed: () {
                                if (gatewayProvider.gatewayData!.iosJoin ==
                                    true) {
                                  String message = "Hey there! 👋";
                                  planController
                                      .redirectToWhatsapp(
                                          'https://wa.me/${AppDetails.whatsappNumber}?text=$message')
                                      .then(
                                        (value) => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavigationWidget(),
                                          ),
                                        ),
                                      );
                                } else {
                                  planController.redirectToLink(
                                    link:
                                        'mailto:<${AppDetails.email}>?subject=&body=',
                                    onFailure: () async {
                                      await Clipboard.setData(
                                          const ClipboardData(
                                              text: AppDetails.email));
                                      successToast(context, "Email Copied");
                                    },
                                  );
                                }

                                //Class Dialogue

                                // showDialog(
                                //   context: context,
                                //   builder: (context) => Material(
                                //     type: MaterialType.transparency,
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(16),
                                //       child: Center(
                                //         child: StatefulBuilder(
                                //           builder: (context, classState) {
                                //             return Container(
                                //               width: screenWidth,
                                //               decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     BorderRadius.circular(16),
                                //                 color: ConstantColors.white,
                                //               ),
                                //               child: Padding(
                                //                 padding:
                                //                     const EdgeInsets.all(16),
                                //                 child: Column(
                                //                   mainAxisSize:
                                //                       MainAxisSize.min,
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                   children: [
                                //                     const Text(
                                //                       "Standard",
                                //                       style: TextStyle(
                                //                           fontSize: 14,
                                //                           fontWeight:
                                //                               FontWeight.w600,
                                //                           color: ConstantColors
                                //                               .headingBlue),
                                //                     ),
                                //                     const Gap(8),
                                //                     DropdownButton(
                                //                       isExpanded: true,
                                //                       hint: const Text(
                                //                           "Select STD"),
                                //                       value: planController
                                //                           .dropClassValue,
                                //                       items: courseProvider
                                //                           .planStandardList
                                //                           .map<
                                //                               DropdownMenuItem<
                                //                                   String>>(
                                //                         (StandardModel
                                //                             classItem) {
                                //                           return DropdownMenuItem(
                                //                             value:
                                //                                 classItem.id ??
                                //                                     "dfdfd",
                                //                             child: Text(classItem
                                //                                 .standard
                                //                                 .toString()),
                                //                           );
                                //                         },
                                //                       ).toList(),
                                //                       onChanged: (String?
                                //                           classValue) async {
                                //                         classState(() {
                                //                           planController
                                //                                   .dropClassValue =
                                //                               classValue!;
                                //                         });
                                //                         if (classValue !=
                                //                             null) {
                                //                           await planController
                                //                               .fetchPlanMediumData(
                                //                                   classValue);

                                //                           log(classValue);
                                //                         }
                                //                       },
                                //                     ),
                                //                     const Gap(8),
                                //                     const Gap(16),
                                //                     ButtonWidget(
                                //                       buttonHeight: 42,
                                //                       buttonWidth: screenWidth,
                                //                       buttonColor:
                                //                           ConstantColors
                                //                               .headingBlue,
                                //                       buttonText:
                                //                           "Choose Medium",
                                //                       onPressed: () {
                                //                         Navigator.pop(context);

                                //                         //Medium Dialogue

                                //                         showDialog(
                                //                           context: context,
                                //                           builder: (context) =>
                                //                               Material(
                                //                             type: MaterialType
                                //                                 .transparency,
                                //                             child: Padding(
                                //                               padding:
                                //                                   const EdgeInsets
                                //                                       .all(16),
                                //                               child: Center(
                                //                                 child:
                                //                                     Container(
                                //                                   width:
                                //                                       screenWidth,
                                //                                   decoration:
                                //                                       BoxDecoration(
                                //                                     borderRadius:
                                //                                         BorderRadius.circular(
                                //                                             16),
                                //                                     color: ConstantColors
                                //                                         .white,
                                //                                   ),
                                //                                   child:
                                //                                       Padding(
                                //                                     padding:
                                //                                         const EdgeInsets
                                //                                             .all(
                                //                                             16),
                                //                                     child:
                                //                                         Column(
                                //                                       mainAxisSize:
                                //                                           MainAxisSize
                                //                                               .min,
                                //                                       crossAxisAlignment:
                                //                                           CrossAxisAlignment
                                //                                               .start,
                                //                                       children: [
                                //                                         const Text(
                                //                                           "Medium",
                                //                                           style: TextStyle(
                                //                                               fontSize: 14,
                                //                                               fontWeight: FontWeight.w600,
                                //                                               color: ConstantColors.headingBlue),
                                //                                         ),
                                //                                         const Gap(
                                //                                             8),
                                //                                         StatefulBuilder(builder:
                                //                                             (context,
                                //                                                 setState) {
                                //                                           return DropdownButton<
                                //                                               String>(
                                //                                             hint:
                                //                                                 const Text("Select Medium"),
                                //                                             value:
                                //                                                 planController.dropMediumValue,
                                //                                             items: planController
                                //                                                     .planMediumList.isNotEmpty
                                //                                                 ? planController.planMediumList.map<
                                //                                                     DropdownMenuItem<
                                //                                                         String>>(
                                //                                                     (MediumModel mediumItem) {
                                //                                                       return DropdownMenuItem(
                                //                                                         value: mediumItem.id,
                                //                                                         child: Text(mediumItem.medium.toString()),
                                //                                                       );
                                //                                                     },
                                //                                                   ).toList()
                                //                                                 : [
                                //                                                     const DropdownMenuItem(child: Text("No Data Found"))
                                //                                                   ],
                                //                                             onChanged:
                                //                                                 (String? mediumValue) {
                                //                                               setState(() {
                                //                                                 planController.dropMediumValue = mediumValue!;
                                //                                               });
                                //                                               log("med id : $mediumValue");
                                //                                             },
                                //                                           );
                                //                                         }),
                                //                                         const Gap(
                                //                                             8),
                                //                                         const Gap(
                                //                                             16),
                                //                                         ButtonWidget(
                                //                                             buttonHeight:
                                //                                                 42,
                                //                                             buttonWidth:
                                //                                                 screenWidth,
                                //                                             buttonColor: ConstantColors
                                //                                                 .headingBlue,
                                //                                             buttonText:
                                //                                                 "Choose My Course",
                                //                                             onPressed:
                                //                                                 () {
                                //                                               bool exist = planController.userData?.purchaseDetails?.any((detail) => detail.medId == planController.dropMediumValue && detail.stdId == planController.dropClassValue) ?? false;

                                //                                               if (exist) {
                                //                                                 failedToast(context, "Course already exists! Choose another Course");
                                //                                               } else if (planController.dropMediumValue == null) {
                                //                                                 failedToast(context, "Select your medium");
                                //                                               } else {
                                //                                                 Navigator.pop(context);
                                //                                                 Navigator.push(
                                //                                                   context,
                                //                                                   MaterialPageRoute(
                                //                                                     builder: (context) => SubscriptionScreen(
                                //                                                       stdId: planController.dropClassValue!,
                                //                                                       medId: planController.dropMediumValue!,
                                //                                                     ),
                                //                                                   ),
                                //                                                 );
                                //                                                 // planController.dropClassValue =
                                //                                                 //     null;
                                //                                                 // planController.dropMediumValue =
                                //                                                 //     null;
                                //                                               }
                                //                                             })
                                //                                       ],
                                //                                     ),
                                //                                   ),
                                //                                 ),
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         );
                                //                       },
                                //                     )
                                //                   ],
                                //                 ),
                                //               ),
                                //             );
                                //           },
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
