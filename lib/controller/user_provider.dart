import 'dart:developer';

import 'package:chahele_project/model/user_model.dart';
import 'package:chahele_project/model/user_plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  final fireBase = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  // String userUid = FirebaseAuth.instance.currentUser!.uid;

  bool isLoading = false;
  UserPlanModel? user;
  List<UserModel> userList = [];
  UserModel? blockedUser;

//Userdetails Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final guardianNameController = TextEditingController();
  final schoolNameController = TextEditingController();

  Future<void> addUserDetails(
      {required VoidCallback onSuccess,
      required VoidCallback onFailure,
      required UserModel userModel}) async {
    isLoading = true;
    notifyListeners();
    try {
      await fireBase
          .collection('users')
          .doc(userModel.id)
          .set(userModel.toMap());

      // userList.add(userModel.copyWith(id: userModel.id));
      onSuccess();
      isLoading = false;
      notifyListeners();
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }

  void clearFields() {
    nameController.clear();
    dobController.clear();
    phoneNumberController.clear();
    emailController.clear();
    ageController.clear();
    guardianNameController.clear();
    schoolNameController.clear();
  }

  void setEditUserData(UserPlanModel editUser) {
    nameController.text = editUser.name!;
    dobController.text = editUser.dob!;
    emailController.text = editUser.email!;
    ageController.text = editUser.age!;
    guardianNameController.text = editUser.guardianName!;
    schoolNameController.text = editUser.schoolName!;
  }

  // Future<void> fetchUser() async {
  //   final responce = await fireBase.collection('users').get();

  //   userList = responce.docs
  //       .map((e) => UserModel.fromMap(e.data()).copyWith(id: e.id))
  //       .toList();
  // }

  Future<UserModel?> getUserDetails() async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user == null) {
        return null;
      }

      final snapshot = await fireBase
          .collection('users')
          .where("id", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final userData = snapshot.docs
          .map((e) => UserModel.fromMap(e.data()).copyWith(id: e.id))
          .single;

      return userData;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  //FETCH USER DATA

  void fetchUserData() {
    final _userId = firebaseAuth.currentUser;
    if (_userId == null) return;
    fireBase.collection('users').doc(_userId.uid).snapshots().listen((event) {
      final userData = event.data();
      if (userData != null) {
        user = UserPlanModel.fromMap(userData as Map<String, dynamic>);
      }
    });
  }

  //Delete user
  Future<void> deleteUser(
      {required String id, required VoidCallback onSuccess}) async {
    await fireBase.collection("users").doc(id).delete();
    onSuccess();
  }

//Update UserDetails
  Future<void> updateUserDetails({
    required String? id,
    required UserPlanModel userModel,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> userData = userModel.toMap();

      // Update the document in Firestore
      await fireBase.collection('users').doc(id).update(userData);

      onSuccess();
    } on FirebaseException catch (e) {
      onFailure();
      log(e.message.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> getUserDetailsBlocked(String phoneNumber) async {
  //   try {
  //     final snapshot = await fireBase
  //         .collection('users')
  //         .where("phoneNumber", isEqualTo: phoneNumber)
  //         .limit(1)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       final user = snapshot.docs
  //           .map((e) => UserModel.fromMap(e.data()).copyWith(id: e.id))
  //           .single;
  //       blockedUser = user;
  //     } else {
  //       log("No user found");
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log("Error fetching user details: $e");
  //     // Handle the error accordingly
  //   }
  // }

  //KEYWORDS OF NAME FOR SEARCH
  List<String> keywordsBuilder(String convertName) {
    final filteredKeyword =
        convertName.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
    List<String> words = filteredKeyword.split(" ");
    List<String> substrings = [];
    for (String word in words) {
      String currentSubstring = "";
      for (int i = 0; i < word.length; i++) {
        currentSubstring += word[i];
        substrings.add(currentSubstring.toLowerCase());
      }
      substrings.add(word.toLowerCase());
    }
    if (!words.contains("")) {
      substrings.add(filteredKeyword.replaceAll(' ', '').toLowerCase());
    }
    substrings = substrings.toSet().toList();
    substrings.remove('');
    substrings.sort();

    return substrings;
  }

  List<String> combinedKeywords(
      {required String name, required String phoneNumber}) {
    final nameKewords = keywordsBuilder(name);
    final phonekeywords = keywordsBuilder(phoneNumber);

    List<String> combinedKeywords = [];
    combinedKeywords.addAll(nameKewords);
    combinedKeywords.addAll(phonekeywords);

    return combinedKeywords;
  }
}
