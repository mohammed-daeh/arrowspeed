// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_trip_admin_controller.dart';

class AddTripScreen extends GetView<AddTripAdminController> {
  const AddTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('AddTrip'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSection("TripInformation", Icons.directions_bus),
                    _buildCompanySelection(),
                    SizedBox(height: 10),
                    _buildServiceSelection(),
                    _buildSection(
                      "TripDetails",
                      Icons.attach_money,
                    ),
                    _buildNumericField("DiscountPercentage (%)",
                        controller.discount, Icons.percent,
                        isDouble: false),
                    SizedBox(height: 10),
                    _buildNumericField(
                        "ُEvaluation", controller.star, Icons.star,
                        isDouble: false),
                    SizedBox(height: 10),
                    _buildNumericField(
                        "Passengers", controller.pessenger, Icons.people),
                    SizedBox(height: 10),
                    _buildNumericField(
                        "PriceTicket", RxNum(0), Icons.monetization_on,
                        isDouble: true,
                        textCntroller: controller.priceController),
                    _buildSection("TripTime", Icons.schedule),
                    _buildDateSelection(context),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: _buildTimeSelection(
                                context, "Launching Time", true)),
                        SizedBox(width: 7),
                        Expanded(
                            child: _buildTimeSelection(
                                context, "Arrival Time", false)),
                      ],
                    ),
                    _buildSection("TripLocation", Icons.location_on),
                    Row(
                      children: [
                        Expanded(
                            child: _buildCitySelection(
                                context, Utils.localize("From"), true)),
                        SizedBox(width: 7),
                        Expanded(
                            child: _buildCitySelection(
                                context, Utils.localize("To"), false)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => InkWell(
                        onTap: controller.addition,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          decoration: BoxDecoration(
                            color: controller.canSubmit.value
                                ? AppColors.mountainMeadow.withAlpha(100)
                                : AppColors.greyIconForm,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            Utils.localize('AddTheTrip'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 2),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF2A5C82), size: 15),
          SizedBox(width: 8),
          Text(
            Utils.localize(title),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySelection() {
    return InkWell(
      onTap: () => _showCompanyDialog(),
      child: Obx(() => Container(
            height: 45,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: controller.isCompanyError.value
                    ? Colors.red
                    : Colors.grey[300]!,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.selectedCompany.value.isEmpty
                        ? Utils.localize('Company')
                        : controller.selectedCompany.value,
                    style: TextStyle(
                      color: controller.selectedCompany.isEmpty
                          ? Colors.grey[600]
                          : AppColors.oxfordBlue,
                      fontSize: controller.selectedCompany.isEmpty ? 14 : 16,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down, color: Color(0xFF2A5C82)),
              ],
            ),
          )),
    );
  }

  void _showCompanyDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(Utils.localize('ChooseCompany'),
            style: TextStyle(fontSize: 18)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.companies.length,
            itemBuilder: (context, index) {
              return Obx(() => RadioListTile(
                    title: Text(controller.companies[index]),
                    value: controller.companies[index],
                    groupValue: controller.selectedCompany.value,
                    onChanged: (value) {
                      controller.selectCompany(value!);
                      Get.back();
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return InkWell(
      onTap: () => _showServiceDialog(),
      child: Obx(() => Container(
            height: 45,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: controller.isServiceError.value
                    ? Colors.red
                    : Colors.grey[300]!,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.selectedServices.isEmpty
                        ? Utils.localize('TripServices')
                        : controller.selectedServices.join(", "),
                    style: TextStyle(
                      color: controller.selectedServices.isEmpty
                          ? Colors.grey[600]
                          : AppColors.oxfordBlue,
                      fontSize: controller.selectedServices.isEmpty ? 14 : 16,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_down, color: Color(0xFF2A5C82)),
              ],
            ),
          )),
    );
  }

  void _showServiceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(Utils.localize('ChooseServices')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              return Obx(() => CheckboxListTile(
                    title: Text(Utils.localize(controller.services[index])),
                    value: controller.selectedServices
                        .contains(controller.services[index]),
                    onChanged: (value) {
                      controller.toggleService(controller.services[index]);
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNumericField(String label, Rx<num> value, IconData icon,
      {bool isDouble = false, TextEditingController? textCntroller}) {
    final TextEditingController controller = TextEditingController();

    return Obx(() {
      // تحديث النص فقط إذا تغيرت القيمة في Rx
      if (controller.text != value.value.toString()) {
        controller.text = value.value == 0 ? '' : value.value.toString();
      }

      return SizedBox(
        height: 45,
        child: TextFormField(
          controller: textCntroller ?? controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: AppColors.oxfordBlue, fontSize: 16),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Color(0xFF2A5C82),
              size: 18,
            ),
            labelText: Utils.localize(label),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.oxfordBlue, width: 1.0),
              borderRadius: BorderRadius.circular(5),
            ),
            labelStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          onChanged: (text) {
            if (isDouble) {
              if (RegExp(r'^\d*\.?\d*$').hasMatch(controller.text)) {
                value.value = double.tryParse(controller.text) ?? 0.0;
              }
            } else {
              if (RegExp(r'^\d*$').hasMatch(controller.text)) {
                value.value = int.tryParse(controller.text) ?? 0;
              }
            }
          },
      
        ),
      );
    });
  }

  Widget _buildDateSelection(BuildContext context) {
    return InkWell(
      onTap: () => controller.selectTripDate(context),
      child: Obx(() => Container(
            height: 45,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: controller.isDateError.value
                    ? Colors.red
                    : Colors.grey[300]!,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.tripDate.value != null
                        ? controller.tripDate.value!
                            .toLocal()
                            .toString()
                            .split(' ')[0]
                        : Utils.localize('ChooseDate'),
                    style: TextStyle(
                      color: controller.tripDate.value != null
                          ? AppColors.oxfordBlue
                          : Colors.grey[600],
                      fontSize: controller.tripDate.value != null ? 16 : 14,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Icons.date_range, color: Color(0xFF2A5C82), size: 18),
              ],
            ),
          )),
    );
  }

  Widget _buildTimeSelection(BuildContext context, String label, bool isFrom) {
    return InkWell(
      onTap: () => controller.selectTime(context, isFrom),
      child: Obx(() => Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: controller.isTimeError.value
                    ? Colors.red
                    : Colors.grey[300]!,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${isFrom ? Utils.localize('Launching') : Utils.localize('Arrival')}: ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text('   '),
                          Text(
                            isFrom
                                ? (controller.dateFrom.value != null
                                    ? "${controller.dateFrom.value!.hour}:${controller.dateFrom.value!.minute}"
                                    : Utils.localize('SelectTime'))
                                : (controller.dateTo.value != null
                                    ? "${controller.dateTo.value!.hour}:${controller.dateTo.value!.minute}"
                                    : Utils.localize('SelectTime')),
                            style: TextStyle(
                              color: AppColors.oxfordBlue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.access_time,
                  color: Color(0xFF2A5C82),
                  size: 18,
                ),
              ],
            ),
          )),
    );
  }
  

  Widget _buildCitySelection(BuildContext context, String label, bool isFrom) {
    return InkWell(
      onTap: () => _showCityDialog(isFrom),
      child: Obx(() => Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: controller.isCityError.value
                    ? Colors.red
                    : Colors.grey[300]!,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$label: ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Row(
                        children: [
                          Text('   '),
                          Text(
                            isFrom
                                ? Utils.localize(controller.selectedFrom.value)
                                : Utils.localize(controller.selectedTo.value),
                            style: TextStyle(
                              color: AppColors.oxfordBlue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.location_on,
                  color: Color(0xFF2A5C82),
                  size: 18,
                ),
              ],
            ),
          )),
    );
  }

  void _showCityDialog(bool isFrom) {
    Get.dialog(
      AlertDialog(
        title: Text(Utils.localize('ChooseCity')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.cities.keys.length,
            itemBuilder: (context, index) {
              String city = controller.cities.keys.elementAt(index);
              return Obx(() => RadioListTile(
                    title: Text(Utils.localize(city)),
                    value: city,
                    groupValue: isFrom
                        ? controller.selectedFrom.value
                        : controller.selectedTo.value,
                    onChanged: (value) {
                      controller.selectCity(isFrom, value!);
                      Get.back();
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }
}

