import 'dart:developer';

import 'package:chahele_project/controller/notification_provider.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:chahele_project/view/notification_screen/widgets/notification_frame.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final scrollcontroller = ScrollController();
  @override
  void initState() {
    final provider = context.read<NotificationController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider
        ..clearData()
        ..fetchAllNotification();

      scrollcontroller.addListener(() {
        if (scrollcontroller.position.atEdge &&
            scrollcontroller.position.pixels != 0 &&
            provider.fetchLoading == false &&
            provider.noMoreData == false) {
          log("moredata called");
          provider.fetchAllNotification();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NotificationController>(
        builder: (context, state, child) => CustomScrollView(
          controller: scrollcontroller,
          slivers: [
            const HeadingAppBar(heading: "Notifications", isBackButtomn: true),

            //showing notification list
            if (state.notificationList.isEmpty && state.fetchLoading)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Lottie.asset(ConstantIcons.lottieProgress,
                      height: 100, width: 100),
                ),
              )
            else if (state.notificationList.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text("No Notification Found!")),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Gap(10),
                  itemCount: state.notificationList.length,
                  itemBuilder: (context, index) => RefreshIndicator(
                    onRefresh: state.fetchAllNotification,
                    child: NotificationFrame(
                      notification: state.notificationList[index],
                    ),
                  ),
                ),
              ),
            //lazy loading
            SliverToBoxAdapter(
              child: (state.fetchLoading == true &&
                      state.notificationList.isNotEmpty)
                  ? Lottie.asset(ConstantIcons.lottieProgress,
                      height: 100, width: 100)
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
