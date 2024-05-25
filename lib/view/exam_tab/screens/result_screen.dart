import 'dart:async';
import 'dart:math';

import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/view/exam_tab/screens/exam_result_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(
      {super.key,
      required this.totalScore,
      required this.totalQuestion,
      required this.questionsAnswered,
      required this.selectedOption,
      required this.index,
      required this.averageMark});
  final int totalScore;
  final int totalQuestion;
  final int questionsAnswered;
  final List<int?> selectedOption;
  final int index;
  final int averageMark;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _controller = ConfettiController(duration: const Duration(seconds: 1));
  bool isPlaying = false;

  @override
  void initState() {
    if (widget.totalScore > 8) {
      if (isPlaying) {
        _controller.stop();
      } else {
        _controller.play();
      }
    }
    Future.delayed(const Duration(seconds: 3)).then((value) {
      setState(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ExamResultScreen(
              selectedOption: widget.selectedOption,
              totalQuestion: widget.totalQuestion,
              questionsAnswered: widget.questionsAnswered,
              totalscore: widget.totalScore,
              index: widget.index,
              averageMark: widget.averageMark,
            ),
          ),
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: ConstantColors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DelayedDisplay(
                delay: const Duration(seconds: 1),
                fadeIn: true,
                slidingBeginOffset: const Offset(0, -0.1),
                child: Text(
                  (widget.totalScore == widget.totalQuestion)
                      ? "Excellent "
                      : (widget.totalScore < widget.totalQuestion &&
                              widget.totalScore >= widget.averageMark)
                          ? "Very Good!"
                          : "Need Improvement",
                  style: const TextStyle(
                      color: ConstantColors.headingBlue, fontSize: 25),
                ),
              ),
              const Gap(30),
              ConfettiWidget(
                confettiController: _controller,
                blastDirection: pi / 2,
                blastDirectionality: BlastDirectionality.explosive,
                maxBlastForce: 30,
                numberOfParticles: 50,
                emissionFrequency: 0,
              ),
              TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 200),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, size, _) {
                    return Container(
                      width: size,
                      height: size,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: ConstantColors.mainBlueTheme,
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor:
                              ConstantColors.white.withOpacity(0.6),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: ConstantColors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You Scored",
                                  style: TextStyle(
                                      color: ConstantColors.headingBlue,
                                      fontSize:
                                          size - 182 >= 0 ? size - 182 : 0),
                                ),
                                const Gap(5),
                                Text(
                                  "${widget.totalScore}/${widget.totalQuestion}",
                                  style: TextStyle(
                                      color: ConstantColors.headingBlue,
                                      fontSize:
                                          size - 170 >= 0 ? size - 170 : 0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              const Gap(60),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pushAndRemoveUntil(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => const BottomNavigationWidget()),
              //         (route) => false);
              //   },
              //   child: Container(
              //     height: 42,
              //     width: 250,
              //     decoration: BoxDecoration(
              //       color: ConstantColors.mainBlueTheme,
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //     child: const Center(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(
              //             "Go to Home Page",
              //             style: TextStyle(
              //                 color: ConstantColors.white,
              //                 fontWeight: FontWeight.w600),
              //           ),
              //           Gap(5),
              //           Icon(
              //             Icons.arrow_forward_ios_rounded,
              //             size: 15,
              //             color: ConstantColors.white,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
