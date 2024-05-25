import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';
import 'package:chahele_project/view/authentication_screens/otp_screen.dart';
import 'package:chahele_project/view/authentication_screens/widgets/login_buttons.dart';
import 'package:chahele_project/view/authentication_screens/widgets/phone_field.dart';
import 'package:chahele_project/view/bottom_navigation_bar/bottom_nav_widget.dart';
import 'package:chahele_project/view/profile_tab/screens/profile_setup.dart';
import 'package:chahele_project/widgets/custom_loading.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final validator = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  String selectedCode = "";

  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                  child: SvgPicture.asset(ConstantImage.logInSvg),
                ),
                const Gap(24),
                const Text(
                  "Login",
                  style: TextStyle(
                      color: ConstantColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600),
                ),
                const Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        "Mobile Number",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ConstantColors.white),
                      ),
                    ),
                    const Gap(8),
                    //Phone Field
                    Form(
                      key: validator,
                      child: PhoneField(
                          authProvider: authProvider,
                          phoneNumberController: phoneNumberController),
                    ),
                    const Gap(31.88),
                    //Send Button
                    Center(
                      child: LoginButtons(
                          screenWidth: screenWidth,
                          text: "Send code",
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (phoneNumberController.text.isEmpty) {
                              failedToast(context, "Please enter your number");
                            } else {
                              sentPhoneNumber();
                              if (authProvider.isLoading == true) {
                                customLoading(context, "Sending OTP...");
                              }

                              // successToast(context, "OTP Sent");
                            }
                            // phoneNumberController.clear();
                          }),
                    ),
                    const Gap(17),
                    //Skip button
                    Center(
                      child: OutlinedButton(
                          onPressed: () async {
                            bool isAuthenticated =
                                await authProvider.isUserAuthenticated();

                            if (isAuthenticated) {
                              bool userDetailsComplete =
                                  await authProvider.isUserDetailsComplete();

                              if (!userDetailsComplete) {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileSetUp(phoneNumber: phoneNumber),
                                  ),
                                );
                                successToast(context, "Already Logged");
                                return;
                              }
                            }

                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigationWidget(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ButtonStyle(
                            side: const MaterialStatePropertyAll(
                              BorderSide(
                                color: ConstantColors.white,
                              ),
                            ),
                            fixedSize: const MaterialStatePropertyAll(
                              Size.fromHeight(43),
                            ),
                            maximumSize: MaterialStatePropertyAll(
                              Size.fromWidth(screenWidth),
                            ),
                          ),
                          child: const Text(
                            "Skip login",
                            style: TextStyle(
                                color: ConstantColors.white,
                                fontWeight: FontWeight.w500),
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

//OTP send function
  void sentPhoneNumber() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    phoneNumber =
        "${authProvider.selectedCode}${phoneNumberController.text.trim()}";

    await authProvider.login(
      phoneNumber: phoneNumber,
      onFailure: (err) {
        Navigator.pop(context);
        failedToast(context, err.message.toString());
      },
      onSuccess: (verificationId) {
        Navigator.pop(context);
        successToast(context, "OTP Sent to $phoneNumber");

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
            ));
      },
    );
  }
}
