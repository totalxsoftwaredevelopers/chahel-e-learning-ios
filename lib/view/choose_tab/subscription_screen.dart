import 'dart:developer';

import 'package:chahele_project/app_data.dart';
import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/payment_gateway.dart';
import 'package:chahele_project/controller/payment_gateway_controller.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/model/plan_model.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';
import 'package:chahele_project/view/bottom_navigation_bar/bottom_nav_widget.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen(
      {super.key, required this.stdId, required this.medId});

  final String stdId;
  final String medId;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List planDuration = ["Annually", "Monthly"];
  // List planPrizing = [
  //   "First 30 days free - Then   999/Year",
  //   "First 7 days free - Then   99/Month"
  // ];
  final Map<int, String> planDurationMap = {
    1: "1 Month",
    2: "3 Month",
    6: "6 Month",
    9: "9 Month",
    12: "12 Month",
  };

  int selectedPlan = 0;
  Timestamp startDate = Timestamp.now();

  final servrtTime = FieldValue.serverTimestamp();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PlanController>(context, listen: false)
          .fetchPlanDetails(stdId: widget.stdId, medId: widget.medId);

      Provider.of<PaymentGatewayProvider>(context, listen: false)
          .fetchGatewayKeys();
    });

    super.initState();
  }

  // bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context);
    final planProvider = Provider.of<PlanController>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final gatewayProvider = Provider.of<PaymentGatewayProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                ConstantColors.mainBlueTheme,
                ConstantColors.headingBlue
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: ConstantColors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Get Your Course",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: ConstantColors.white),
                ),
                const Gap(24),
                // Text(
                //   "Select your ${planProvider.planList.map((plan) => plan.standard ?? "Standard").first} ${planProvider.planList.map((plan) => plan.medium ?? "Medium").first} Medium plan\nchoose your preferred plan",
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w400,
                //     color: ConstantColors.white,
                //   ),
                // ),
                const Gap(8),
                Container(
                  height: 155,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ConstantImage.getPLanPng),
                    ),
                  ),
                ),
                const Gap(24),

                //plan container
                ListView.separated(
                  separatorBuilder: (context, index) => const Gap(16),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: planProvider.planList.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlan = index;
                      });
                      log(servrtTime.toString());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: selectedPlan == index ? 0 : 5),
                      child: Container(
                        height: 90,
                        width: screenWidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: selectedPlan == index
                                ? ConstantColors.headingBlue
                                : ConstantColors.white,
                            border: selectedPlan == index
                                ? Border.all(
                                    color: ConstantColors.lightBlueTheme,
                                    width: 4)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 40,
                                  offset: const Offset(-1, 1),
                                  color: ConstantColors.white.withOpacity(0.25))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planProvider.planList[index].planDuration ==
                                            1
                                        ? planDurationMap[1]!
                                        : planProvider.planList[index]
                                                    .planDuration ==
                                                3
                                            ? planDurationMap[3]!
                                            : planProvider.planList[index]
                                                        .planDuration ==
                                                    6
                                                ? planDurationMap[6]!
                                                : planProvider.planList[index]
                                                            .planDuration ==
                                                        9
                                                    ? planDurationMap[9]!
                                                    : planDurationMap[12]!,
                                    style: TextStyle(
                                        color: selectedPlan == index
                                            ? ConstantColors.white
                                            : ConstantColors.headingBlue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    // planProvider.planList[index].planDuration ==
                                    //         12
                                    //     ? "₹ ${planProvider.planList[index].totalAmount} - 12 Month"
                                    //     : "₹ ${planProvider.planList[index].totalAmount} /Month",
                                    "Check Details with admin",
                                    style: TextStyle(
                                        color: selectedPlan == index
                                            ? ConstantColors.white
                                            : ConstantColors.headingBlue,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              // Container(
                              //   height: 35,
                              //   width: 75,
                              //   decoration: BoxDecoration(
                              //     color: ConstantColors.onlineDotGreen,
                              //     borderRadius: BorderRadius.circular(18),
                              //   ),
                              //   child: const Center(
                              //     child: Text(
                              //       "Best Value",
                              //       style: TextStyle(
                              //           color: ConstantColors.white,
                              //           fontSize: 10),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                const Gap(32),

                //purchase button

                gatewayProvider.gatewayData?.isWhatsApp == false
                    ? ButtonWidget(
                        buttonHeight: 50,
                        buttonWidth: 240,
                        buttonColor: ConstantColors.lightBlueTheme,
                        buttonText: "Purchase",
                        textColor: ConstantColors.headingBlue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhonePePaymentGateway(
                                  paymentAmount: planProvider
                                      .planList[selectedPlan].totalAmount!,
                                  planController: planProvider,
                                  gatewayController: gatewayProvider,
                                  onSuccess: () async {
                                    await planProvider.purchasePlanUser(
                                      userId: authProvider
                                          .firebaseAuth.currentUser!.uid,
                                      purchasedPlan: PlanModel(
                                        startDate: startDate,
                                        endDate: planProvider
                                                    .planList[selectedPlan]
                                                    .planDuration ==
                                                1
                                            ? Timestamp.fromMillisecondsSinceEpoch(
                                                startDate
                                                        .millisecondsSinceEpoch +
                                                    (30 * 24 * 60 * 60 * 1000))
                                            : Timestamp.fromMillisecondsSinceEpoch(
                                                startDate
                                                        .millisecondsSinceEpoch +
                                                    (365 *
                                                        24 *
                                                        60 *
                                                        60 *
                                                        1000)),
                                        totalAmount: planProvider
                                            .planList[selectedPlan]
                                            .totalAmount!,
                                        planDuration: planProvider
                                            .planList[selectedPlan]
                                            .planDuration!,
                                        userId: authProvider
                                            .firebaseAuth.currentUser!.uid,
                                        medium: planProvider
                                            .planList[selectedPlan].medium!,
                                        standard: planProvider
                                            .planList[selectedPlan].standard!,
                                        id: planProvider
                                            .planList[selectedPlan].id,
                                        medId: planProvider.dropMediumValue,
                                        stdId: planProvider.dropClassValue,
                                      ),
                                      onSuccess: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const BottomNavigationWidget(),
                                            ),
                                            (route) => false);
                                        successToast(
                                            context, "Purchsase Successfull");
                                      },
                                    );
                                  },
                                  onFailure: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavigationWidget(),
                                        ),
                                        (route) => false);
                                    successToast(context, "Purchase Failed");
                                  },
                                ),
                              ));
                        },
                      )
                    //WhatsApp Button
                    : GestureDetector(
                        onTap: () {
                          String message =
                              "Hey there! 👋 I've been using Chahel The E Learning App for a while now and I'm really impressed with the quality of content and resources available. I've decided it's time to take my learning to the next level! Could you please provide me with the details to buy a plan ? 📚💻";
                          planProvider
                              .redirectToWhatsapp(
                                  'https://api.whatsapp.com/send?phone=${AppDetails.whatsappNumber}&text=$message')
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigationWidget(),
                                  )));
                        },
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: ConstantColors.lightBlueTheme,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ConstantImage.whatsAppPng,
                                height: 25,
                                width: 25,
                              ),
                              const Gap(5),
                              const Text(
                                "Contact Us",
                                style: TextStyle(
                                    color: ConstantColors.headingBlue,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                const Gap(24),

                const Text(
                  "To know more details about courses, Contact admin!",
                  style: TextStyle(
                      fontSize: 12,
                      color: ConstantColors.white,
                      fontWeight: FontWeight.w400),
                )

                //terms and conditions
                // RichText(
                //     textAlign: TextAlign.center,
                //     text: const TextSpan(children: [
                //       TextSpan(
                //         text: "By placing this order, you agree to the ",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //             fontFamily: 'Poppins'),
                //       ),
                //       TextSpan(
                //         text: "Terms of Service",
                //         style: TextStyle(
                //             color: Colors.amber,
                //             fontSize: 12,
                //             fontWeight: FontWeight.w700,
                //             fontFamily: 'Poppins'),
                //       ),
                //       TextSpan(
                //         text: " and ",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //             fontFamily: 'Poppins'),
                //       ),
                //       TextSpan(
                //         text: "Privacy Policy",
                //         style: TextStyle(
                //             color: Colors.amber,
                //             fontSize: 12,
                //             fontWeight: FontWeight.w700,
                //             fontFamily: 'Poppins'),
                //       ),
                //       TextSpan(
                //         text:
                //             ". Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period.",
                //         style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //             fontFamily: 'Poppins'),
                //       ),
                //     ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
