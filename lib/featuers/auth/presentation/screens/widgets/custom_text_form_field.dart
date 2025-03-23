
// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:arrowspeed/core/app_colors/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? prefixIcon;
  final double? sizPrefixIcon;
  final bool? isPhoneNumber;
  final bool isRequired;
  final String? Function(String?)? validator;
  final String? errorText;
  final String? hintText;
  //onchang
  final ValueChanged<String>? onChanged;

  const CustomTextFormField(
      {super.key,
      required this.label,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isPassword = false,
      this.prefixIcon,
      this.sizPrefixIcon,
      this.isPhoneNumber = false,
      this.isRequired = false,
      this.validator,
      this.errorText,
      this.onChanged,
      this.hintText});

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isObscured = true;
  bool isValidated = false;

 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: widget.isPhoneNumber == true
            ? TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                onChanged: widget.onChanged,

              
                inputFormatters: [PhoneInputFormatter()],
                decoration: _buildInputDecoration(),
              )
            : TextFormField(
                validator: widget.validator,
                controller: widget.controller,
                obscureText: widget.isPassword ? isObscured : false,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                decoration: _buildInputDecoration(),
              ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    Color borderColor = AppColors.greyIconForm;
    if (widget.errorText != null) {
      borderColor = AppColors.red;
    } else if (isValidated) {
      borderColor = AppColors.zomp;
    }

    return InputDecoration(
      labelText: widget.errorText ?? widget.label,
      hintText: widget.hintText,
      hintStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.oxfordBlue,
      ),
      labelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: widget.errorText != null ? AppColors.red : AppColors.zomp,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Padding(
              padding: const EdgeInsets.all(0.0),
              child: SvgPicture.asset(
                widget.prefixIcon!,
                color: widget.errorText != null
                    ? AppColors.red
                    : AppColors.greyIconForm,
                fit: BoxFit.scaleDown,
              ),
            )
          : null,
      suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                isObscured ? Icons.visibility_off : Icons.visibility,
                color: AppColors.greyborder,
              ),
              onPressed: () {
                setState(() {
                  isObscured = !isObscured;
                });
              },
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: AppColors.oxfordBlue,
          width: 1,
        ),
      ),
      filled: true,
      fillColor: AppColors.white,
    );
  }
}
