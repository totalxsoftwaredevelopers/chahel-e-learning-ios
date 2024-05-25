import 'package:chahele_project/model/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerController with ChangeNotifier {
  final firebase = FirebaseFirestore.instance;
  bool isLoading = false;

  List<BannerModel> banners = [];

  Future<void> fetchBanner() async {
    isLoading = true;
    notifyListeners();

    final responce = await firebase
        .collection('banners')
        .orderBy('timestamp', descending: true)
        .get();

    banners = responce.docs
        .map((e) => BannerModel.fromMap(e.data()).copyWith(id: e.id))
        .toList();
    isLoading = false;
    notifyListeners();
  }
}
