import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/data/models/passenger_model.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/reservation_controller.dart';
import 'package:arrowspeed/featuers/trip/data/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ReservationScreen extends GetView<ReservationController> {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.localize('Reservation')),
        backgroundColor: AppColors.prussianBlue,
      ),
      body: Obx(() {
        var trip = controller.selectedTrip.value;
        if (trip == null) {
          return Center(child: Text("No trip selected"));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Utils.localize('Passengers'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildPassengerSelection(),

                Divider(height: 20, thickness: 1),
                Text(
                  Utils.localize('BusLayout'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 32,
                        color: Colors.black12,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _legendItem(AppColors.greyHintForm, 'Reserved'),
                          SizedBox(width: 16),
                          _legendItem(AppColors.zomp, 'Available',
                              borderColor: AppColors.zomp),
                          SizedBox(width: 16),
                          _legendItem(AppColors.oxfordBlue, 'Book',
                              borderColor: AppColors.oxfordBlue),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            children: [
                              Spacer(
                                flex: 1,
                              ),
                              SvgPicture.asset(
                                'assets/icons/leash.svg',
                                width: 25,
                                height: 25,
                              ),
                              Spacer(
                                flex: 3,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(6, (rowIndex) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: List.generate(2, (colIndex) {
                                      int seatNumber =
                                          (rowIndex * 4) + colIndex + 1;
                                      return seatWidget(
                                          seatNumber, trip, controller);
                                    }),
                                  ),
                                  SizedBox(width: 60),
                                  Row(
                                    children: List.generate(2, (colIndex) {
                                      int seatNumber =
                                          (rowIndex * 4) + colIndex + 3;
                                      return seatWidget(
                                          seatNumber, trip, controller);
                                    }),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 20, thickness: 1),
                Text(Utils.localize('FinancialDetails'),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => Text(
                        'Total Price: \$${controller.totalPrice.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.prussianBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: controller.selectedSeats.isEmpty ||
                            controller.selectedPassengers.isEmpty ||
                            controller.selectedSeats.length !=
                                controller.selectedPassengers.length
                        ? null
                        : () {
                            Get.toNamed(AppRouter.confirmReservation);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.prussianBlue,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    ),
                    child: Text(Utils.localize('ProceedToPayment'),
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget seatWidget(
      int seatNumber, TripModel trip, ReservationController controller) {
    bool isBooked = controller.reservedSeats.contains(seatNumber);
    bool isSelected = controller.selectedSeats.contains(seatNumber);

    return GestureDetector(
      onTap: isBooked ? null : () => controller.toggleSeatSelection(seatNumber),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isBooked
                ? Colors.grey
                : isSelected
                    ? AppColors.oxfordBlue
                    : Colors.white,
            border: Border.all(
              color: isBooked ? Colors.grey : AppColors.mountainMeadow,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            'AsN $seatNumber',
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.mountainMeadow,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label, {Color? borderColor}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
        ),
        SizedBox(width: 8),
        Text(Utils.localize(label),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildPassengerSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            controller
                .togglePassengerListVisibility(); // تبديل حالة عرض القائمة
          },
          child: Obx(() => Container(
                height: 45,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: controller.selectedPassengers.isEmpty
                        ? Colors.red
                        : Colors.grey[300]!,
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.selectedPassengers.isEmpty
                            ? Utils.localize('SelectPassengers')
                            : '${controller.selectedPassengers.length} ${Utils.localize('selected')}',
                        style: TextStyle(
                          color: controller.selectedPassengers.isEmpty
                              ? Colors.grey[600]
                              : AppColors.oxfordBlue,
                          fontSize:
                              controller.selectedPassengers.isEmpty ? 14 : 16,
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      controller.isPassengerListVisible.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Color(0xFF2A5C82),
                    ),
                  ],
                ),
              )),
        ),
        Obx(
          () => controller.isPassengerListVisible.value
              ? Column(
                  children:
                      controller.passengers.map((PassengerModel passenger) {
                    bool isSelected = controller.selectedPassengers
                        .any((p) => p.id == passenger.id);
                    return CheckboxListTile(
                      title: Text(passenger.name),
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value != null) {
                          if (value) {
                            controller.addPassenger(passenger);
                          } else {
                            controller.removePassenger(passenger);
                          }
                        }
                      },
                    );
                  }).toList(),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
