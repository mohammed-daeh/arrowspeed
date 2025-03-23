// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HeaderProfile extends StatelessWidget {
  final String email;
  final String firstName;
  final String lastName;
  final Widget widget;

  const HeaderProfile(
      {super.key,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(color: AppColors.oxfordBlue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            Utils.localize('Profile'),
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.white),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              children: [
                widget,
               
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$firstName $lastName',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                   
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRouter.editProfile);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/edit.svg',
                    color: AppColors.white,
                    width: 15,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget buildImage(String imagePath) {
  if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
    return Image.file(File(imagePath));
  } else {
    return Icon(Icons.person, size: 50); 
  }
}
