// ignore_for_file: avoid_print

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/auth/presentation/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: SvgPicture.asset('assets/images/otp.svg'),
              ),
              SizedBox(height: 30),
              Text(
                Utils.localize('OTPVerification'),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.prussianBlue,
                ),
              ),
              Text(
                Utils.localize('EnterTheOTPSentTo'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      controller.loginEmail.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.zomp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: _showEditEmailDialog,
                    child: SvgPicture.asset(
                      'assets/icons/edite_pin.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              PinCodeTextField(
              
                appContext: context,
                length: 6,
                cursorWidth: 40, cursorHeight: 40,
                autoDismissKeyboard: true,

                keyboardType: TextInputType.number,

                textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  controller.enteredOTP.value = value;
                  print("Entered OTP: $value");
                },
                onCompleted: (value) {
                  controller.enteredOTP.value = value;
                  print("✅ تم إدخال رمز OTP بالكامل: $value");
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.underline,

                  fieldHeight: 50,
                  fieldWidth: 50,

                  activeColor: AppColors.oxfordBlue, 
                  inactiveColor: Colors.grey, 
                  selectedColor: AppColors.mountainMeadow, 
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Utils.localize('DidntyoureceivetheOTP'),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Obx(() => InkWell(
                        onTap: controller.isVerifying.value
                            ? null
                            : () async {
                                controller.isVerifying.value = true;
                                await controller.resendOTP();
                              },
                        child: Text(
                          controller.isVerifying.value
                              ? Utils.localize('ResendingOTP')
                              : Utils.localize('ResendOTP'),
                          style: TextStyle(color: AppColors.oxfordBlue),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 70),
              Obx(() {
                return InkWell(
                  onTap: controller.isVerifying.value
                      ? null
                      : () async {
                          if (controller.enteredOTP.value!.length == 6) {
                            try {
                              controller.isVerifying.value = true;

                              await Future.delayed(Duration(seconds: 1));

                              await controller.verifyOtp();
                            } catch (e) {
                              Get.back();

                              Get.snackbar("خطأ", e.toString(),
                                  backgroundColor: Colors.red);
                            } finally {
                              controller.isVerifying.value = false;
                            }
                          } else {
                            Get.snackbar(
                                "خطأ", "الرجاء إدخال رمز مكون من 6 أرقام",
                                backgroundColor: Colors.red);
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: controller.isVerifying.value
                          ? Colors.grey[400]
                          : AppColors.prussianBlue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: controller.isVerifying.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              Utils.localize('Verify'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditEmailDialog() {
    final TextEditingController emailController =
        TextEditingController(text: controller.loginEmail.value);
    String initialEmail = controller.loginEmail.value;

    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@arrowspeed\.com$');

    RxBool isUpdating = false.obs;

    Get.defaultDialog(
      title: Utils.localize('EditEmail'),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.deepPurple,
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: Utils.localize('NewEmail'),
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                  errorText: !emailRegex.hasMatch(emailController.text) &&
                          emailController.text.isNotEmpty
                      ? Utils.localize('InvalidEmailFormat')
                      : null,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      Utils.localize('Cancel'),
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: emailController,
                    builder: (context, value, child) {
                      bool isChanged = value.text != initialEmail;
                      bool isValidEmail = emailRegex.hasMatch(value.text);

                      return Obx(() {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isValidEmail && isChanged && !isUpdating.value
                                    ? Colors.deepPurple
                                    : Colors.grey[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          onPressed: isValidEmail &&
                                  isChanged &&
                                  !isUpdating.value
                              ? () async {
                                  try {
                                    isUpdating.value = true;

                                    await Future.delayed(Duration(seconds: 1));

                                    await controller
                                        .updateEmail(emailController.text);

                                    Get.back();

                                    Get.snackbar(
                                      "نجاح",
                                      "تم تحديث البريد الإلكتروني بنجاح",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  } catch (e) {
                                    isUpdating.value = false;

                                    Get.snackbar(
                                      Utils.localize('Error'),
                                      e.toString(),
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                }
                              : null,
                          child: isUpdating.value
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  isChanged
                                      ? Utils.localize('Update')
                                      : Utils.localize('OK'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      radius: 15, // حواف ناعمة للحوار
    );
  }
}
