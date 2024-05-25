import 'package:chahele_project/app_data.dart';
import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/authentication_screens/login_screen.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({super.key});

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  @override
  void initState() {
    Provider.of<AuthenticationProvider>(context, listen: false).logOutUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanController>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ConstantIcons.chahelLogoSmallSvg,
                height: 150,
                width: 150,
              ),
              const Gap(20),
              const Text(
                "Your Account is blocked by Admin, To retrieve your account please contact admin",
                style: TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    buttonHeight: 40,
                    buttonWidth: 170,
                    buttonColor: ConstantColors.mainBlueTheme,
                    buttonText: "Contact Admin",
                    onPressed: () {
                      String message =
                          "My account seems to have been blocked. Can you please look into it and help me unblock it?";
                      planProvider.redirectToWhatsapp(
                          "https://api.whatsapp.com/send?phone=${AppDetails.whatsappNumber}&text=$message");
                    },
                  ),
                  const Gap(10),
                  ButtonWidget(
                    buttonHeight: 40,
                    buttonWidth: 170,
                    buttonColor: ConstantColors.mainBlueTheme,
                    buttonText: "Back to login",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
