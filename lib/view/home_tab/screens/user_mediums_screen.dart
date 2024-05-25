import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/home_tab/screens/subjects_screen.dart';
import 'package:chahele_project/view/home_tab/widgets/rec_stack_container.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UserMediumScreen extends StatelessWidget {
  const UserMediumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final planProvider = Provider.of<PlanController>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);

    // standardProvider.standardsList.sort(
    //   (a, b) => a.standard.compareTo(b.standard),
    // );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HeadingAppBar(heading: "Standard's", isBackButtomn: true),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => const Gap(16),
              itemCount: planProvider.mediumList.length,
              itemBuilder: (context, index) {
                final medium = planProvider.mediumList[index];

                return RecStackContainer(
                  isLockIconEnabled: false,
                  isStdContainerEnable: false,
                  onPressed: () {
                    authProvider.firebaseAuth.currentUser == null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubjectScreen(id: medium.id!, index: index),
                            ),
                          );
                  },
                  screenWidth: screenWidth,
                  image: medium.image,
                  content: medium.medium,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
