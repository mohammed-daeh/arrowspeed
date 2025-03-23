// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Get.offAllNamed(AppRouter.onBoarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.prussianBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              'assets/logo/logo_onBoarding.svg',
              height: 200,
            ),
            Text(
              'bus booking  redefined',
              style: TextStyle(color: AppColors.mountainMeadow, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
