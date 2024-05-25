import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {super.key, required this.videoUrl, required this.sectionName});
  final String videoUrl;
  final String sectionName;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final PodPlayerController controller;
  @override
  void initState() {
    controller = PodPlayerController(
      podPlayerConfig: const PodPlayerConfig(autoPlay: true),
      playVideoFrom: PlayVideoFrom.youtube(
        widget.videoUrl,
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ConstantColors.white),
        backgroundColor: ConstantColors.black,
      ),
      body: widget.videoUrl.contains('http')
          ? PodVideoPlayer(
              podProgressBarConfig: const PodProgressBarConfig(
                  playingBarColor: ConstantColors.mainBlueTheme,
                  circleHandlerColor: ConstantColors.mainBlueTheme),
              frameAspectRatio: 16 / 9,
              videoTitle: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.sectionName,
                  style: const TextStyle(
                      color: ConstantColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
              controller: controller)
          : const Center(
              child: Text(
                "No video found",
                style: TextStyle(color: ConstantColors.white),
              ),
            ),
    );
  }
}
