import 'package:arrowspeed/featuers/profile/presentation/screens/wallet/data/models/transaction_model.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  var balance = 1500.0.obs;
  var transactions = <TransactionModel>[].obs;

  void addBalance(double amount, String method) {
    balance.value += amount;
    transactions.add(TransactionModel(
      amount: amount,
      method: method,
      date: DateTime.now(),
    ));
    update();
  }
}
