import 'package:cloud_firestore/cloud_firestore.dart';

class StandardModel {
  String standard;
  String image;
  String? id;
  Timestamp? isCreated;
  StandardModel({
    required this.standard,
    required this.image,
    this.id,
    this.isCreated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'standard': standard,
      'image': image,
      'id': id,
      'isCreated': isCreated,
    };
  }

  factory StandardModel.fromMap(Map<String, dynamic> map) {
    return StandardModel(
      standard: map['standard'] as String,
      image: map['image'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      isCreated:
          map['isCreated'] != null ? map['isCreated'] as Timestamp : null,
    );
  }

  StandardModel copyWith({
    String? standard,
    String? image,
    String? id,
    Timestamp? isCreated,
  }) {
    return StandardModel(
      standard: standard ?? this.standard,
      image: image ?? this.image,
      id: id ?? this.id,
      isCreated: isCreated ?? this.isCreated,
    );
  }
}
