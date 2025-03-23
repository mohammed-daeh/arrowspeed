import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/controllers/wallet_controller.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StripePaymentScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());

  StripePaymentScreen({super.key});

  void makeGooglePay(BuildContext context) async {
    walletController.addBalance(100, "Stripe");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment successful via Stripe",
          style: TextStyle(color: Colors.white),
        ),
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
            title: Utils.localize('StripePayment'),
          ),
          Spacer(
            flex: 1,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => makeGooglePay(context),
              child: Text("Pay \$100 via Stripe"),
            ),
          ),
         
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
