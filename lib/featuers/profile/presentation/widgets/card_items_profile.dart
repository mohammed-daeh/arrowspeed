// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardItemsProfile extends StatelessWidget {
  String pathIcon;
  String title;
  VoidCallback onTap;
  CardItemsProfile(
      {super.key,
      required this.pathIcon,
      required this.title,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: AppColors.greyHintForm,
                    blurRadius: 10,
                    offset: Offset(0, 2))
              ],
              color: AppColors.white,
              border: Border.symmetric(
                  horizontal: BorderSide(color: AppColors.greyHintForm))),
          child: Row(
            children: [
              SvgPicture.asset(
                pathIcon,
                width: 20,
                height: 20,
                color: AppColors.oxfordBlue,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.oxfordBlue,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
