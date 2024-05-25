import 'package:chahele_project/controller/image_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';
import 'package:chahele_project/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.emailID,
    this.onTapEdit,
    required this.imageUrl,
  });
  final String name;
  final String emailID;
  final void Function()? onTapEdit;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickProvider>(context);
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 5,
      color: ConstantColors.mainBlueTheme,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //User Image
            Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    color: ConstantColors.white, shape: BoxShape.circle),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CustomCachedNetworkImage(image: imageUrl!))
                    : SvgPicture.asset(ConstantImage.imageAvathar)),
            const Gap(10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Name & Email
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ConstantColors.white),
                      ),
                      Text(
                        emailID,
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: ConstantColors.white),
                      )
                    ],
                  ),

                  //Edit Button
                  GestureDetector(
                    onTap: onTapEdit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          ConstantIcons.editIcon,
                          height: 21,
                          width: 21,
                        ),
                        const Gap(8),
                        const Text(
                          "Edit",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: ConstantColors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContinueToLoginCont extends StatelessWidget {
  const ContinueToLoginCont({
    super.key,
    required this.content,
  });
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(0),
        color: ConstantColors.mainBlueTheme,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                content,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ConstantColors.white),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: ConstantColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
