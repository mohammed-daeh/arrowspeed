// ignore_for_file: avoid_print, sort_child_properties_last

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/home/presentation/controllers/search_controller.dart';
import 'package:arrowspeed/featuers/home/presentation/screens/widgets/custom_text_field_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoxSearchTravil extends StatelessWidget {
  const BoxSearchTravil({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchTripController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.white,
        boxShadow: [BoxShadow(color: AppColors.greyIconForm, blurRadius: 1)],
      ),
      child: Column(
        children: [
          CustomTextFieldSearch(
            hintText: Utils.localize('From'),
            iconPath: 'assets/icons/bas_from.svg',
            readOnly: true,
            controller: controller.fromController, 
            onTap: () => _showCityPickerDialog(
              context,
              controller.cities,
              (selectedCity) {
                controller.from.value = selectedCity; 
                controller.updateControllers(); 
              },
              'SelectYourStartingCity',
            ),
            iconOnTap: () => controller.clearField('from'),
          ),
          CustomTextFieldSearch(
            hintText: Utils.localize('To'),
            iconPath: 'assets/icons/bas_to.svg',
            readOnly: true,
            controller: controller.toController, 
            onTap: () => _showCityPickerDialog(
              context,
              controller.cities,
              (selectedCity) {
                controller.to.value = selectedCity; 
                controller.updateControllers(); 
              },
              "SelectTheArrivalCity",
            ),
            iconOnTap: () => controller.clearField('to'),
          ),
          CustomTextFieldSearch(
            hintText: Utils.localize('Date'),
            iconPath: 'assets/icons/date.svg',
            isDatePicker: true,
            readOnly: true,
            controller: controller.dateController,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                controller.tripDate.value = pickedDate; 
                controller.updateControllers(); 
              }
            },
            iconOnTap: () => controller.clearField('date'),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              await controller.searchTrips();
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.oxfordBlue,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: Text(
                Utils.localize('SearchBusses'),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCityPickerDialog(BuildContext context, List<String> cities,
      Function(String) onSelect, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Utils.localize(title)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(Utils.localize(cities[index])),
                  onTap: () {
                    onSelect(cities[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
