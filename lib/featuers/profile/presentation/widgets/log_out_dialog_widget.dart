// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogOutDialogWidget extends StatelessWidget {
  const LogOutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
      ),
      elevation: 10,
      title: Center(
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/log-out.svg',
              width: 30,
              height: 30,
              color: AppColors.red,
            ),
            SizedBox(height: 20),
            Text(
              Utils.localize('ConfirmLogout'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87, 
              ),
            ),
          ],
        ),
      ),
      content: Text(
        Utils.localize('AreYouSureLogout'),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[700],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor:
                      Colors.grey[200],
                ),
                child: Text(
                  Utils.localize('No'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(width: 30), 
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('isLoggedIn'); 

                  Get.offAllNamed(AppRouter.login);

                  Get.snackbar(
                    Utils.localize('LogoutSuccess'),
                    Utils.localize('WeWillMissYou'),
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 3),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.redAccent, 
                ),
                child: Text(
                  Utils.localize('Yes'),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}