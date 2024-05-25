// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chahele_project/app_data.dart';
import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/model/user_plan_model.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/profile_tab/screens/about_app.dart';
import 'package:chahele_project/view/profile_tab/screens/my_account_screen.dart';
import 'package:chahele_project/view/profile_tab/screens/profile_setup.dart';
import 'package:chahele_project/view/profile_tab/widgets/account_logout.dart';
import 'package:chahele_project/view/profile_tab/widgets/more_option_container.dart';
import 'package:chahele_project/view/profile_tab/widgets/profile_card.dart';
import 'package:chahele_project/widgets/customAlertDialogue.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final planProvider = Provider.of<PlanController>(context);
    final courseProvider = Provider.of<CourseProvider>(context);

    // final currentUser = authProvider.currentUser;

    // final user = authProvider.firebaseAuth.currentUser != null
    //     ? userProvider.userList.firstWhere(
    //         (user) => user.id == authProvider.firebaseAuth.currentUser!.uid,
    //       )
    //     : null;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        const HeadingAppBar(
          isBackButtomn: false,
          heading: "Profile",
        ),
        SliverFillRemaining(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  authProvider.firebaseAuth.currentUser != null
                      ? StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(authProvider.firebaseAuth.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.exists) {
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final users = UserPlanModel.fromMap(userData);
                              return ProfileCard(
                                name: users.name ?? "User",
                                emailID: users.email ?? "No Email Provided",
                                imageUrl: users.image,
                                onTapEdit: () {
                                  // log(users.image);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileSetUp(
                                        phoneNumber: users.phoneNumber,
                                        editProfile: users,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              // Handle the case where no data exists
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const ContinueToLoginCont(
                                    content: "Login to Continue"),
                              );
                            }
                          },
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const ContinueToLoginCont(
                              content: "Login to Continue"),
                        ),

                  const Gap(16),
                  //Account & Logout
                  authProvider.firebaseAuth.currentUser != null
                      //If logged in
                      ? AccountContainer(
                          screenWidth: screenWidth,
                          //My Account
                          onMyAccount: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyAccountScreen(),
                                ));
                          },
                          //Log out
                          onLogout: () {
                            customAlertDailogue(
                                context: context,
                                provider: authProvider,
                                icon: ConstantIcons.logOutSvgRed,
                                message: "Are You Sure Want To Logout ?",
                                onYes: () async {
                                  // if (authProvider.firebaseAuth.currentUser != null) {
                                  //   customLoading(context, "Logging Out...");
                                  // Navigator.pop(context);
                                  await authProvider.logOutUser(
                                    onSuccess: () {
                                      planProvider.mediumList.clear();
                                      planProvider.planMediumList.clear();
                                      courseProvider.allMediums.clear();
                                      courseProvider.planMediumList.clear();
                                      courseProvider.planStandardList.clear();
                                      planProvider.stdList.clear();

                                      planProvider.userData!.purchaseDetails!
                                          .clear();
                                      successToast(
                                          context, "Logout Successful");
                                    },
                                  );
                                  // await Future.delayed(const Duration(seconds: 2));
                                  // Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ));
                                  // } else {
                                  //   Navigator.pop(context);
                                  //   // failedToast(context, "No User Signed");
                                  //   logOutDailogue(
                                  //     context: context,
                                  //     provider: authProvider,
                                  //     message:
                                  //         "No User Signed\nAre You Want To Log In ?",
                                  //     onYes: () {
                                  //       Navigator.pushReplacement(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 const LoginScreen(),
                                  //           ));
                                  //     },
                                  //   );
                                });
                          },
                        )
                      //If Skip Login

                      : const Gap(0),
                  const Gap(24),
                  const Text(
                    "More",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ConstantColors.black),
                  ),
                  const Gap(10),
                  //More
                  MoreOptionContainer(
                    screenWidth: screenWidth,
                    //Share
                    onShareApp: () {
                      shareAppLink();
                    },
                    //Rate Us
                    onRateUs: () {
                      planProvider.redirectToLink(
                          link:
                              "https://apps.apple.com/us/app/chahel-the-e-learning/id${AppDetails.appStoreID}");
                    },
                    //About US
                    onAboutApp: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutApp(),
                          ));
                    },
                    //Help and Support
                    onHelpSupport: () {
                      planProvider.redirectToLink(
                        link: 'mailto:<${AppDetails.email}>?subject=&body=',
                        onFailure: () async {
                          await Clipboard.setData(
                              const ClipboardData(text: AppDetails.email));
                          successToast(context, "Email Copied");
                        },
                      );
                    },
                    //Terms and Conditions
                    onTermsCondit: () {
                      planProvider.redirectToLink(
                          link: AppDetails.privacyPolicyUrl);
                    },
                    //Delete Account
                    onDeleteAccount: () {
                      customAlertDailogue(
                        context: context,
                        message:
                            "Are You Sure Want To Delete Your Account?\nAll Your Details Will be Removed",
                        onYes: () async {
                          await userProvider.deleteUser(
                            id: userProvider.firebaseAuth.currentUser!.uid,
                            onSuccess: () {
                              authProvider.logOutUser(onSuccess: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  void shareAppLink() {
    const String appLink = "https://chahelapp.page.link/RtQw";

    Share.share("Check out this awesome app: $appLink");
  }
}
