import 'package:chahele_project/app_data.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeadingAppBar(heading: "About App", isBackButtomn: true),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ConstantIcons.chahelLogoSmallSvg,
                    height: 150,
                    width: 150,
                  ),
                  const Gap(10),
                  const Text(
                    "Chahel Learning App, your comprehensive e-learning companion available on both Android and iOS platforms. With courses spanning from kindergarden to 12th standard, students can embark on an educational journey customized to their needs. The app features exclusive access to Chahel's private YouTube channel, offering high-quality content designed to support students' academic growth. Whether mastering foundational concepts or tackling advanced topics, the Chahel Learning App provides a structured learning environment for students of all levels. With seamless access to educational resources within the app, students can focus on their studies without distractions.",
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  const Text(
                    "Version : ${AppDetails.appVersion}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
