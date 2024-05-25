import 'package:cached_network_image/cached_network_image.dart';
import 'package:chahele_project/model/notification_model.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class NotificationFrame extends StatelessWidget {
  final NotificationModel notification;
  const NotificationFrame({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationDate = notification.timestamp!.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String formattedDate;

    if (notificationDate.year == today.year &&
        notificationDate.month == today.month &&
        notificationDate.day == today.day) {
      formattedDate = "Today";
    } else if (notificationDate.year == yesterday.year &&
        notificationDate.month == yesterday.month &&
        notificationDate.day == yesterday.day) {
      formattedDate = "Yesterday";
    } else {
      formattedDate = DateFormat.yMd().format(notificationDate);
    }

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  // clipBehavior: Clip.antiAlias,
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    ConstantIcons.chahelLogoSmallSvg,
                    height: 10,
                    width: 10,
                  )),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                          color: ConstantColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      notification.content,
                      style: const TextStyle(
                          color: ConstantColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              height: notification.image == null ? 0 : 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: notification.image != null
                  ? CachedNetworkImage(
                      imageUrl: notification.image!,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.blue,
                        highlightColor: Colors.grey,
                        child: Container(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                    )
                  : const Gap(0),
            ),
          )
        ],
      ),
    );
  }
}
