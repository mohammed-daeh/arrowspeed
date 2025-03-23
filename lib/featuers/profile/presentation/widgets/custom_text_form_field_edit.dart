
 import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormFieldEdit extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEnabled;
  final bool isPhoneNumber;
  final Function()? onEditPressed;

  const CustomTextFormFieldEdit({
    super.key,
    required this.label,
    required this.controller,
    this.isEnabled = false,
    this.isPhoneNumber = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 62,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: TextFormField(
                controller: controller,
                enabled: isEnabled, 
                keyboardType:
                    isPhoneNumber ? TextInputType.phone : TextInputType.text,
                decoration: InputDecoration(
                  labelText: Utils.localize(label),
                  labelStyle: TextStyle(
                      color: AppColors.prussianBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: onEditPressed,
          child: SvgPicture.asset(
            'assets/icons/edit.svg',
            width: 15,
            height: 15,
          ),
        ),
      
      ],
    );
  }
}
