class PaymentGatewayModel {
  String? id;
  String merchantId;
  String saltIndex;
  String saltKey;
  bool isWhatsApp;
  bool iosJoin;
  PaymentGatewayModel({
    this.id,
    required this.merchantId,
    required this.saltIndex,
    required this.saltKey,
    required this.isWhatsApp,
    required this.iosJoin,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'merchantId': merchantId,
      'saltIndex': saltIndex,
      'saltKey': saltKey,
      'isWhatsApp': isWhatsApp,
      'iosJoin': iosJoin,
    };
  }

  factory PaymentGatewayModel.fromMap(Map<String, dynamic> map) {
    return PaymentGatewayModel(
      id: map['id'] != null ? map['id'] as String : null,
      merchantId: map['merchantId'] as String,
      saltIndex: map['saltIndex'] as String,
      saltKey: map['saltKey'] as String,
      isWhatsApp: map['isWhatsApp'] as bool,
      iosJoin: map['iosJoin'] as bool,
    );
  }

  PaymentGatewayModel copyWith({
    String? id,
    String? merchantId,
    String? saltIndex,
    String? saltKey,
    bool? isWhatsApp,
    bool? iosJoin,
  }) {
    return PaymentGatewayModel(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      saltIndex: saltIndex ?? this.saltIndex,
      saltKey: saltKey ?? this.saltKey,
      isWhatsApp: isWhatsApp ?? this.isWhatsApp,
      iosJoin: iosJoin ?? this.iosJoin,
    );
  }
}
