// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';

// class CountryPickWid extends StatefulWidget {
//   const CountryPickWid({
//     Key? key,
//     required this.onCodeChanged,
//   }) : super(key: key);

//   final ValueChanged<String> onCodeChanged;

//   @override
//   _CountryPickWidState createState() => _CountryPickWidState();
// }

// class _CountryPickWidState extends State<CountryPickWid> {
//   late String countryCode;

//   @override
//   void initState() {
//     super.initState();

//     countryCode = '+91';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CountryCodePicker(
//       flagWidth: 20,
//       boxDecoration: const BoxDecoration(),
//       padding: const EdgeInsets.symmetric(horizontal: 0),
//       initialSelection: 'IN',
//       favorite: const ['IN', 'US', '+974', '+966', '+971', 'UK'],
//       showFlag: true,
//       showFlagMain: false,
//       onChanged: (value) {
//         setState(() {
//           countryCode = value.dialCode!;
//           widget.onCodeChanged(countryCode);
//         });
//       },
//     );
//   }
// }
