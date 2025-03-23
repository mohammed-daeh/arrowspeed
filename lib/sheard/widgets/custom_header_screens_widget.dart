// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/featuers/home/presentation/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HeaderScreensInItemsProfile extends StatelessWidget {
  String? title;
  double? height;
  HeaderScreensInItemsProfile({super.key, this.title, this.height});
  final BottomNavController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: AppColors.prussianBlue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/arrow-left.svg',
                    width: 15,
                    height: 15,
                    color: AppColors.white,
                  ),
                ),
                Spacer(),
                Text(
                  title ?? '',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1),
                ),
                Spacer(),
                SizedBox(
                  width: 15,
                )
              ],
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}
