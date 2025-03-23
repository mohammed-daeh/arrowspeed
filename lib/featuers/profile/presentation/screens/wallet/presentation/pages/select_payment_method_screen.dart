// ignore_for_file: must_be_immutable

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/pages/google_pay_payment_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/pages/prepaid_card_payment_screen.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/pages/stripe_payment_screen.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeaderScreensInItemsProfile(
            height: 100,
            title: Utils.localize('SelectPayment'),
          ),
          Spacer(
            flex: 2,
          ),
          InkwellContainer(
            title: 'PaywithStripe',
            icon: Icon(Icons.credit_card),
            onTap: () => Get.to(() => StripePaymentScreen()),

          ),
          InkwellContainer(
            title: 'PaywithGooglePay',
            icon: Icon(Icons.payments),
            onTap: () => Get.to(() => GooglePayPaymentScreen()),
          ),
          InkwellContainer(
            title: 'UsePrepaidCard',
            icon: Icon(Icons.card_giftcard),
            onTap: () => Get.to(() => PrepaidCardPaymentScreen()),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
}

class InkwellContainer extends StatelessWidget {
  InkwellContainer({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });

  VoidCallback onTap;
  String title;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          decoration: BoxDecoration(color: AppColors.white, boxShadow: [
            BoxShadow(
              color: AppColors.greyHintForm,
              blurRadius: 10,
            )
          ]),
          child: Row(
            children: [
              icon,
              SizedBox(
                width: 15,
              ),
              Text(
                Utils.localize(title),
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
