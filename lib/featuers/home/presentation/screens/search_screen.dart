import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/home/presentation/controllers/search_controller.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchTripController>();

    return Scaffold(
  
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('SearchResults'),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredTrips.isEmpty) {
                return Center(
                  child: Text(
                    Utils.localize('NoTripsFound'),
                    style:
                        TextStyle(fontSize: 18, color: AppColors.greyHintForm),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: controller.filteredTrips.length,
                itemBuilder: (context, index) {
                  final trip = controller.filteredTrips[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text('${trip.from} - ${trip.to}'),
                        subtitle: Text(
                            DateFormat('yyyy-MM-dd').format(trip.tripDate)),
                        trailing: Text('${trip.price} \$'),
                      ),
                      Divider(color: AppColors.greyHintForm),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
