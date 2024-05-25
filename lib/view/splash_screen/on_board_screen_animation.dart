import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<OnBoardScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(const Duration(milliseconds: 4200)).then((value) {
  //     setState(() {
  //       isWaiting = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
        backgroundColor: ConstantColors.white,
        body: Center(
          child: SizedBox(
            width: screenwidth,
            height: screenheight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Animate(
                              effects: [
                                CrossfadeEffect(
                                  curve: Curves.decelerate,
                                  alignment: Alignment.center,
                                  delay: const Duration(milliseconds: 3200),
                                  duration: const Duration(milliseconds: 1500),
                                  builder: (context) {
                                    return SvgPicture.asset(
                                      ConstantIcons.chahelAnimatedIcon,
                                      width: 130,
                                      height: 127,
                                    ).animate().scale(
                                          alignment: Alignment.center,
                                          curve: Curves.decelerate,
                                          duration: const Duration(seconds: 4),
                                          delay: const Duration(
                                              milliseconds: 5000),
                                          // begin: Offset(_height, _width),
                                          end: const Offset(100, 100),
                                        );
                                  },
                                ),
                              ],
                            ),
                            const Gap(33),
                            Animate(
                              child: SvgPicture.asset(
                                ConstantIcons.chahelAnimatedText,
                                height: 70,
                                width: 240,
                              )
                                  .animate()
                                  .slide(
                                    curve: Curves.decelerate,
                                    begin: const Offset(0, 100),
                                    end: const Offset(0, 0),
                                    delay: const Duration(seconds: 1),
                                    duration:
                                        const Duration(milliseconds: 2000),
                                  )
                                  .moveY(
                                      begin: -150,
                                      delay: const Duration(milliseconds: 800),
                                      duration:
                                          const Duration(milliseconds: 3500),
                                      curve: Curves.decelerate)
                                  .fadeOut(
                                      delay: const Duration(
                                        milliseconds: 5000,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 200)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                                height: 232,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Animate(
                                            child: SvgPicture.asset(
                                              ConstantIcons
                                                  .chahelAnimatedIconInverted,
                                              width: 130,
                                              height: 127,
                                            ).animate().scaleX(
                                                begin: 0,
                                                alignment: Alignment.center,
                                                curve: Curves.decelerate,
                                                delay: const Duration(
                                                    milliseconds: 5500),
                                                duration: const Duration(
                                                    milliseconds: 1000)),
                                          ),
                                          const Gap(33),
                                          SvgPicture.asset(
                                            ConstantIcons
                                                .chahelAnimatedTextWhite,
                                            height: 70,
                                            width: 240,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                    .animate()
                                    .slide(
                                      curve: Curves.decelerate,
                                      begin: const Offset(0, -100),
                                      end: const Offset(0, 0),
                                      delay: const Duration(milliseconds: 3800),
                                      duration:
                                          const Duration(milliseconds: 2200),
                                    )
                                    .moveY(
                                        begin: 100,
                                        delay:
                                            const Duration(milliseconds: 4000),
                                        duration:
                                            const Duration(milliseconds: 3000),
                                        curve: Curves.decelerate)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(150),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 37),
                    child: ButtonWidget(
                      buttonHeight: 50,
                      buttonWidth: screenwidth,
                      buttonColor: ConstantColors.white,
                      buttonText: "Start",
                      textColor: ConstantColors.mainBlueTheme,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false);
                      },
                    ),
                  )
                      .animate()
                      .slide(
                        curve: Curves.decelerate,
                        begin: const Offset(0, -100),
                        end: const Offset(0, 0),
                        delay: const Duration(milliseconds: 4000),
                        duration: const Duration(milliseconds: 2000),
                      )
                      .moveY(
                          begin: 100,
                          delay: const Duration(milliseconds: 4000),
                          duration: const Duration(milliseconds: 3000),
                          curve: Curves.decelerate),
                ],
              ),
            ),
          ),
        )
        //user check

        );
  }
}
