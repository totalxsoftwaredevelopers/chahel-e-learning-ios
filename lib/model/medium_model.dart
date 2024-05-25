// ignore_for_file: public_member_api_docs, sort_constructors_first

class MediumModel {
  String medium;
  String image;
  String? id;
  String stdId;
  MediumModel({
    required this.medium,
    required this.image,
    this.id,
    required this.stdId,
  });

  MediumModel copyWith({
    String? medium,
    String? image,
    String? id,
    String? stdId,
  }) {
    return MediumModel(
      medium: medium ?? this.medium,
      image: image ?? this.image,
      id: id ?? this.id,
      stdId: stdId ?? this.stdId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'medium': medium,
      'image': image,
      'id': id,
      'stdId': stdId,
    };
  }

  factory MediumModel.fromMap(Map<String, dynamic> map) {
    return MediumModel(
      medium: map['medium'] as String,
      image: map['image'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      stdId: map['stdId'] as String,
    );
  }

  @override
  bool operator ==(covariant MediumModel other) {
    if (identical(this, other)) return true;

    return other.medium == medium &&
        other.image == image &&
        other.id == id &&
        other.stdId == stdId;
  }

  @override
  int get hashCode {
    return medium.hashCode ^ image.hashCode ^ id.hashCode ^ stdId.hashCode;
  }
}
