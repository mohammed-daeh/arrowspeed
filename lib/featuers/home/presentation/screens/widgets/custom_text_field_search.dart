// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFieldSearch extends StatelessWidget {
  const CustomTextFieldSearch({
    super.key,
    required this.hintText,
    required this.iconPath,
    this.isDatePicker = false,
    this.controller,
    this.readOnly = true, 
    this.onTap,
    this.iconOnTap,
  });

  final String hintText;
  final String iconPath;
  final bool isDatePicker;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? iconOnTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 10),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.grey1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 25),
            const SizedBox(width: 10),
            Container(
              height: 20,
              width: 1,
              color: AppColors.greyHintForm,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                readOnly: readOnly,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: AppColors.grey1),
                  border: InputBorder.none,
                ),
                onTap: onTap,
              ),
            ),
            InkWell(
              onTap: iconOnTap,
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                width: 15,
                color: AppColors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
