import 'dart:convert';
import 'dart:developer';

import 'package:chahele_project/controller/payment_gateway_controller.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/utils/constant_icons/constant_icons.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePePaymentGateway extends StatefulWidget {
  const PhonePePaymentGateway(
      {super.key,
      required this.onSuccess,
      required this.onFailure,
      required this.gatewayController,
      required this.planController,
      required this.paymentAmount});

  final PaymentGatewayProvider gatewayController;
  final PlanController planController;
  final int paymentAmount;
  // final PaymentGatewayProvider gatewayController;

  final void Function() onSuccess;
  final void Function() onFailure;

  @override
  State<PhonePePaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PhonePePaymentGateway> {
  String environment = "SANDBOX";
  String appId = "";
  // String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;
  String checkSum = "";
  // String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  String callbackUrl =
      "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay";

  String body = "";

  Object? result;
  String apiEndPoint = "/pg/v1/pay";
//-----TO GET CHECK SUM VALUE
  getCheckSum() {
    final requestData = {
      "merchantId": widget.gatewayController.gatewayData!.merchantId,
      "merchantTransactionId": "transaction_123",
      "merchantUserId": "90223250",
      "amount": widget.paymentAmount * 100,
      "mobileNumber": "9999999999",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"},
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checkSum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + widget.gatewayController.gatewayData!.saltKey)).toString()}###${widget.gatewayController.gatewayData!.saltIndex}';

    return base64Body;
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then(
      (_) {
        startPgTransaction(
          onSuccess: () => widget.onSuccess.call(),
          onFailure: () => widget.onFailure.call(),
        );
      },
    );
    log(widget.gatewayController.gatewayData!.saltKey);
    log(widget.gatewayController.gatewayData!.saltIndex);
    log(widget.gatewayController.gatewayData!.merchantId);

    phonepeInit();

    body = getCheckSum().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child:
          Lottie.asset(ConstantIcons.lottieProgress, height: 100, width: 100),
    ));
  }

//-----INITIALISING PHONEPE
  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId,
            widget.gatewayController.gatewayData!.merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

// -----TO START TRANSACTION
  void startPgTransaction(
      {required VoidCallback onSuccess,
      required VoidCallback onFailure}) async {
    PhonePePaymentSdk.startTransaction(body, callbackUrl, checkSum, "")
        .then((val) => {
              setState(() {
                if (val != null) {
                  String status = val['status'].toString();
                  String error = val['error'].toString();
                  if (status == 'SUCCESS') {
                    result = "Flow Completed - Status: Success!";
                    onSuccess();
                  } else {
                    result =
                        "Flow Completed - Status: $status and Error: $error";
                  }
                } else {
                  result = "Flow Incomplete";
                  onFailure();
                }
              })
            })
        .catchError((error) {
      return <dynamic>{};
    });
  }

//------ERROR HANDLING
  void handleError(error) {
    setState(() {
      result = {"error": error};
    });
  }
}
