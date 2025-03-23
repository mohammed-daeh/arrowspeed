// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, library_private_types_in_public_api

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/components/pop_menu_translation.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/auth/presentation/controllers/log_in_controller.dart';
import 'package:arrowspeed/featuers/auth/presentation/screens/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopMenuTranslation(),
                  SizedBox(width: 20),
                ],
              ),
            ),
            SizedBox(height: 100),
            SvgPicture.asset(
              'assets/logo/logo_onBoarding.svg',
              color: AppColors.oxfordBlue,
              width: 80,
              height: 80,
            ),
            SizedBox(height: 20),
            Text(
              Utils.localize('LogIn'),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16, top: 66),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => CustomTextFormField(
                        label: controller.loginEmailError.value ??
                            Utils.localize('Email'),
                        controller: controller.loginEmailController,
                        prefixIcon: 'assets/icons/mail.svg',
                        isRequired: true,
                        errorText: controller.loginEmailError.value,
                      )),
                  SizedBox(height: 20),
                  Obx(() => CustomTextFormField(
                        label: controller.passwordError.value ??
                            Utils.localize('PassWord'),
                        isPassword: true,
                        controller: controller.passwordController,
                        prefixIcon: 'assets/icons/key.svg',
                        isRequired: true,
                        errorText: controller.passwordError.value,
                      )),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      Utils.localize('ForgetPassword'),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.zomp),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Obx(() => InkWell(
                    onTap: controller.isLoading.value ? null : controller.login,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.mountainMeadow,
                          borderRadius: BorderRadius.circular(5)),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: AppColors.white)
                          : Text(
                              Utils.localize('LogIn'),
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Utils.localize('NoAccount'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: 5),
                  InkWell(
                    onTap: () => Get.offAllNamed(AppRouter.signUp),
                    child: Text(
                      Utils.localize('createAccount'),
                      style: TextStyle(
                          color: AppColors.oxfordBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                textAlign: TextAlign.center,
                Utils.localize('Privacy'),
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
