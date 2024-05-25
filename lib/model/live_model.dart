class LiveModel {
  String? id;
  bool? isLiveNow;
  String link;
  LiveModel({
    this.id,
    required this.isLiveNow,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'isLiveNow': isLiveNow,
      'link': link,
    };
  }

  factory LiveModel.fromMap(Map<String, dynamic> map) {
    return LiveModel(
      id: map['id'] != null ? map['id'] as String : null,
      isLiveNow: map['isLiveNow'] as bool,
      link: map['link'] as String,
    );
  }

  LiveModel copyWith({
    String? id,
    bool? isLiveNow,
    String? link,
  }) {
    return LiveModel(
      id: id ?? this.id,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      link: link ?? this.link,
    );
  }
}
