import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfScreen extends StatefulWidget {
  final String pdfUrl;
  final String lesson;
  const ViewPdfScreen({super.key, required this.pdfUrl, required this.lesson});

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  // File? pdfFile;

  // @override
  // void initState() {
  //   // pdfFile = File(widget.pdfPath);

  //   requestPermission();
  //   super.initState();
  // }

  // requestPermission() async {
  //   await Permission.storage.request();
  //   final status = await Permission.storage.isGranted;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstantColors.white,
        surfaceTintColor: ConstantColors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: ConstantColors.black,
              size: 22,
            )),
        leadingWidth: 36,
        iconTheme: const IconThemeData(color: ConstantColors.black),
        title: Text(
          widget.lesson,
          style: const TextStyle(
            color: ConstantColors.headingBlue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
      ),
    );
  }
}
