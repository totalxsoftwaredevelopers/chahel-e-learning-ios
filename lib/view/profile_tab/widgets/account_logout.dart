import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AccountContainer extends StatelessWidget {
  const AccountContainer({
    super.key,
    required this.screenWidth,
    this.onMyAccount,
    this.onLogout,
  });

  final double screenWidth;
  final void Function()? onMyAccount;
  final void Function()? onLogout;

  @override
  Widget build(BuildContext context) {
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
          ListTile(
            onTap: onMyAccount,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.myAccountIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "My Courses",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "View your course and details",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: ConstantColors.black.withOpacity(0.5)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),
          ListTile(
            onTap: onLogout,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: ConstantColors.iconBlue.withOpacity(0.05),
              child: SvgPicture.asset(
                ConstantIcons.logoutIcon,
                height: 25,
                // width: 1,
              ),
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                  color: ConstantColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Further secure your account for safety",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: ConstantColors.black.withOpacity(0.5)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: ConstantColors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
