import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/course_provider.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/model/user_model.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/view/bottom_navigation_bar/bottom_nav_widget.dart';
import 'package:chahele_project/view/profile_tab/screens/profile_setup.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _isMounted;
  @override
  void initState() {
    fetchUserData();
    Provider.of<CourseProvider>(context, listen: false).getLiveLink();

    super.initState();
    _isMounted = true;

    Future.delayed(const Duration(seconds: 4)).then((value) {
      if (_isMounted) {
        checkAuthentication();
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void fetchUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData();
  }

  Future<void> checkAuthentication() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final user = await authProvider.getCurrentUser();
    // Navigate to appropriate screen based on authentication status
    if (user != null) {
      navigateToNextScreen(user);
    } else {
      navigateToLoginScreen();
    }
  }

  void navigateToNextScreen(User user) {
    // Navigate to bottom navigation or profile setup screen based on user data
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        final userModel = UserModel.fromMap(userData);
        if (userModel.email!.isNotEmpty && userModel.name!.isNotEmpty) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const BottomNavigationWidget(),
          ));
        } else {
          isUserAlreadyLogged(userModel.phoneNumber);
        }
      } else {
        // User data not found, navigate to default screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const BottomNavigationWidget(),
        ));
      }
    });
  }

  Future<void> isUserAlreadyLogged(String phoneNumber) async {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    bool isAuthenticated = await authProvider.isUserAuthenticated();

    if (isAuthenticated) {
      bool userDetailsComplete = await authProvider.isUserDetailsComplete();

      if (!userDetailsComplete) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileSetUp(phoneNumber: phoneNumber),
          ),
        );
        successToast(context, "Already Logged");
        return;
      }
    }
  }

  void navigateToLoginScreen() {
    // Navigate to login screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantColors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              effects: [
                CrossfadeEffect(
                  curve: Curves.decelerate,
                  alignment: Alignment.center,
                  delay: const Duration(milliseconds: 2200),
                  duration: const Duration(milliseconds: 1500),
                  builder: (context) {
                    return SvgPicture.asset(
                      ConstantIcons.chahelAnimatedIcon,
                      width: 130,
                      height: 127,
                    );
                  },
                ),
              ],
            ),
            Gap(33),
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
                      delay: const Duration(seconds: 0),
                      duration: const Duration(milliseconds: 2000))
                  .moveY(
                      begin: -50,
                      delay: const Duration(milliseconds: 800),
                      duration: const Duration(milliseconds: 3500),
                      curve: Curves.decelerate),
            ),
          ],
        )));
  }
}
