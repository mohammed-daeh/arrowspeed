import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/home/presentation/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/reservation_controller.dart';

class ConfirmPaymentScreen extends GetView<ReservationController> {
  const ConfirmPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var trip = controller.selectedTrip.value;
    if (trip == null) {
      return Center(child: Text("No trip selected"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.localize('Payment')),
        backgroundColor: AppColors.prussianBlue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ تفاصيل الرحلة
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Utils.localize('BookingDetails'),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    _detailRow(Utils.localize('Company'), trip.company),
                    _detailRow(Utils.localize('From'), trip.from),
                    _detailRow(Utils.localize('To'), trip.to),
                    _detailRow(Utils.localize('TotalPrice'),
                        '\$${controller.totalPrice.value.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(Utils.localize('SelectPaymentMethod'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _paymentOption(Icons.account_balance_wallet, "Local Wallet"),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final BottomNavController toPage = Get.find();

                try {
                  await controller.updateTripSeats(
                      trip.id!, controller.selectedSeats);

                  await controller
                      .activateBooking(controller.pendingBookingId.value);

                  Get.snackbar("Success", Utils.localize('BookingConfirmed'));

                  toPage.changeTabIndex(1);
                } catch (e) {
                  Get.snackbar("Error", "Failed to confirm payment: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.prussianBlue,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(Utils.localize('ConfirmPayment'),
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _paymentOption(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 30, color: AppColors.prussianBlue),
        SizedBox(width: 10),
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
