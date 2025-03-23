import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/controllers/wallet_controller.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrepaidCardPaymentScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());
  final TextEditingController codeController = TextEditingController();

  PrepaidCardPaymentScreen({super.key});

  void redeemCode() {
    if (codeController.text == "1111") {
      walletController.addBalance(1000, "Prepaid Card");

      Get.snackbar("Success", "Prepaid card redeemed successfully!");

      Future.delayed(Duration(seconds: 1), () {
        Get.off(() => PrepaidCardPaymentScreen());
      });
    } else {
      Get.snackbar("Error", "Invalid prepaid card code");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('SelectPayment'),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              children: [
                TextField(
                  controller: codeController,
                  decoration:
                      InputDecoration(labelText: "Enter prepaid card code"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: redeemCode,
                  child: Text("Redeem"),
                ),
              ],
            ),
          ),
          Spacer(
            flex: 1,
          ),
          IconButton(
              onPressed: Get.back, icon: Icon(Icons.access_alarm_outlined))
        ],
      ),
    );
  }
}
