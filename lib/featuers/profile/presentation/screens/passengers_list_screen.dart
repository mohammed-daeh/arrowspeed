// ignore_for_file: avoid_print, deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:arrowspeed/featuers/profile/presentation/controllers/passenger_controller.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PassengersListScreen extends GetView<PassengerController> {
  const PassengersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 130),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildPassengerList(),
                  Container(
                    color: Colors.red,
                    height: 50,
                    width: 200,
                  ),
                  Obx(() {
                    if (!controller.isLoading.value) {
                      print('controller.isLoading.value');
                      return SizedBox(); 
                    }
                    return Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.greyHintForm, blurRadius: 10)
                          ],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.greyborder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: controller.nameController,
                              label: controller.nameError.value ??
                                  Utils.localize('Name'),
                              errorText: controller.nameError.value,
                              onChanged: (value) =>
                                  controller.validateName(value),
                            ),
                            const SizedBox(height: 10),

                            _buildTextField(
                              controller: controller.ageController,
                              label: Utils.localize('Age'),
                              errorText: controller.ageError.value,
                              isNumber: true,
                              onChanged: (value) =>
                                  controller.validateAge(value),
                            ),
                           
                            const SizedBox(height: 10),
                            _buildGenderRadio(),
                          
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return _buildActionButton(
                                    Utils.localize('Save'),
                                    AppColors.zomp,
                                    controller.isSaving.value,
                                    controller.isSaving.value
                                        ? null 
                                        : () async {
                                            controller.isSaving.value =
                                                true; 
                                            await controller
                                                .addPassenger(); 
                                            controller.isSaving.value =
                                                false; 
                                          },
                                  );
                                }),
                                const SizedBox(width: 20),

                                _buildActionButton(
                                  Utils.localize('Cancel'),
                                  AppColors.red.withAlpha(150),
                                  controller
                                      .isSaving.value, 
                                  controller.isSaving.value
                                      ? null 
                                      : () async {
                                          controller.isLoading(
                                              false); 
                                          controller.isSaving(false);
                                          controller.clearTextFields();
                                        },
                                ),

                               
                              ],
                            ),
                          ],
                        ));
                  }),
                ],
              ),
            ),
          ),
          Positioned(
            child: Column(
              children: [
                HeaderScreensInItemsProfile(
                  height: 100,
                  title: Utils.localize('PassengersList'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      controller.isLoading(true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset('assets/icons/plus.svg',
                            width: 20, height: 20),
                        const SizedBox(width: 10),
                        Text(Utils.localize('AddPassenger'),
                            style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerList() {
    return StreamBuilder<List<PassengerModel>>(
      stream: controller
          .getAllPassengers(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ!'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('لا يوجد ركاب مضافين.'));
        }

        final passengers = snapshot.data!;
        return ListView.builder(
            shrinkWrap: true, 
            physics:
                NeverScrollableScrollPhysics(), 

            itemCount: passengers.length,
            itemBuilder: (context, index) {
              final passenger = passengers[index];

              return Obx(
                () => GestureDetector(
                  onTap: () {
                    print('*****************************$index');
                  },
                  onLongPress: () {
                    controller.toggleEditPassenger(
                        index); 
                  },
                  child: controller.isEditing.value == index
                      ? _buildPassengerForm(context, passenger, index)
                      : _buildPassengerCard(
                          name: passenger.name,
                          age: passenger.age,
                          gender: passenger.gender.toString().split('.').last,
                          id: passenger.id,
                        ),
                ),
              );
            });
      },
    );
  }

  void showDeleteDialog(BuildContext context, String passengerId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: SvgPicture.asset(
            'assets/icons/FAQ&Support.svg',
            color: AppColors.red,
            width: 40,
            height: 40,
          ),
          title: Text(Utils.localize('DeletePassenger')),
          content: Text(Utils.localize('Areyousure')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(Utils.localize('Cancel')),
            ),
            TextButton(
              onPressed: () {
                controller.deletePassenger(passengerId);
                Navigator.of(context).pop();
              },
              child: Text(Utils.localize('Delete'),
                  style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPassengerForm(
    BuildContext context,
    PassengerModel passenger,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.greyHintForm, blurRadius: 10)],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyborder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: controller.nameController,
            label: Utils.localize('Name'),
            errorText: controller.nameError.value,
            onChanged: (value) => controller.validateName(value),
          ),
          const SizedBox(height: 10),

          _buildTextField(
            controller: controller.ageController,
            label: Utils.localize('Age'),
            errorText: controller.ageError.value,
            isNumber: true,
            onChanged: (value) => controller.validateAge(value),
          ),
        
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                Utils.localize('Gender'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
            ],
          ),
        ],
      ),
    );
  }

  // دالة لإنشاء خيار الجنس
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

  Widget _buildGenderRadio() {
    return Row(
      children: [
        Text(
          Utils.localize('Gender'),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
    );
  }


  Widget _buildActionButton(
    String text,
    Color color,
    bool isLoading,
    Future<void> Function()? onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: isLoading
            ? null
            : () {
                if (onTap != null) {
                  onTap();
                }
              },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLoading ? color.withOpacity(0.5) : color.withAlpha(150),
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }


  Widget _buildPassengerCard(
      {String? name, String? age, String? gender, String? id}) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.greyHintForm, blurRadius: 10),
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.greyborder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.zomp.withAlpha(150),
            child: Text(
              name != null && name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name != null && name.isNotEmpty
                    ? name.toUpperCase()
                    : 'غير محدد',
                style: const TextStyle(
                    fontSize: 18, color: AppColors.prussianBlue),
              ),
              Row(
                children: [
                  Text(
                    '${age != null && age.isNotEmpty ? age : 'غير محدد'} years',
                    style:
                        TextStyle(fontSize: 15, color: AppColors.greyIconForm),
                  ),
                  SizedBox(width: 5),
                  Text(
                    ', ${gender ?? 'غير محدد'}',
                    style:
                        TextStyle(fontSize: 15, color: AppColors.greyIconForm),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              if (id != null) {
                showDeleteDialog(
                    Get.context!, id); 
              } else {
                Get.snackbar("خطأ", "المعرف غير موجود");
              }
            },
            child: SvgPicture.asset('assets/icons/delete.svg',
                width: 20, height: 20, color: AppColors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? errorText,
    bool isNumber = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    Color borderColor = AppColors.greyIconForm;
    if (errorText != null) {
      borderColor = AppColors.red;
    }

    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: errorText ?? label,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: AppColors.oxfordBlue,
        ),
        labelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: errorText != null ? AppColors.red : AppColors.zomp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: AppColors.oxfordBlue,
            width: 1,
          ),
        ),
        filled: true,
        fillColor: AppColors.white,
        errorText: errorText,
      ),
    );
  }


}
