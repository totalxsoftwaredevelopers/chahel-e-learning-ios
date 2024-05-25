import 'dart:developer';

import 'package:chahele_project/model/payment_gateway_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PaymentGatewayProvider with ChangeNotifier {
  final firebase = FirebaseFirestore.instance;

  PaymentGatewayModel? gatewayData;

  //-------FETCH GATEWAY COMPONENTS
  Future<void> fetchGatewayKeys() async {
    try {
      final response = await firebase
          .collection('payment_gateway')
          .doc('payment_phonepe')
          .get();

      if (response.exists) {
        gatewayData = PaymentGatewayModel.fromMap(response.data()!);
      } else {
        log("No Data Found in gateway");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
