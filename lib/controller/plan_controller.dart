import 'dart:developer';

import 'package:chahele_project/model/medium_model.dart';
import 'package:chahele_project/model/plan_model.dart';
import 'package:chahele_project/model/standard_model.dart';
import 'package:chahele_project/model/user_plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlanController with ChangeNotifier {
  final firebase = FirebaseFirestore.instance;

  String? dropClassValue;
  String? dropMediumValue;
  // List<PlanModel> planList = [];
  List<MediumModel> planMediumList = [];
  List<MediumModel> userMediumList = [];
  List<StandardModel> planStandardList = [];

  UserPlanModel? userData;
  List<PlanModel> planList = [];
  MediumModel? mediumData;

  List<MediumModel> _mediumList = [];

  List<MediumModel> get mediumList => _mediumList;
  ////////////////////
  List<StandardModel> _stdList = [];

  List<StandardModel> get stdList => _stdList;
  ///////////////////////

  bool isLoading = false;

//-------------FETCH PLAN DETAILS

  Future<void> fetchPlanDetails(
      {required String stdId, required String medId}) async {
    try {
      final responce = await firebase
          .collection('plan')
          .where(
            Filter.and(
              Filter('stdId', isEqualTo: stdId),
              Filter('medId', isEqualTo: medId),
            ),
          )
          .get();

      planList = responce.docs
          .map((e) => PlanModel.fromMap(e.data()).copyWith(id: e.id))
          .toList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchPlanStandardData() async {
    isLoading = true;

    notifyListeners();

    dropClassValue = null;

    final responce = await firebase.collection('subjects').get();

    planStandardList = responce.docs
        .map((e) => StandardModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();

    isLoading = false;
    notifyListeners();
  }
//-----------FETCH MEDIUM DATA FOR DROPDOWN BUTTON IN PLAN SCREEN

  Future<void> fetchPlanMediumData(String id) async {
    log("PLAN LIST:${planMediumList.length}");
    isLoading = true;
    notifyListeners();

    dropMediumValue = null;

    final response =
        await firebase.collection('medium').where('stdId', isEqualTo: id).get();

    planMediumList = response.docs
        .map((e) => MediumModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();

    isLoading = false;
    notifyListeners();
  }

  //-------------TO ADD PLANS TO USER DOCUMENT

  Future<void> purchasePlanUser({
    required String userId,
    required PlanModel purchasedPlan,
    required VoidCallback onSuccess,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      Map<String, dynamic> planData = purchasedPlan.toMap();

      final userDoc = firebase.collection('users').doc(userId);

      await userDoc.update({
        'purchaseDetails': FieldValue.arrayUnion([planData]),
      });

      onSuccess();

      isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

//--------FETCH AVAILABLE PLANS FOR CURRENT USER

  Future<void> fetchUserPlans(String userId) async {
    final response = await firebase.collection('users').doc(userId).get();

    userData =
        UserPlanModel.fromMap(response.data()!).copyWith(id: response.id);

    notifyListeners();
  }
  ////////////////////////////////////////

  // Future<void> fetchUserPlansMedium(List<String?>? planList) async {
  //   if (planList!.isEmpty) return;

  //   List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];
  //   for (var medID in planList) {
  //     final d = firebase.collection('medium').doc(medID).get();
  //     futures.add(d);
  //   }
  //   final snapshots = await Future.wait(futures).then((value) {

  //   });
  // }

//---------STD'S AND MEDIUMS PURCHSED BY USER
  Future<void> fetchUserPlansMedium(List<String?>? planList) async {
    _mediumList = [];
    _stdList = [];
    notifyListeners();

    if (planList == null || planList.isEmpty) return;

    List<Future<DocumentSnapshot<Map<String, dynamic>>>> futures = [];
    for (var medID in planList) {
      if (medID != null) {
        final d = firebase.collection('medium').doc(medID).get();
        futures.add(d);
      }
    }

    List<Future<DocumentSnapshot<Map<String, dynamic>>>> planFutures = [];

    for (var stdId in planList) {
      if (stdId != null) {
        final d = firebase.collection('standards').doc(stdId).get();
        planFutures.add(d);
      }
    }

    final snapshots = await Future.wait(futures);
    final planSnapshots = await Future.wait(planFutures);

    for (var snapshot in snapshots) {
      if (snapshot.exists) {
        MediumModel data =
            MediumModel.fromMap(snapshot.data()!).copyWith(id: snapshot.id);

        _mediumList.add(data);
      }
    }

    for (var snapshot in planSnapshots) {
      if (snapshot.exists) {
        StandardModel data =
            StandardModel.fromMap(snapshot.data()!).copyWith(id: snapshot.id);

        _stdList.add(data);
      }
    }

    notifyListeners();
  }

  //--------FETCH MEDIUM DATA FROM USER PLAN

  Future<void> fetchMediumFromUser({
    required String medId,
  }) async {
    final response =
        await firebase.collection('medium').where('id', isEqualTo: medId).get();

    userMediumList = response.docs
        .map((e) => MediumModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();

    notifyListeners();
  }

  //--------------DELETE A PLAN WHEN DATE EXPIRED
  Future<void> checkAndDeleteExpiredPlans(String userId) async {
    try {
      final DocumentSnapshot userSnapshot =
          await firebase.collection('users').doc(userId).get();

      final Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        final List<dynamic> purchaseDetails =
            List<Map<String, dynamic>>.from(userData['purchaseDetails'] ?? []);

        final Timestamp currentDateTimestamp = Timestamp.now();

        final List<Map<String, dynamic>> updatedPurchaseDetails = [];

        for (var planDetail in purchaseDetails) {
          final Timestamp endDateTimestamp =
              planDetail['endDate'] as Timestamp; // Cast to Timestamp

          // Compare current date with end date
          if (currentDateTimestamp.seconds <= endDateTimestamp.seconds) {
            // If current date is not past end date, keep the plan detail
            updatedPurchaseDetails.add(planDetail);
          }
        }

        // Update the user document with the modified purchaseDetails list
        await userSnapshot.reference.update({
          'purchaseDetails': updatedPurchaseDetails,
        });
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }

//REdirect to whatsapp for purchase
  Future<void> redirectToWhatsapp(String whatsAppLink) async {
    String encodedUrl = Uri.encodeFull(whatsAppLink);

    if (await launchUrlString(encodedUrl)) {
      await launchUrl(Uri.parse(encodedUrl));
      LaunchMode.externalApplication;
    } else {
      throw 'Could not launch $encodedUrl';
    }
    notifyListeners();
  }

  //Privacy And policy
  Future<void> redirectToLink(
      {required String link, VoidCallback? onFailure}) async {
    String encodedUrl = Uri.encodeFull(link);

    try {
      if (await launchUrlString(encodedUrl)) {
        await launchUrl(Uri.parse(encodedUrl));
        LaunchMode.externalApplication;
      } else {
        onFailure!();
      }
    } on Exception catch (e) {
      onFailure!();
    }
    notifyListeners();
  }
}
