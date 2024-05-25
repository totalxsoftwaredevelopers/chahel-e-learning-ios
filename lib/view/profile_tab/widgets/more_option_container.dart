import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class MoreOptionContainer extends StatelessWidget {
  const MoreOptionContainer({
    super.key,
    required this.screenWidth,
    this.onShareApp,
    this.onRateUs,
    this.onAboutApp,
    this.onHelpSupport,
    this.onTermsCondit,
    this.onDeleteAccount,
  });

  final void Function()? onShareApp;
  final void Function()? onRateUs;
  final void Function()? onAboutApp;
  final void Function()? onHelpSupport;
  final void Function()? onTermsCondit;
  final void Function()? onDeleteAccount;

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
          color: ConstantColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                blurRadius: 5,
                spreadRadius: 1,
                color: Colors.black12,
                offset: Offset(0, 4))
          ]),
      child: Column(
        children: [
          const Gap(16),

          //Share App
          ListTile(
            onTap: onShareApp,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.shareAppIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "Share App",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),
          const Gap(16),

          //Rate Us
          ListTile(
            onTap: onRateUs,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.rateUsIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "Rate Us",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),
          const Gap(16),

          //About App
          ListTile(
            onTap: onAboutApp,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.aboutAppIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "About App",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),

          //help & support
          const Gap(16),
          ListTile(
            onTap: onHelpSupport,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.helpIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "Help & Support",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),

          //T&C
          const Gap(16),
          ListTile(
            onTap: onTermsCondit,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.tAndcIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "Terms and Condition",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),
          const Gap(16),

          //Delete Account
          authProvider.firebaseAuth.currentUser != null

              //if Logged in
              ? ListTile(
                  onTap: onDeleteAccount,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
                    child: SvgPicture.asset(
                      ConstantIcons.deleteIcon,
                      height: 25,
                      // width: 1,
                    ),
                  ),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: ConstantColors.black.withOpacity(0.5),
                  ),
                )
              //If Skip Login

              : const Gap(4),
          const Gap(8)
        ],
      ),
    );
  }
}
