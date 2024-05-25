// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? id;
  String image;
  Timestamp timestamp;
  BannerModel({
    this.id,
    required this.image,
    required this.timestamp,
  });

  BannerModel copyWith({
    String? id,
    String? image,
    Timestamp? timestamp,
  }) {
    return BannerModel(
      id: id ?? this.id,
      image: image ?? this.image,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'timestamp': timestamp,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] != null ? map['id'] as String : null,
      image: map['image'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
