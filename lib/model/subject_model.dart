class SubjectModel {
  String subject;
  String image;
  String? id;
  String medId;
  String stdId;
  SubjectModel({
    required this.subject,
    required this.image,
    this.id,
    required this.medId,
    required this.stdId,
  });

  SubjectModel copyWith({
    String? subject,
    String? image,
    String? id,
    String? medId,
    String? stdId,
  }) {
    return SubjectModel(
      subject: subject ?? this.subject,
      image: image ?? this.image,
      id: id ?? this.id,
      medId: medId ?? this.medId,
      stdId: stdId ?? this.stdId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject,
      'image': image,
      'id': id,
      'medId': medId,
      'stdId': stdId,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      subject: map['subject'] as String,
      image: map['image'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      medId: map['medId'] as String,
      stdId: map['stdId'] as String,
    );
  }
}
