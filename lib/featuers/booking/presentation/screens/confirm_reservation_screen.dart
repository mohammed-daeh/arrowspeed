import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/booking/presentation/controllers/reservation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmReservationScreen extends GetView<ReservationController> {

const ConfirmReservationScreen({super.key});
// class ConfirmReservationScreen extends StatelessWidget {
//   final ReservationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.localize('ConfirmReservation')),
        backgroundColor: AppColors.prussianBlue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ أسئلة شائعة
            _questionWidget("Do you have large luggage?", onChanged: (value) {}),
            _questionWidget("Do you need a taxi after arrival?", onChanged: (value) {}),
            _questionWidget("Do you agree to the terms and conditions?", onChanged: (value) {}),

            SizedBox(height: 20),

            // ✅ زر المتابعة إلى الدفع
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRouter.confirmPayment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.prussianBlue,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(Utils.localize('ProceedToPayment'), style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionWidget(String question, {required Function(bool?) onChanged}) {
    return Row(
      children: [
        Expanded(child: Text(question, style: TextStyle(fontSize: 16))),
        Checkbox(
          value: false,
          onChanged: onChanged,
        ),
      ],
    );
  }
}