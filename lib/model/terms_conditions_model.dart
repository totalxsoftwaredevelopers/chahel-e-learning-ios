class TermsAndConditionsmodel {
  int? averageMark;
  String? id;
  int? numberOfquestion;
  String? topic;
  int? totalMark;
  int? totalTime;
  String secId;
  TermsAndConditionsmodel({
    this.averageMark,
    this.id,
    this.numberOfquestion,
    this.topic,
    this.totalMark,
    this.totalTime,
    required this.secId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'averageMark': averageMark,
      'id': id,
      'numberOfquestion': numberOfquestion,
      'topic': topic,
      'totalMark': totalMark,
      'totalTime': totalTime,
      'secId': secId,
    };
  }

  factory TermsAndConditionsmodel.fromMap(Map<String, dynamic> map) {
    return TermsAndConditionsmodel(
      averageMark:
          map['averageMark'] != null ? map['averageMark'] as int : null,
      id: map['id'] != null ? map['id'] as String : null,
      numberOfquestion: map['numberOfquestion'] != null
          ? map['numberOfquestion'] as int
          : null,
      topic: map['topic'] != null ? map['topic'] as String : null,
      totalMark: map['totalMark'] != null ? map['totalMark'] as int : null,
      totalTime: map['totalTime'] != null ? map['totalTime'] as int : null,
      secId: map['secId'] as String? ?? "",
    );
  }

  TermsAndConditionsmodel copyWith({
    int? averageMark,
    String? id,
    int? numberOfquestion,
    String? topic,
    int? totalMark,
    int? totalTime,
    String? secId,
  }) {
    return TermsAndConditionsmodel(
      averageMark: averageMark ?? this.averageMark,
      id: id ?? this.id,
      numberOfquestion: numberOfquestion ?? this.numberOfquestion,
      topic: topic ?? this.topic,
      totalMark: totalMark ?? this.totalMark,
      totalTime: totalTime ?? this.totalTime,
      secId: secId ?? this.secId,
    );
  }
}
