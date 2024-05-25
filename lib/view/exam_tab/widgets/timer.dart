import 'dart:async';

import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {super.key, required this.maxTimeAllowed, required this.onTimerFinish});
  final int maxTimeAllowed;
  final VoidCallback? onTimerFinish;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int totalSeconds;
  late int minutes;
  late int seconds;
  Timer? timer;
  var f = NumberFormat("00");

  @override
  void initState() {
    totalSeconds = widget.maxTimeAllowed * 60;
    minutes = totalSeconds ~/ 60;
    seconds = totalSeconds % 60;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (totalSeconds > 0) {
          totalSeconds--;
          minutes = totalSeconds ~/ 60;
          seconds = totalSeconds % 60;
        } else {
          stopTimer();
          widget.onTimerFinish!.call();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (widget.maxTimeAllowed * 60 - totalSeconds) /
        (widget.maxTimeAllowed * 60);
    // final isRunning = timer!.isActive;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            value: progress,
            backgroundColor: ConstantColors.mainBlueTheme,
            valueColor: AlwaysStoppedAnimation(
                totalSeconds <= 10 ? Colors.red : ConstantColors.headingBlue),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${f.format(minutes)}:${f.format(seconds)}",
                style: TextStyle(
                  color: totalSeconds <= 10
                      ? Colors.red
                      : ConstantColors.headingBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "sec",
                style: TextStyle(
                  color: totalSeconds <= 10
                      ? Colors.red
                      : ConstantColors.headingBlue,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
