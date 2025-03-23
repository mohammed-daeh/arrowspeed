// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/components/pop_menu_translation.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/auth/presentation/controllers/creat_account_controllers.dart';
import 'package:arrowspeed/featuers/auth/presentation/screens/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreatAccountScreen extends GetView<CreateAccountController> {
  const CreatAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 30),
              child: Column(
                children: [
                
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                      ),

                      Spacer(),
                      SvgPicture.asset(
                        'assets/logo/logo_onBoarding.svg',
                        color: AppColors.oxfordBlue,
                        width: 70,
                        height: 70,
                      ),
                      Spacer(),
                      PopMenuTranslation(),
                    ],
                  ),
                 
                  SizedBox(height: 20),
                  Text(
                    Utils.localize('createAccount'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    Utils.localize('WelcomeToArrowSpeed'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomTextFormField(
                    label: controller.firstNameError.value ??
                        Utils.localize('FirstName'),
                    controller: controller.firstName,
                    errorText: controller.firstNameError.value,
                    onChanged: (v) => controller.validateField(
                      controller.firstName,
                      () => controller.validateName(v),
                      controller.firstNameError,
                    ),
                  ),
                  CustomTextFormField(
                    label: controller.lastNameError.value ??
                        Utils.localize('LastName'),
                    controller: controller.lastName,
                    errorText: controller.lastNameError.value,
                    onChanged: (v) => controller.validateField(
                      controller.lastName,
                      () => controller.validateName(v),
                      controller.lastNameError,
                    ),
                  ),
                  CustomTextFormField(
                    label: controller.emailError.value ??
                        Utils.localize('EmailApp'),
                    controller: controller.email,
                    hintText: 'Example@arrowspeed.com',
                    prefixIcon: 'assets/icons/mail.svg',
                    errorText: controller.emailError.value,
                    onChanged: (v) => controller.validateField(
                      controller.email,
                      () => controller.validateEmail(v),
                      controller.emailError,
                    ),
                  ),
                  CustomTextFormField(
                    label: controller.gmailError.value ??
                        Utils.localize('yourGmail'),
                    controller: controller.gmail,
                    hintText: 'Example@gmail.com',
                    prefixIcon: 'assets/icons/gmail.svg',
                    errorText: controller.gmailError.value,
                    onChanged: (v) => controller.validateField(
                      controller.gmail,
                      () => controller.validateGmail(v),
                      controller.gmailError,
                    ),
                  ),
                  CustomTextFormField(
                    label: controller.passwordError.value ??
                        Utils.localize('PassWord'),
                    isPassword: true,
                    controller: controller.password,
                    prefixIcon: 'assets/icons/key.svg',
                    errorText: controller.passwordError.value,
                    onChanged: (v) => controller.validateField(
                      controller.password,
                      () => controller.validatePassword(v),
                      controller.passwordError,
                    ),
                  ),
                  CustomTextFormField(
                    label: controller.confirmPasswordError.value ??
                        Utils.localize('ConfirmPassword'),
                    isPassword: true,
                    controller: controller.confirmPassword,
                    prefixIcon: 'assets/icons/key.svg',
                    errorText: controller.confirmPasswordError.value,
                    onChanged: (v) => controller.validateField(
                      controller.confirmPassword,
                      () => controller.validateConfirmPassword(v),
                      controller.confirmPasswordError,
                    ),
                  ),
                  CustomTextFormField(
                    label: controller.mobileNumberError.value ??
                        Utils.localize('MobileNumber'),
                    controller: controller.mobilNumber,
                    isPhoneNumber: true,
                    prefixIcon: 'assets/icons/phone.svg',
                    errorText: controller.mobileNumberError.value,
                    onChanged: (v) => controller.validateField(
                      controller.mobilNumber,
                      () => controller.validateMobile(v),
                      controller.mobileNumberError,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        Utils.localize('Gender'),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Obx(() => controller.genderError.value != null
                          ? Text(' *', style: TextStyle(color: Colors.red))
                          : SizedBox()),
                      Spacer(),
                      _buildGenderOption(
                        label: 'Male',
                        icon: Icons.male,
                        value: 'male',
                      ),
                      SizedBox(width: 20),
                      _buildGenderOption(
                        label: 'Female',
                        icon: Icons.female,
                        value: 'female',
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                await controller.createUser();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mountainMeadow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 50,
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  Utils.localize('createAccount'),
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      )),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Utils.localize('Already'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          Get.offAllNamed(AppRouter.login);
                        },
                        child: Text(
                          Utils.localize('LogIn'),
                          style: TextStyle(
                            color: AppColors.oxfordBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    child: Text(
                      textAlign: TextAlign.center,
                      Utils.localize('Privacy'),
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectedGender.value = value,
          child: Row(
            children: [
              Text(
                Utils.localize(label),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color:
                      controller.genderError.value != null ? Colors.red : null,
                ),
              ),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: controller.selectedGender.value == value
                      ? AppColors.oxfordBlue
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                  border: controller.genderError.value != null
                      ? Border.all(color: Colors.red, width: 2)
                      : null,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: controller.selectedGender.value == value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ));
  }
}
