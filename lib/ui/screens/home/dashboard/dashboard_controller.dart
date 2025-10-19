import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iqra/utils/FirebaseHelper.dart';
import 'package:iqra/utils/global.dart';

import '../../../../models/transaction_model.dart';

class DashboardController extends GetxController{
  final transactions = <TransactionModel>[].obs;
  final balance = "---".obs;
  final expense = "---".obs;

  @override
  void onReady() {
    // deposit();
    getTransactions();
    getTotal();
    super.onReady();
  }

  getTotal() async {
    final result = await FirebaseHelper.getTotal();
    debugPrint("getTotal - $result");
    if(result != null){
      balance.value = result.balance.toString();
      expense.value = result.expense.toString();
    }else{
      balance.value = "Error";
      expense.value = "Error";
    }
  }

  getTransactions() async {
    final result = await FirebaseHelper.getTransactions();
    debugPrint("getTransactions - $result");
    if(result != null){
      transactions.assignAll(result);
    }
  }

  deposit() async{
    final time = DateTime.now().millisecondsSinceEpoch;
    final userModel = await FirebaseHelper.getUserModel();
    debugPrint("User - $userModel");
    final model = TransactionModel(
      id: time,
      time: time,
      amount: 10,
      type: TransactionType.WITHDRAWAL,
      by: userModel!,
      admin: userModel
    );
    FirebaseHelper.expense(model);
  }

}