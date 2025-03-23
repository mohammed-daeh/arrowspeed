// ignore_for_file: prefer_const_constructors

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/booking/presentation/widgets/custom_card_reservation_canceled.dart';
import 'package:arrowspeed/featuers/booking/presentation/widgets/custom_card_reservation_completed.dart';

import 'package:arrowspeed/featuers/booking/presentation/widgets/custom_card_reservation_active.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/booking_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingsScreen extends GetView<BookingController> {
  BookingsScreen({super.key});

  final PageController _pageController = PageController();
  void _scrollToIndex(int index) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('Bookings'),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // controller: _scrollController,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    controller.status.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        controller.currentIndexDay.value = index;
                        _scrollToIndex(index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 80,
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: controller.currentIndexDay.value == index
                              ? AppColors.oxfordBlue
                              : AppColors.oxfordBlue.withAlpha(100),
                        ),
                        child: Text(
                          Utils.localize(controller.status[index]),
                          style: TextStyle(
                            color: controller.currentIndexDay.value == index
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                controller.currentIndexDay.value = index;
                _scrollToIndex(index);
              },
              itemCount: controller.status.length,
              itemBuilder: (context, statusIndex) {
                return Obx(
                  () {
                    final trips = controller.tripsPerDay[statusIndex];

                    if (controller.status[statusIndex] == 'pending') {
                      if (trips.isEmpty) {
                        return Center(
                          child: Text(
                            Utils.localize('NoPendingBookingsFound'),
                            style: TextStyle(
                                fontSize: 18, color: AppColors.oxfordBlue),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 350),
                        itemCount: trips.length,
                        itemBuilder: (context, tripIndex) {
                          final trip = trips[tripIndex];
                          return Container(
                            width: 200,
                            height: 150,
                            color: AppColors.greyIconForm,
                            child: Column(
                              children: [
                                Text(trip.trip?.company ?? 'N/A'),
                                Text(trip.trip?.from ?? 'N/A'),
                                Text(trip.trip?.to ?? 'N/A'),
                                Text(trip.booking.status.toString()),
                              ],
                            ),
                          );
                        
                        },
                      );
                    }
                    if (controller.status[statusIndex] == 'active') {
                      if (trips.isEmpty) {
                        return Center(
                          child: Text(
                            Utils.localize('NoActiveBookingsFound'),
                            style: TextStyle(
                                fontSize: 18, color: AppColors.oxfordBlue),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 350),
                        itemCount: trips.length,
                        itemBuilder: (context, tripIndex) {
                          final trip = trips[tripIndex];
                          return CustomCardReservationActive(
                            iconCompany: trip.trip?.imageUrl! ??
                                'assets/logo/logo_color.png',
                            company: trip.trip?.company ?? 'N/A',
                            from: trip.trip?.from ?? 'N/A',
                            to: trip.trip?.to ?? 'N/A',
                            time: controller.calculateTimeDifference(
                                trip.trip!.departureTime,
                                trip.trip!.arrivalTime),
                            km: controller
                                .calculateDistance(
                                    trip.trip!.latLngFrom.latitude,
                                    trip.trip!.latLngFrom.longitude,
                                    trip.trip!.latLngTo.latitude,
                                    trip.trip!.latLngTo.longitude)
                                .toString(),
                            tripPrice: trip.trip?.price.toString() ?? 'N/A',
                            stateOfTrip:
                                trip.booking.status.toString().split('.').last,
                            name: trip.trip?.company ?? 'N/A',
                            latLng: LatLng(trip.trip!.latLngTo.latitude,
                                trip.trip!.latLngTo.longitude),
                            personCount:
                                trip.booking.passengersCount.toString(),
                            price: trip.booking.totalFare.toString(),
                          );
                        },
                      );
                    }
                    if (controller.status[statusIndex] == 'completed') {
                      if (trips.isEmpty) {
                        return Center(
                          child: Text(
                            Utils.localize('NoCompletedBookingsFound'),
                            style: TextStyle(
                                fontSize: 18, color: AppColors.oxfordBlue),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 350),
                        itemCount: trips.length,
                        itemBuilder: (context, tripIndex) {
                          final trip = trips[tripIndex];
                          return CustomCardReservationCompleted(
                            person: trip.trip?.company ?? 'N/A',
                            stateOfTrip: trip.booking.status.toString(),
                            name: trip.trip?.company ?? 'N/A',
                            from: trip.trip?.from ?? 'N/A',
                            to: trip.trip?.to ?? 'N/A',
                            price: trip.trip?.price.toString() ?? 'N/A',
                            time: trip.trip?.arrivalTime.toString() ?? 'N/A',
                            image: trip.trip?.imageUrl ?? 'N/A',
                          );
                        },
                      );
                    }
                    if (controller.status[statusIndex] == 'cancelled') {
                      if (trips.isEmpty) {
                        return Center(
                          child: Text(
                            Utils.localize('NoCancelledBookingsFound'),
                            style: TextStyle(
                                fontSize: 18, color: AppColors.oxfordBlue),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10, bottom: 350),
                        itemCount: trips.length,
                        itemBuilder: (context, tripIndex) {
                          final trip = trips[tripIndex];
                          return CustomCardReservationCanceled(
                            person: trip.trip?.company ?? 'N/A',
                            stateOfTrip: trip.booking.seatNumbers.toString(),
                            name: trip.trip?.serves.toString() ?? 'N/A',
                            from: trip.trip?.from ?? 'N/A',
                            to: trip.trip?.to ?? 'N/A',
                            price: trip.trip?.price.toString() ?? 'N/A',
                            time: trip.trip?.arrivalTime.toString() ?? 'N/A',
                            image: trip.trip?.imageUrl ?? 'N/A',
                          );
                        },
                      );
                    }
                    return SizedBox();
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
