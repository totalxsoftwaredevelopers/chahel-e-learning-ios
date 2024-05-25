import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/choose_tab/choose_screen_alternate.dart';
import 'package:chahele_project/view/exam_tab/screens/exam_tab.dart';
import 'package:chahele_project/view/home_tab/screens/home_screen.dart';
import 'package:chahele_project/view/profile_tab/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottonNavTabState();
}

class _BottonNavTabState extends State<BottomNavigationWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CourseProvider>(context, listen: false).fetchPlanStandards();
    });
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ChooseAlternate(),
              ExamTabScreen(),
              // authProvider.firebaseAuth.currentUser == null
              //     ? const SkipProfileScreen()
              ProfileScreen()
            ]),
        bottomNavigationBar: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            // indicatorPadding: EdgeInsets.all(8),

            indicator: const UnderlineTabIndicator(
                borderSide:
                    BorderSide(color: ConstantColors.mainBlueTheme, width: 8.0),
                insets: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 66.0),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    bottomLeft: Radius.circular(4))),
            labelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins'),
            labelColor: ConstantColors.mainBlueTheme,
            unselectedLabelColor: ConstantColors.headingBlue,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            tabs: [
              Tab(
                icon: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: selectedIndex == 0
                        ? SvgPicture.asset(ConstantIcons.homeSelectedSvg)
                        : SvgPicture.asset(ConstantIcons.homeUnselectedSvg)),
                text: "Home",
              ),
              Tab(
                text: "Courses",
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: selectedIndex == 1
                      ? SvgPicture.asset(ConstantIcons.chooseSelectedSvg)
                      : SvgPicture.asset(ConstantIcons.chooseUnselectedSvg),
                ),
              ),
              Tab(
                text: "Exams",
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: selectedIndex == 2
                      ? SvgPicture.asset(ConstantIcons.examsSelectedSvg)
                      : SvgPicture.asset(ConstantIcons.examUnselectedSvg),
                ),
              ),
              Tab(
                text: "Profile",
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: selectedIndex == 3
                      ? SvgPicture.asset(ConstantIcons.profileSelectedSvg)
                      : SvgPicture.asset(ConstantIcons.profileUnselectedSvg),
                ),
              ),
            ]),
      ),
    );
  }
}
