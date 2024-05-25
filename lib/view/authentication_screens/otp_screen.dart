import 'dart:async';

import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';

import 'package:chahele_project/view/authentication_screens/widgets/login_buttons.dart';
import 'package:chahele_project/view/authentication_screens/widgets/pinput.dart';
import 'package:chahele_project/view/profile_tab/screens/profile_setup.dart';
import 'package:chahele_project/view/splash_screen/spalsh_screen.dart';
import 'package:chahele_project/widgets/custom_loading.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {super.key, required this.verificationId, required this.phoneNumber});

  final String verificationId;
  final String phoneNumber;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final pinController = TextEditingController();

  late int seconds;
  Timer? timer;
  int resendTime = 30;
  String buttonName = "Resend";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<UserProvider>(context, listen: false)
      //     .getUserDetailsBlocked(widget.phoneNumber);
    });
    seconds = resendTime;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: ConstantColors.white,
            ),
          ),
          backgroundColor: ConstantColors.mainBlueTheme,
        ),
        backgroundColor: ConstantColors.mainBlueTheme,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 194.12,
                    width: 200,
                    child: SvgPicture.asset(ConstantImage.otpSvg),
                  ),
                  const Gap(24),
                  const Text(
                    "Login",
                    style: TextStyle(
                        // fontFamily: 'Poppins Semibold',
                        color: ConstantColors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                  const Gap(24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "OTP Verification",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ConstantColors.white),
                            ),
                            const Gap(8),
                            Text(
                              "Enter the verification code we just sent to your number ${widget.phoneNumber}",
                              style: TextStyle(
                                color: ConstantColors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      //OTP field
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PinputWidget(
                              controller: pinController,
                              onSubmitted: (value) {
                                value = pinController.text;
                              },
                            ),
                            const Gap(32),
                            //Verify button
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: LoginButtons(
                                screenWidth: screenWidth,
                                text: "Verify",
                                onPressed: () async {
                                  if (pinController.text.isEmpty) {
                                    failedToast(context, "Enter OTP");
                                  } else {
                                    verifyOtp();
                                  }
                                  if (authProvider.isLoading == true) {
                                    customLoading(context, "Verifiying OTP...");
                                  }
                                },
                              ),
                            ),
                            const Gap(16),
                            //Recent field
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't Get OTP?",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ConstantColors.white),
                                ),
                                const Gap(5),
                                seconds == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          authProvider.resendOTP(
                                            phoneNumber: widget.phoneNumber,
                                            onSuccess: () {
                                              successToast(context,
                                                  "OTP Resend to ${widget.phoneNumber}");
                                            },
                                          );
                                        },
                                        child: const Text(
                                          "Resend",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: ConstantColors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            "00:$seconds sec",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: ConstantColors.black),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(50)
                ],
              ),
            ),
          ),
        ));
  }

  void verifyOtp() {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    String otp = pinController.text;
    authProvider.verifyOtp(
      onSuccess: (verificationId) async {
        authProvider.notificationPermission();
        Navigator.pop(context);
        await authProvider.checkUserexist(
          onExist: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              ),
              (route) => false,
            );
          },
          onNewUser: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileSetUp(phoneNumber: widget.phoneNumber),
              ),
            );
          },
        );
        await userProvider.getUserDetails();
        successToast(context, "Login Successful");
      },
      onFailure: () {
        Navigator.pop(context);
        failedToast(context, "Invalid OTP");
      },
      verificationId: widget.verificationId,
      otpCode: otp,
    );
  }
}
