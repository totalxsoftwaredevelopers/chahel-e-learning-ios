class SectionModel {
  String? id;
  String sectionName;
  String description;
  String videoUrl;
  String pdfUrl;
  String stdId;
  String medId;
  String subId;
  String chapterId;
  String image;
  int? averageMark;
  int? numberOfquestion;
  String? topic;
  int? totalMark;
  int? totalTime;
  int sectionNumber;

  SectionModel({
    this.id,
    required this.sectionName,
    required this.description,
    required this.videoUrl,
    required this.pdfUrl,
    required this.stdId,
    required this.medId,
    required this.subId,
    required this.chapterId,
    required this.image,
    this.averageMark,
    this.numberOfquestion,
    this.topic,
    this.totalMark,
    this.totalTime,
    required this.sectionNumber,
  });

  SectionModel copyWith({
    String? id,
    String? sectionName,
    String? description,
    String? videoUrl,
    String? pdfUrl,
    String? stdId,
    String? medId,
    String? subId,
    String? chapterId,
    String? image,
    int? averageMark,
    int? numberOfquestion,
    String? topic,
    int? totalMark,
    int? totalTime,
    int? sectionNumber,
  }) {
    return SectionModel(
      id: id ?? this.id,
      sectionName: sectionName ?? this.sectionName,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      stdId: stdId ?? this.stdId,
      medId: medId ?? this.medId,
      subId: subId ?? this.subId,
      chapterId: chapterId ?? this.chapterId,
      image: image ?? this.image,
      averageMark: averageMark ?? this.averageMark,
      numberOfquestion: numberOfquestion ?? this.numberOfquestion,
      topic: topic ?? this.topic,
      totalMark: totalMark ?? this.totalMark,
      totalTime: totalTime ?? this.totalTime,
      sectionNumber: sectionNumber ?? this.sectionNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sectionName': sectionName,
      'description': description,
      'videoUrl': videoUrl,
      'pdfUrl': pdfUrl,
      'stdId': stdId,
      'medId': medId,
      'subId': subId,
      'chapterId': chapterId,
      'image': image,
      'averageMark': averageMark,
      'numberOfquestion': numberOfquestion,
      'topic': topic,
      'totalMark': totalMark,
      'totalTime': totalTime,
      'sectionNumber': sectionNumber,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      id: map['id'] != null ? map['id'] as String : null,
      sectionName: map['sectionName'] as String,
      description: map['description'] as String,
      videoUrl: map['videoUrl'] as String,
      pdfUrl: map['pdfUrl'] as String,
      stdId: map['stdId'] as String,
      medId: map['medId'] as String,
      subId: map['subId'] as String,
      chapterId: map['chapterId'] as String,
      image: map['image'] as String,
      averageMark:
          map['averageMark'] != null ? map['averageMark'] as int : null,
      numberOfquestion: map['numberOfquestion'] != null
          ? map['numberOfquestion'] as int
          : null,
      topic: map['topic'] != null ? map['topic'] as String : null,
      totalMark: map['totalMark'] != null ? map['totalMark'] as int : null,
      totalTime: map['totalTime'] != null ? map['totalTime'] as int : null,
      sectionNumber: map['sectionNumber'] as int,
    );
  }
}
