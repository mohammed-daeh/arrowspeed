import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:arrowspeed/featuers/trip/presentation/controllers/trip_controller.dart';
import 'package:arrowspeed/featuers/trip/presentation/widget/card_trip_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripsScreen extends GetView<TripsController> {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('Tripes'),
          ),
          const SizedBox(height: 15),

          Obx(() => SingleChildScrollView(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    controller.weekDays.length,
                    (index) {
                      DateTime day = controller.weekDays[index];
                      bool isSelected =
                          controller.currentIndexDay.value == index;

                      return GestureDetector(
                        onTap: () {
                          controller.selectDay(day, index);
                          controller.pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 90,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isSelected
                                ? AppColors.oxfordBlue
                                : AppColors.oxfordBlue.withAlpha(100),
                          ),
                          child: Text(
                            Utils.localize(DateFormat('EEE').format(day)),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )),

          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.weekDays.length,
              onPageChanged: (index) {
                controller.selectDay(controller.weekDays[index], index);

                controller.scrollController.animateTo(
                  index * 103.0, 
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              itemBuilder: (context, index) {
                return Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var trips = controller.filteredTrips;
                  if (trips.isEmpty) {
                    return Center(
                      child: Text(
                        Utils.localize('ThereAreNo'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.prussianBlue,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.listenToTrips();
                      controller
                          .resetScroll(); 
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        var trip = trips[index];
                        String servicesText = trip.serves.join(", ");

                        return CardTripWidget(
                          onTap: () {
                            Get.toNamed(AppRouter.reservation, arguments: trip);
                          },
                          company: trip.company,
                          iconCompany:
                              trip.imageUrl ?? "assets/logo/logo_color.png",
                          serves: servicesText,
                          discount: trip.discount.toString(),
                          dateFrom:
                              "${trip.departureTime.hour}:${trip.departureTime.minute.toString().padLeft(2, '0')}",
                          dateTo:
                              "${trip.arrivalTime.hour}:${trip.arrivalTime.minute.toString().padLeft(2, '0')}",
                          from: trip.from,
                          to: trip.to,
                          totalSeats: trip.availableSeats!,
                          price: trip.price,
                          star: trip.star.toString(),
                        );
                      },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
