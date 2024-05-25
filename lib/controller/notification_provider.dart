import 'dart:developer';

import 'package:chahele_project/model/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationController with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final firebeseMessaging = FirebaseMessaging.instance;

  final scrollcontroller = ScrollController();

  List<NotificationModel> notificationList = [];

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  bool fetchLoading = false;

  //FETCH ALL NOTIFICATION
  Future<void> fetchAllNotification() async {
    if (noMoreData || fetchLoading) return;
    fetchLoading = true;
    notifyListeners();

    int limit = lastDoc == null ? 15 : 5;
    try {
      Query query = firestore
          .collection('notification')
          .orderBy('timestamp', descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }
      query = query.limit(limit);
      final snapshot = await query.get();

      if (snapshot.docs.length < limit) {
        noMoreData = true;
      } else {
        lastDoc = snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }
      final getNotification = snapshot.docs
          .map((e) =>
              NotificationModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      notificationList.addAll(getNotification);
      notifyListeners();
    } catch (er) {
      log("ERROR IN:$er");
    }
    fetchLoading = false;
    notifyListeners();
  }

  Future<void> refreshUi() async {
    clearData();
    fetchAllNotification();
  }

  void clearData() {
    lastDoc = null;
    noMoreData = false;
    notificationList = [];
    notifyListeners();
  }

  initFunction() {
    if (notificationList.isEmpty) {
      clearData();
      fetchAllNotification();
    }
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.atEdge &&
          scrollcontroller.position.pixels != 0 &&
          fetchLoading == false &&
          noMoreData == false) {
        log("moredata called");
        fetchAllNotification();
      }
    });
  }

  // Future<void> notificationPermission() async {
  //   NotificationSettings settings = await firebeseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   final token = await firebeseMessaging.getToken();
  // }
}
