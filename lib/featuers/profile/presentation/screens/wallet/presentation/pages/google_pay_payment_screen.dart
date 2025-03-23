
import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/controllers/wallet_controller.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GooglePayPaymentScreen extends StatelessWidget {
  GooglePayPaymentScreen({super.key});
  final WalletController walletController = Get.put(WalletController());

  void makeGooglePay(BuildContext context) async {
    walletController.addBalance(150, "Google Pay");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment successful via Google Pay",
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: AppColors.oxfordBlue,
      ),
    );


    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: "GooglePayPayment",
          ),
          SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () => makeGooglePay(context),
              child: Text("Pay \$150 via Google Pay"),
            ),
          ),
        ],
      ),
    );
  }
}
