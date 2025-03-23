// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/presentation/controllers/edit_profile_controller.dart';
import 'package:arrowspeed/featuers/profile/presentation/widgets/custom_text_form_field_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends GetView<EditProfileController> {
 const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.hasChanges) {
          bool shouldLeave = await _showConfirmDialog(context);
          if (shouldLeave) {
            controller.resetChanges(); 
            return true; 
          } else {
            return false; 
          }
        }
        return true;
      },
      child: Scaffold(
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 265,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.oxfordBlue,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            Utils.localize('editProfile'),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 140,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.zomp,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: controller
                                          .profilePhoto.value.isNotEmpty
                                      ? FileImage(
                                          File(controller.profilePhoto.value))
                                      : AssetImage("assets/logo/logo_color.png")
                                          as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () => _showImageOptions(context),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor: AppColors.oxfordBlue,
                                      child: Icon(Icons.camera_alt,
                                          size: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      CustomTextFormFieldEdit(
                        label: "الاسم الأول",
                        controller: TextEditingController(
                            text: controller.firstName.value),
                        isEnabled: false,
                        onEditPressed: () {
                          _showEditDialog(
                              context, "الاسم الأول", controller.firstName);
                        },
                      ),
                      SizedBox(height: 10),
                      CustomTextFormFieldEdit(
                        label: "الاسم الأخير",
                        controller: TextEditingController(
                            text: controller.lastName.value),
                        isEnabled: false,
                        onEditPressed: () {
                          _showEditDialog(
                              context, "الاسم الأخير", controller.lastName);
                        },
                      ),
                      SizedBox(height: 10),
                      CustomTextFormFieldEdit(
                        label: "رقم الهاتف",
                        controller: TextEditingController(
                            text: controller.mobileNumber.value),
                        isPhoneNumber: true,
                        isEnabled: false,
                        onEditPressed: () {
                          _showEditDialog(
                              context, "رقم الهاتف", controller.mobileNumber);
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            Utils.localize('Gender'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.prussianBlue,
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                Utils.localize('Male'),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyIconForm,
                                ),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  controller.selectedGender.value = 'male';
                                },
                                child: Obx(() => Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.selectedGender.value ==
                                                    'male'
                                                ? AppColors.oxfordBlue
                                                : Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.male,
                                        size: 20,
                                        color:
                                            controller.selectedGender.value ==
                                                    'male'
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              Text(
                                Utils.localize('Female'),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.greyIconForm,
                                ),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  controller.selectedGender.value = 'female';
                                },
                                child: Obx(() => Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.selectedGender.value ==
                                                    'female'
                                                ? AppColors.oxfordBlue
                                                : Colors.grey[200],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.female,
                                        size: 20,
                                        color:
                                            controller.selectedGender.value ==
                                                    'female'
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 70),
                      Obx(() => ElevatedButton(
                            onPressed: controller.hasChanges
                                ? () async {
                                    await controller.saveChanges();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.prussianBlue,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 90),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (controller.isLoading.value)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (controller.isLoading.value)
                                  SizedBox(width: 10),
                                Text(
                                  controller.isLoading.value
                                      ? ""
                                      : "حفظ التعديلات",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String title, RxString field) {
    TextEditingController textController =
        TextEditingController(text: field.value);
    Get.dialog(
      AlertDialog(
        title: Text("تعديل $title"),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: title,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              field.value = textController.text;
              Get.back();
            },
            child: Text("حفظ"),
          ),
        ],
      ),
    );
  }

  void _showImageOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera, color: AppColors.prussianBlue),
              title: Text(
                "التقاط صورة",
                style: TextStyle(color: AppColors.prussianBlue),
              ),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: AppColors.prussianBlue),
              title: Text(
                "اختيار من الاستوديو",
                style: TextStyle(color: AppColors.prussianBlue),
              ),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await Get.defaultDialog(
          title: "تأكيد الخروج",
          middleText: "هل تريد الخروج دون حفظ التغييرات؟",
          textConfirm: "نعم",
          textCancel: "إلغاء",
          confirmTextColor: Colors.white,
          cancelTextColor: AppColors.prussianBlue,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        ) ??
        false;
  }
}
