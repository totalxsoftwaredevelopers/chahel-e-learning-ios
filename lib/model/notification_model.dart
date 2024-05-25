import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String title;
  String? image;
  String content;
  String? id;
  Timestamp? timestamp;

  NotificationModel({
    required this.title,
    this.image,
    required this.content,
    this.timestamp,
    this.id,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      content: map['content'] as String,
      timestamp: map['timestamp'] as Timestamp?,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  NotificationModel copyWith({
    String? title,
    String? image,
    String? content,
    String? id,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      image: image ?? this.image,
      content: content ?? this.content,
      id: id ?? this.id,
    );
  }
}
