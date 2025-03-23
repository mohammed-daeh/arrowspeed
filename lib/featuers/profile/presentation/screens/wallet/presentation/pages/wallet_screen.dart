// ignore_for_file: deprecated_member_use

import 'package:arrowspeed/core/app_colors/app_colors.dart';
import 'package:arrowspeed/core/app_router/app_router.dart';
import 'package:arrowspeed/core/translation/translation.dart';
import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/presentation/controllers/wallet_controller.dart';
import 'package:arrowspeed/sheard/widgets/custom_header_screens_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});
  final WalletController walletController = Get.put(WalletController());

  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'payment',
      'date': '2025-02-27',
      'amount': '\$250.00',
      'trip': 'Trip to Dubai',
    },
    {
      'type': 'top-up',
      'date': '2025-02-26',
      'amount': '\$500.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderScreensInItemsProfile(
            title: Utils.localize('Wallet'),
            height: 100,
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 140,
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.zomp,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.localize('Yourcurrentbalance'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                              ),
                              Obx(() => BalanceText(
                                  amount: walletController.balance.value)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -0,
                      right: 0,
                      left: 0,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRouter.selectPayment);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/plus-circle.svg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  Utils.localize('RecentTransactions'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.oxfordBlue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionItem(transaction);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    bool isPayment = transaction['type'] == 'payment';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: Icon(
          isPayment ? Icons.payment : Icons.account_balance_wallet,
          color: isPayment ? Colors.red : Colors.green,
          size: 30,
        ),
        title: Text(
          transaction['trip'] ?? Utils.localize('WalletTopUp'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(transaction['date'],
            style: TextStyle(fontSize: 14, color: Colors.grey)),
        trailing: Text(
          transaction['amount'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPayment ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}

class BalanceText extends StatelessWidget {
  final double amount;

  const BalanceText({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    String currentLocale = Get.locale?.languageCode ?? 'en';

    String formattedAmount = NumberFormat.currency(
      locale: currentLocale,
      symbol: '',
      decimalDigits: 2,
    ).format(amount);

    String currencySymbol = currentLocale == 'ar' ? ' دولار' : ' \$';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: formattedAmount,
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
            ),
          ),
          TextSpan(
            text: currencySymbol,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
