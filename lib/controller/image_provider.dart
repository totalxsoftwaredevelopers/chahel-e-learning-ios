import 'dart:io';

import 'package:chahele_project/model/user_plan_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickProvider with ChangeNotifier {
  final firebaseStorage = FirebaseStorage.instance;

  final imagePicker = ImagePicker();

  File? imageFile;
  String? imageUrl;

  bool isLoading = false;

  Future<void> pickImage({required VoidCallback onFailure}) async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      onFailure();
    } else {
      imageFile = File(pickedFile.path);
    }
    notifyListeners();
  }

  // void changeImage(File image) {
  //   imageFile = image;
  //   notifyListeners();
  // }

  Future<String?> uploadImage(File imageFile) async {
    isLoading = true;
    notifyListeners();

    final fileName = DateTime.now().microsecondsSinceEpoch;

    final storageReference = firebaseStorage.ref();

    Reference? imageReference = storageReference.child('users');

    final uploadReference = imageReference.child(fileName.toString());

    await uploadReference.putFile(
        imageFile, SettableMetadata(contentType: 'image/png'));

    final downloadUrl = await uploadReference.getDownloadURL();

    isLoading = false;
    notifyListeners();

    return downloadUrl;
  }

  Future<void> saveImage(File imageFile, VoidCallback onSuccess) async {
    isLoading = true;
    notifyListeners();
    String? url = await uploadImage(imageFile);

    if (url != null) {
      imageUrl = url;
      notifyListeners();
    }

    isLoading = false;
    onSuccess();

    notifyListeners();
  }

  void clearImage() {
    imageUrl = null;
    notifyListeners();
  }

  void editUserImage(UserPlanModel editImage) {
    imageUrl = editImage.image;
    notifyListeners();
  }
}
