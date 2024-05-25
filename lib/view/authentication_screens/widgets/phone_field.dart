import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.authProvider,
    required this.phoneNumberController,
  });

  final AuthenticationProvider authProvider;
  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      disableLengthCheck: true,
      showCountryFlag: false,
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: ConstantColors.white,
        countryNameStyle: const TextStyle(fontWeight: FontWeight.w500),
        searchFieldPadding: const EdgeInsets.all(8),
      ),
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: (value) {
        authProvider.countryCode(value);
      },
      controller: phoneNumberController,
      initialCountryCode: 'IN',
      keyboardType: TextInputType.number,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 13),
        filled: true,
        fillColor: ConstantColors.white,
        hintText: "Number goes here",
        hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
