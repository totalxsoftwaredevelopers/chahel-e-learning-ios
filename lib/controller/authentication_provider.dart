import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_field/phone_number.dart';

class AuthenticationProvider with ChangeNotifier {
  //Firebase Auth Instance
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

//Loading
  bool isLoading = false;
//country code with number
  String? selectedCode;

  //Current User
  User? currentUser = FirebaseAuth.instance.currentUser;

//onChanged function country code
  void countryCode(PhoneNumber code) {
    selectedCode = code.countryCode;

    notifyListeners();
  }

  Future<User?> getCurrentUser() async {
    return firebaseAuth.currentUser;
  }

  //on skip login check user is logged in
  Future<bool> isUserAuthenticated() async {
    User? user = firebaseAuth.currentUser;
    return user != null;
  }

//check user entered details on skip
  Future<bool> isUserDetailsComplete() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firebaseFirestore.collection('users').doc(user.uid).get();
      Map<String, dynamic>? userData = snapshot.data();

      return userData != null &&
          userData['name'] != null &&
          userData['email'] != null;
    }
    return false;
  }

//Login
  Future<void> login({
    required String phoneNumber,
    required void Function(FirebaseAuthException) onFailure,
    required void Function(String) onSuccess,
  }) async {
    isLoading = true;
    notifyListeners();
    log('PHONE NUMEBR:$phoneNumber');
    try {
      await firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) {
            log("Verification Completed");
          },
          verificationFailed: (error) {
            log("Verification Failed $error");

            isLoading = false;
            notifyListeners();
            onFailure(error);
          },
          codeSent: (verificationId, forceResendingToken) {
            isLoading = false;
            notifyListeners();
            onSuccess(verificationId);
          },
          codeAutoRetrievalTimeout: (verificationId) {});

      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      log(e.code);
    }
  }

//Otp
  Future<void> verifyOtp({
    required void Function(String) onSuccess,
    required VoidCallback onFailure,
    required String verificationId,
    required String otpCode,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);

      await firebaseAuth.signInWithCredential(credential);

      //Notification
      await messaging.subscribeToTopic('All');

      onSuccess(verificationId);
      isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      onFailure();
    }
  }

//-----LOGOUT
  Future<void> logOutUser({VoidCallback? onSuccess}) async {
    await firebaseAuth.signOut();
    onSuccess!();
  }

  // Future<void> deleteUser() async {
  //   User? user = firebaseAuth.currentUser;

  //   try {
  //     if (user != null) {
  //       await user.delete();
  //       user = currentUser;
  //       log("User Deleted");
  //     } else {
  //       log("no user signed");
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     log(e.code.toString());
  //   }
  // }

//Check the user is already exist
  Future<void> checkUserexist(
      {required VoidCallback onExist, VoidCallback? onNewUser}) async {
    User? user = firebaseAuth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
          await firebaseFirestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        onExist();
      } else {
        onNewUser!();
      }
    }
  }

//OTP Resend
  Future<void> resendOTP(
      {required String phoneNumber, required VoidCallback onSuccess}) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber, // Replace with actual phone number
      timeout: Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        onSuccess();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  //notification Permission
  Future<void> notificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
