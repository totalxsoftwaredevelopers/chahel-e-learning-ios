import 'package:chahele_project/model/plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String phoneNumber;
  String? dob;
  String? email;
  String? age;
  String? id;
  String? image;
  String? guardianName;
  Timestamp? createdAt;
  String? schoolName;
  bool? isUserActive;
  List<PlanModel>? purchaseDetails;
  List<String>? keywords;
  UserModel(
      {required this.name,
      required this.phoneNumber,
      this.dob,
      required this.email,
      required this.age,
      required this.id,
      required this.image,
      this.guardianName,
      this.schoolName,
      this.isUserActive,
      this.purchaseDetails,
      this.keywords,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'email': email,
      'age': age,
      'id': id,
      'image': image,
      'guardianName': guardianName,
      'schoolName': schoolName,
      'isUserActive': isUserActive,
      'purchaseDetails': purchaseDetails,
      'keywords': keywords,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      phoneNumber: map['phoneNumber'] as String,
      dob: map['dob'] != null ? map['dob'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      age: map['age'] != null ? map['age'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      guardianName:
          map['guardianName'] != null ? map['guardianName'] as String : null,
      schoolName:
          map['schoolName'] != null ? map['schoolName'] as String : null,
      isUserActive:
          map['isUserActive'] != null ? map['isUserActive'] as bool : null,
      purchaseDetails: map['purchaseDetails'] != null
          ? List<PlanModel>.from(
              (map['purchaseDetails'] as List<dynamic>).map<PlanModel?>(
                (x) => PlanModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      keywords: map['keywords'] != null
          ? List<String>.from(map['keywords'] as List<dynamic>)
          : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }

  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? dob,
    String? email,
    String? age,
    String? id,
    String? image,
    String? guardianName,
    String? schoolName,
    bool? isUserActive,
    Timestamp? createdAt,
    List<PlanModel>? purchaseDetails,
    List<String>? keywords,
  }) {
    return UserModel(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      email: email ?? this.email,
      age: age ?? this.age,
      id: id ?? this.id,
      image: image ?? this.image,
      guardianName: guardianName ?? this.guardianName,
      schoolName: schoolName ?? this.schoolName,
      isUserActive: isUserActive ?? this.isUserActive,
      purchaseDetails: purchaseDetails ?? this.purchaseDetails,
      keywords: keywords ?? this.keywords,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
